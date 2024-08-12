using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace BusinessObject.Models
{
    public partial class Pet
    {
        public Pet()
        {
            Appointments = new HashSet<Appointment>();
        }

        public int PetId { get; set; }
        public string? PetName { get; set; }
        public string? PetType { get; set; }
        public string? Breed { get; set; }
        public bool? Gender { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public double? Weight { get; set; }
        public string? CurrentDiet { get; set; }
        public string? Note { get; set; }
        public string? ImageProfile { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? UserId { get; set; }
        public int? Diabetes { get;set; }
        public int? Arthritis { get; set; }
        public int? Vaccine { get; set; }


        [JsonIgnore] public virtual User? User { get; set; }
        [JsonIgnore] public virtual ICollection<Appointment> Appointments { get; set; }
    }
}
