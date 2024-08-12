using BusinessObject.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public interface IAppointmentServiceRepository
    {
        Task<IEnumerable<AppointmentService>> GetAllAppointmentServices();
        Task<AppointmentService?> GetAppointmentService(int id);
        Task AddAppointmentService(AppointmentService AppointmentService);
        Task DeleteAppointmentService(int id);
        Task UpdateAppointmentService(AppointmentService AppointmentService);
    }
}
