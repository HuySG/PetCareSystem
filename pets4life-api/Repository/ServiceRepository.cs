using BusinessObject.Models;
using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public class ServiceRepository : IServiceRepository
    {
        public Task AddService(Service pet)
        {
            return ServiceDAO.Instance.AddService(pet);
        }

        public Task DeleteService(int id)
        {
            return ServiceDAO.Instance.DeleteService(id);
        }

        public Task<Service?> GetService(int id)
        {
            return ServiceDAO.Instance.GetService(id);
        }

        public Task<IEnumerable<Service>> GetAllServices()
        {
            return ServiceDAO.Instance.GetAllServices();
        }

        public Task UpdateService(Service pet)
        {
            return ServiceDAO.Instance.UpdateService(pet);
        }

    }
}
