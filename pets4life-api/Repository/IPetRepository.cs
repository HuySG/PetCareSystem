using BusinessObject.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public interface IPetRepository
    {
        Task<IEnumerable<Pet>> GetAllPets();
        Task<IEnumerable<Pet>> GetPetsByUserId(int userId);
        Task<Pet?> GetPet(int id);
        Task AddPet(Pet pet);
        Task DeletePet(int id);
        Task UpdatePet(Pet pet);
    }
}
