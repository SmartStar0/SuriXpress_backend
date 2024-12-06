using API.DTO.Users;
using AutoMapper;
using Domain.Entities.Users;
using Domain.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountsController : ControllerBase
    {
        
    private readonly UserManager<User> _userManager;
    private readonly IMapper _mapper;
    private readonly IJWTTokenRepository _jwttokenrepo;
        public AccountsController(UserManager<User> userManager, IMapper mapper, IJWTTokenRepository jwttokenrepo)
        {
            _userManager = userManager;
            _mapper = mapper;
            _jwttokenrepo = jwttokenrepo;
        }

        [HttpPost("Registration")]
        public async Task<IActionResult> RegisterUser([FromBody] UserRegistrationDto userRegistration)
        {
            if (userRegistration == null || !ModelState.IsValid)
                return BadRequest();

            var user = _mapper.Map<User>(userRegistration);
            var result = await _userManager.CreateAsync(user, userRegistration.Password);
            if (!result.Succeeded)
            {
                var errors = result.Errors.Select(e => e.Description);

                return BadRequest(new RegistrationResponseDto { Errors = errors });
            }

            await _userManager.AddToRoleAsync(user, Roles.Customer);

            var token = await _jwttokenrepo.GetJWTTokenAsync(user.Email);
            return Ok(new AuthResponseDto { IsAuthSuccessful = true, Token = token, FirstName = user.Firstname, LastName = user.Lastname, Email = user.Email, Roles = Roles.Customer });
        }

        [HttpPost("Login")]
        public async Task<IActionResult> Login([FromBody] UserAuthenticationDto userAuthentication)
        {
            var user = await _userManager.FindByNameAsync(userAuthentication.Email);
            if (user == null || !await _userManager.CheckPasswordAsync(user, userAuthentication.Password))
            return Unauthorized(new AuthResponseDto { ErrorMessage = "Invalid Authentication" });

            var roles = await _userManager.GetRolesAsync(user);
            var token = await _jwttokenrepo.GetJWTTokenAsync(userAuthentication.Email);
            return Ok(new AuthResponseDto {IsAuthSuccessful = true, Token = token, FirstName = user.Firstname, LastName = user.Lastname, Email = user.Email, Roles = string.Join(",", roles) });

        }
    }
}

