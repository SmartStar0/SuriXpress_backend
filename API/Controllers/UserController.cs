using API.DTO;
using API.DTO.Users;
using AutoMapper;
using Domain.Entities.Users;
using Domain.Interfaces;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace API.Controllers
{
    
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class UserController : ControllerBase
    {

        private readonly UserManager<User> _userManager;
        private readonly IMapper _mapper;
        public UserController(UserManager<User> userManager, IMapper mapper)
        {
            _userManager = userManager;
            _mapper = mapper;
        }



        // GET: api/<UserController>
        [HttpGet("list")]
        public async Task<IActionResult> GetAllUsersAsync()
        {
           try
            {
                // get users with roles
                var users = _userManager.Users.ToList().Select(c => new UserDto()
                {
                    Id = c.Id,
                    FirstName = c.Firstname,
                    LastName = c.Lastname,
                    UserName = c.UserName,
                    Email = c.Email,
                    Roles = _userManager.GetRolesAsync(c).Result
                }).ToList();
                return Ok(users);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpPost("update")]
        public async Task<IActionResult> UpdateUserAsync(UserDto user)
        {
            try
            {
                var identityUser = await _userManager.FindByIdAsync(user.Id);
                if(!string.IsNullOrEmpty(user.FirstName))
                    identityUser.Firstname = user.FirstName;

                if (!string.IsNullOrEmpty(user.LastName))
                    identityUser.Lastname = user.LastName;

                if (!string.IsNullOrEmpty(user.Email))
                    identityUser.Email = user.Email;

                // update user info
                await _userManager.UpdateAsync(identityUser);

                // remove existing roles from user
                await _userManager.RemoveFromRolesAsync(identityUser,new List<string> { Roles.Admin , Roles.Customer });

                // add new roles to user
                foreach (var role in user.Roles)
                {
                    await _userManager.AddToRoleAsync(identityUser, role);
                }

                return Ok(new ResponseDto { Success = true, Message = "User updated successfully!!" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
    }
}
