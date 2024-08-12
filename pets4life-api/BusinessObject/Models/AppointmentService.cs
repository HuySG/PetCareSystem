using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace BusinessObject.Models
{
    public partial class AppointmentService
    {
        public int? AppointmentServiceId { get; set; }
        public int? AppointmentId { get; set; }
        public int? ServiceId { get; set; }

        [JsonIgnore] public virtual Appointment? Appointment { get; set; }
        [JsonIgnore] public virtual Service? Service { get; set; }
    }
}
