using BusinessObject.Models;
using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public class AppointmentRepository : IAppointmentRepository
    {
        public Task AddAppointment(Appointment Appointment)
        {
            return AppointmentDAO.Instance.AddAppointment(Appointment);
        }

        public Task DeleteAppointment(int id)
        {
            return AppointmentDAO.Instance.DeleteAppointment(id);
        }

        public Task<Appointment?> GetAppointment(int id)
        {
            return AppointmentDAO.Instance.GetAppointment(id);
        }

        public Task<IEnumerable<Appointment>> GetAllAppointments()
        {
            return AppointmentDAO.Instance.GetAllAppointments();
        }

        public Task UpdateAppointment(Appointment Appointment)
        {
            return AppointmentDAO.Instance.UpdateAppointment(Appointment);
        }

        public Task<IEnumerable<Appointment>> GetAppointmentsByUser(int userId)
        {
            return AppointmentDAO.Instance.GetAppointmentsByUser(userId);
        }
        public Task<IEnumerable<Appointment>> GetAppointmentsByPet(int petId)
        {
            return AppointmentDAO.Instance.GetAppointmentsByPet(petId);
        }
    }
}
