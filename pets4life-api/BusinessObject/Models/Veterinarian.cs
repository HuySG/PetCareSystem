using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace BusinessObject.Models
{
    public partial class Veterinarian
    {
        public Veterinarian()
        {
            Appointments = new HashSet<Appointment>();
        }

        public int VetId { get; set; }
        public string? FullName { get; set; }
        public string? Phone { get; set; }
        public string? Email { get; set; }

        [JsonIgnore] public virtual ICollection<Appointment> Appointments { get; set; }
    }
}
