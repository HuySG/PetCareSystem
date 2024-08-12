using BusinessObject.Models;
using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public class VeterinarianRepository : IVeterinarianRepository
    {
        public Task AddVeterinarian(Veterinarian vet)
        {
            return VeterinarianDAO.Instance.AddVeterinarian(vet);
        }

        public Task DeleteVeterinarian(int id)
        {
            return VeterinarianDAO.Instance.DeleteVeterinarian(id);
        }

        public Task<Veterinarian?> GetVeterinarian(int id)
        {
            return VeterinarianDAO.Instance.GetVeterinarian(id);
        }

        public Task<IEnumerable<Veterinarian>> GetAllVeterinarians()
        {
            return VeterinarianDAO.Instance.GetAllVeterinarians();
        }

        public Task UpdateVeterinarian(Veterinarian vet)
        {
            return VeterinarianDAO.Instance.UpdateVeterinarian(vet);
        }
    }
}
