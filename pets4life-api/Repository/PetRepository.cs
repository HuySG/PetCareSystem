using BusinessObject.Models;
using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public class PetRepository : IPetRepository
    {
        public Task AddPet(Pet pet)
        {
            return PetDAO.Instance.AddPet(pet);
        }

        public Task DeletePet(int id)
        {
            return PetDAO.Instance.DeletePet(id);
        }

        public Task<Pet?> GetPet(int id)
        {
            return PetDAO.Instance.GetPet(id);
        }

        public Task<IEnumerable<Pet>> GetAllPets()
        {
            return PetDAO.Instance.GetAllPets();
        }

        public Task UpdatePet(Pet pet)
        {
            return PetDAO.Instance.UpdatePet(pet);
        }

        public Task<IEnumerable<Pet>> GetPetsByUserId(int userId)
        {
            return PetDAO.Instance.GetPetsByUserId(userId);
        }
    }
}
