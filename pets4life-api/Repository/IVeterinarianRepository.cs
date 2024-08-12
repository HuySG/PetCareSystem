using BusinessObject.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public interface IVeterinarianRepository
    {
        Task<IEnumerable<Veterinarian>> GetAllVeterinarians();
        Task<Veterinarian?> GetVeterinarian(int id);
        Task AddVeterinarian(Veterinarian vet);
        Task DeleteVeterinarian(int id);
        Task UpdateVeterinarian(Veterinarian vet);
    }
}
