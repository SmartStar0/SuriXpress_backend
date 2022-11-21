using Dapper;
using Domain.Entities.Shipments;
using Domain.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Infrastructure.Data.Repositories
{
    public class ShipmentRepository : IShipmentRepository
    {

        private readonly AppDbContext _context;

        public ShipmentRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Shipment>> GetAllShipments()
        {
            var query = "SELECT * FROM dbo.Shipment";

            using(var connection = _context.CreateConnection())
            {
                var shipments = await connection.QueryAsync<Shipment>(query);
                return shipments.ToList();

            }
        }

     
    }
}
