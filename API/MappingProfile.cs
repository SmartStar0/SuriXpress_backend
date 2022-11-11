using API.DTO.Users;
using AutoMapper;
using Domain.Entities.Users;

namespace API
{
    public class MappingProfile: Profile
    {

        public MappingProfile()
        {
            CreateMap<UserRegistrationDto, User>()
        .ForMember(u => u.UserName, opt => opt.MapFrom(x => x.Email));


            CreateMap<UserAuthenticationDto, User>()
        .ForMember(u => u.UserName, opt => opt.MapFrom(x => x.Email));
        }
    }
}
