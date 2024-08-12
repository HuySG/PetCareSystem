using System;
using System.Collections.Generic;

namespace BusinessObject.Models
{
    public partial class Delivery
    {
        public Delivery()
        {
            Products = new HashSet<Product>();
        }

        public int DeliveryId { get; set; }
        public string? Name { get; set; }
        public decimal? Cost { get; set; }

        public virtual ICollection<Product> Products { get; set; }
    }
}
