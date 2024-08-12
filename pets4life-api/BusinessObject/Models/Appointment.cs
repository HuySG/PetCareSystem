using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace BusinessObject.Models
{
    public partial class Appointment
    {
        public int AppointmentId { get; set; }
        public int? PetId { get; set; }
        public int? VetId { get; set; }
        public DateTime? AppointmentDate { get; set; }
        public string? TimeSlot { get; set; }
        public string? Purpose { get; set; }
        public string? Notes { get; set; }

        [JsonIgnore] public virtual Pet? Pet { get; set; }
        [JsonIgnore] public virtual Veterinarian? Vet { get; set; }
    }
}
