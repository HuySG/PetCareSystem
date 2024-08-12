using BusinessObject.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public interface IAppointmentRepository
    {
        Task<IEnumerable<Appointment>> GetAllAppointments();
        Task<Appointment?> GetAppointment(int id);
        Task AddAppointment(Appointment Appointment);
        Task DeleteAppointment(int id);
        Task UpdateAppointment(Appointment Appointment);
        Task<IEnumerable<Appointment>> GetAppointmentsByUser(int userId);
        Task<IEnumerable<Appointment>> GetAppointmentsByPet(int petId);
    }
}
