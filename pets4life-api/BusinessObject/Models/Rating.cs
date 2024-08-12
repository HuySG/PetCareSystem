using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace BusinessObject.Models
{
    public partial class Rating
    {
        public int RatingId { get; set; }
        public int? ServiceId { get; set; }
        public int? ProductId { get; set; }
        public int? UserId { get; set; }
        public double? Star { get; set; }
        public string? Comment { get; set; }

        [JsonIgnore]  public virtual Product? Product { get; set; }
        [JsonIgnore] public virtual Service? Service { get; set; }
        [JsonIgnore] public virtual User? User { get; set; }
    }
}
