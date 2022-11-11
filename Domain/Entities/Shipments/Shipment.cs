using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities.Shipments
{
    public class Shipment
    {
        public Guid Id { get; set; }
        public string? Shipmentnumber { get; set; }
        public string? ShipmentAgent { get; set; }
        public string? ShipmentType { get; set; }
        public DateTime ShipmentDate   { get; set; }
        public Guid SenderAddressId { get; set; }
        public Guid CreatedBy { get; set; }
        public DateTime CreatedAt { get; set; }    
        public DateTime UpdatedAt { get; set; }
        public Guid UpdatedBy { get; set; }

    }
}
