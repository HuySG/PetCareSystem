using BusinessObject.Models;
using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public class AppointmentServiceRepository : IAppointmentServiceRepository
    {
        public Task AddAppointmentService(AppointmentService AppointmentService)
        {
            return AppointmentServiceDAO.Instance.AddAppointmentService(AppointmentService);
        }

        public Task DeleteAppointmentService(int id)
        {
            return AppointmentServiceDAO.Instance.DeleteAppointmentService(id);
        }

        public Task<AppointmentService?> GetAppointmentService(int id)
        {
            return AppointmentServiceDAO.Instance.GetAppointmentService(id);
        }

        public Task<IEnumerable<AppointmentService>> GetAllAppointmentServices()
        {
            return AppointmentServiceDAO.Instance.GetAllAppointmentServices();
        }


        public Task UpdateAppointmentService(AppointmentService AppointmentService)
        {
            return AppointmentServiceDAO.Instance.UpdateAppointmentService(AppointmentService);
        }
    }
}
