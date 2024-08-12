using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace BusinessObject.Models
{
    public partial class Order
    {
        public Order()
        {
            OrderDetails = new HashSet<OrderDetail>();
        }

        public int OrderId { get; set; }
        public int? UserId { get; set; }
        public DateTime? OrderDate { get; set; }
        public decimal? TotalAmount { get; set; }
        public bool? IsPaid { get; set; }
        public string? ImagePayment { get; set; }

        [JsonIgnore] public virtual User? User { get; set; }
        [JsonIgnore] public virtual ICollection<OrderDetail> OrderDetails { get; set; }
    }
}
