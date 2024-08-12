using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace BusinessObject.Models
{
    public partial class OrderDetail
    {
        public int OrderDetailId { get; set; }
        public int? OrderId { get; set; }
        public int? ProductId { get; set; }
        public int? ServiceId { get; set; }
        public int? Quantity { get; set; }
        public decimal? Price { get; set; }

       [JsonIgnore]  public virtual Order? Order { get; set; }
        [JsonIgnore] public virtual Product? Product { get; set; }
        [JsonIgnore] public virtual Service? Service { get; set; }
    }
}
