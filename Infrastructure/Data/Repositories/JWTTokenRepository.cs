using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.Interfaces;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using Domain.Entities.Users;
using Microsoft.Extensions.Configuration;
using System.Security.Claims;

namespace Infrastructure.Data.Repositories
{
    public class JWTTokenRepository : IJWTTokenRepository
    {

        private readonly AuthDbContext _context;
        private readonly UserManager<User> _userManager;
        private readonly IConfiguration _configuration;
        private readonly IConfigurationSection _jwtSettings;


        public JWTTokenRepository(AuthDbContext context, UserManager<User> userManager, IConfiguration configuration)
        {
            _context = context;
            _userManager = userManager;
            _configuration = configuration;
            _jwtSettings = _configuration.GetSection("JwtSettings");
        }

        public async Task<string> GetJWTTokenAsync(string username)
        {

            var user = await _userManager.FindByEmailAsync(username);
            var roles = from ur in _context.UserRoles
                        join r in _context.Roles on ur.RoleId equals r.Id
                        where ur.UserId == user.Id
                        select new { ur.UserId, ur.RoleId, r.Name };

            var claims = new List<Claim>
            {
                new Claim("Name", username),
                new Claim("NameIdentifier", user.Id),
                new Claim(JwtRegisteredClaimNames.Nbf,new DateTimeOffset(DateTime.Now).ToUnixTimeSeconds().ToString()),
                new Claim(JwtRegisteredClaimNames.Exp,new DateTimeOffset(DateTime.Now.AddDays(1)).ToUnixTimeSeconds().ToString()),
                new Claim(JwtRegisteredClaimNames.Aud, _jwtSettings.GetSection("validAudience").Value),
                new Claim(JwtRegisteredClaimNames.Iss, _jwtSettings.GetSection("validIssuer").Value)
            };

            foreach (var role in roles)
            {
                claims.Add(new Claim("Role", role.Name));

            }

            var tokenOptions = new JwtSecurityToken(
                            new JwtHeader(
                                 new SigningCredentials(
                                     new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtSettings.GetSection("securityKey").Value)),
                                     SecurityAlgorithms.HmacSha256)),
                            new JwtPayload(claims));

            return new JwtSecurityTokenHandler().WriteToken(tokenOptions);
        }
    }
}