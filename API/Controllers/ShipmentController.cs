using AutoMapper;
using Domain.Interfaces;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace API.Controllers
{
    
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class ShipmentController : ControllerBase
    { 

        private readonly IShipmentRepository _shipmentrepo;
        public ShipmentController(IShipmentRepository ShipmentRepo)
        {

            _shipmentrepo = ShipmentRepo;

        }



        // GET: api/<ShipmentController>
        [HttpGet("list")]
        public async Task<IActionResult> GetAllShipmentsAsync()
        {
           try
            {

                var shipments = await _shipmentrepo.GetAllShipments();
                return Ok(shipments);

            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);

            }
        }

        [HttpGet("detail")]
        [Authorize(Roles = Roles.Admin)]
        public async Task<IActionResult> GetShipmentDetailsAsync()
        {
            try
            {

                var shipments = await _shipmentrepo.GetAllShipments();
                return Ok(shipments);

            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);

            }
        }
    }
}
