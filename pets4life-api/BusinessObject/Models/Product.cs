using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace BusinessObject.Models
{
    public partial class Product
    {
        public Product()
        {
            CartItems = new HashSet<CartItem>();
            OrderDetails = new HashSet<OrderDetail>();
            Ratings = new HashSet<Rating>();
        }

        public int ProductId { get; set; }
        public string? ProductName { get; set; }
        public string? Image { get; set; }
        public string? Brand { get; set; }
        public decimal? Price { get; set; }
        public string? Description { get; set; }
        public int? Quantity { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? DeliveryId { get; set; }

        [JsonIgnore] public virtual Delivery? Delivery { get; set; }
        [JsonIgnore] public virtual ICollection<CartItem> CartItems { get; set; }
        [JsonIgnore] public virtual ICollection<OrderDetail> OrderDetails { get; set; }
        [JsonIgnore] public virtual ICollection<Rating> Ratings { get; set; }
    }
}
