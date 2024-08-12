using BusinessObject.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public interface IServiceRepository
    {
        Task<IEnumerable<Service>> GetAllServices();
        Task<Service?> GetService(int id);
        Task AddService(Service pet);
        Task DeleteService(int id);
        Task UpdateService(Service pet);
    }
}
