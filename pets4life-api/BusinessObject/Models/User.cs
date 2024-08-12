using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace BusinessObject.Models
{
    public partial class User
    {
        public User()
        {
            Carts = new HashSet<Cart>();
            Orders = new HashSet<Order>();
            Pets = new HashSet<Pet>();
            Ratings = new HashSet<Rating>();
        }

        public int UserId { get; set; }
        public string? FullName { get; set; }
        public string? Phone { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public bool? Gender { get; set; }
        public string? Email { get; set; }
        public string? Password { get; set; }
        public string? Address { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? UpdatedDate { get; set; }

        public int? AuthCode { get; set; }
        public bool? Status { get; set; }
        public bool? IsStaff { get; set; }

        [JsonIgnore] public virtual ICollection<Cart> Carts { get; set; }
        [JsonIgnore] public virtual ICollection<Order> Orders { get; set; }
        [JsonIgnore] public virtual ICollection<Pet> Pets { get; set; }
        [JsonIgnore] public virtual ICollection<Rating> Ratings { get; set; }
        [NotMapped] public bool isAdmin { get; set; }
    }
}
