using API.DTO.Users;
using Domain.Entities.Users;
using Infrastructure.Data;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace API.Controllers
{
    public class TokenController : Controller
    {
        private readonly AuthDbContext _context;
        private readonly UserManager<User> _userManger;
        private readonly IConfiguration _configuration;
        private readonly IConfigurationSection _jwtSettings;


        public TokenController(AuthDbContext context, UserManager<User> userManger, IConfiguration configuration)
        {
            _context = context;
            _userManger = userManger;
            _configuration = configuration;
            _jwtSettings = _configuration.GetSection("JwtSettings");
            _configuration = configuration;
        }


        [Route("api/token")]
        [HttpPost]
        public async Task<IActionResult> Create(string username, string password)
        {
            if(await IsValidatedUsernameAndPassword(username, password))
            {
                return new ObjectResult(await GenerateToken(username));

            }
            else
            {

               return BadRequest();
            }

        }

        private async Task<bool>IsValidatedUsernameAndPassword (string username, string password)
        {
            var user = await _userManger.FindByEmailAsync (username);
            return await _userManger.CheckPasswordAsync (user, password);

        }


        private async Task<dynamic> GenerateToken(string username)
        {
          
            var user = await _userManger.FindByEmailAsync(username);
            var roles = from ur in _context.UserRoles
                        join r in _context.Roles on ur.RoleId equals r.Id
                        where ur.UserId == user.Id
                        select new { ur.UserId, ur.RoleId, r.Name };




            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, username),
                new Claim(ClaimTypes.NameIdentifier, user.Id),
                new Claim(JwtRegisteredClaimNames.Nbf,new DateTimeOffset(DateTime.Now).ToUnixTimeSeconds().ToString()),
                new Claim(JwtRegisteredClaimNames.Exp,new DateTimeOffset(DateTime.Now.AddDays(1)).ToUnixTimeSeconds().ToString())
            };

            foreach(var role in roles)
            {
               claims.Add(new Claim(ClaimTypes.Role, role.Name));

            }

            var token = new JwtSecurityToken(
                            new JwtHeader(
                                 new SigningCredentials(
                                     new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtSettings.GetSection("securityKey").Value)),
                                     SecurityAlgorithms.HmacSha256)),
                            new JwtPayload(claims));


            var output = new
            {
                Access_token = new JwtSecurityTokenHandler().WriteToken(token),
                UserName = username

            };

            return output;
        }

    }
}
