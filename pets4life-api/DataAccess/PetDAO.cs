using BusinessObject.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
    public class PetDAO
    {
        private static PetDAO instance;
        private static object instanceLock = new object();

        public static PetDAO Instance
        {
            get
            {
                lock (instanceLock)
                {
                    if (instance == null)
                    {
                        instance = new PetDAO();
                    }
                    return instance;
                }
            }
        }

        public async Task<IEnumerable<Pet>> GetAllPets()
        {
            var context = new Pets4lifeContext();
            return await context.Pets.ToListAsync();
        }

        public async Task<Pet?> GetPet(int id)
        {
            var context = new Pets4lifeContext();
            Pet? member = await context.Pets.Where(member => member.PetId == id).FirstOrDefaultAsync();
            return member;
        }

        public async Task AddPet(Pet member)
        {
            var context = new Pets4lifeContext();
            member.Diabetes = 0;
            member.Arthritis = 0;
            member.Vaccine = 0;
            context.Pets.Add(member);
            await context.SaveChangesAsync();
        }

        public async Task DeletePet(int id)
        {
            if ((await GetPet(id)) != null)
            {
                var context = new Pets4lifeContext();
                Pet member = new Pet() { PetId = id };
                context.Pets.Attach(member);
                context.Pets.Remove(member);
                await context.SaveChangesAsync();
            }
        }

        public async Task UpdatePet(Pet member)
        {
            var context = new Pets4lifeContext();
            context.Pets.Update(member);
            await context.SaveChangesAsync();
        }

        //by userId
        public async Task<IEnumerable<Pet>> GetPetsByUserId(int userId)
        {
            IEnumerable<Pet> os = null;

            try
            {
                var context = new Pets4lifeContext();
                os = await context.Pets.Include(pro => pro.User)
                            .Where(c => c.UserId == userId).ToListAsync();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

            return os;
        }

    }
}
