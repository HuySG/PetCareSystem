using BusinessObject.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
    public class VeterinarianDAO
    {

        private static VeterinarianDAO instance;
        private static object instanceLock = new object();

        public static VeterinarianDAO Instance
        {
            get
            {
                lock (instanceLock)
                {
                    if (instance == null)
                    {
                        instance = new VeterinarianDAO();
                    }
                    return instance;
                }
            }
        }


        public async Task<IEnumerable<Veterinarian>> GetAllVeterinarians()
        {
            var context = new Pets4lifeContext();
            return await context.Veterinarians.ToListAsync();
        }

        public async Task<Veterinarian?> GetVeterinarian(int id)
        {
            var context = new Pets4lifeContext();
            Veterinarian? member = await context.Veterinarians.Where(member => member.VetId == id).FirstOrDefaultAsync();
            return member;
        }

        public async Task AddVeterinarian(Veterinarian member)
        {
            var context = new Pets4lifeContext();
            context.Veterinarians.Add(member);
            await context.SaveChangesAsync();
        }

        public async Task DeleteVeterinarian(int id)
        {
            if ((await GetVeterinarian(id)) != null)
            {
                var context = new Pets4lifeContext();
                Veterinarian member = new Veterinarian() { VetId = id };
                context.Veterinarians.Attach(member);
                context.Veterinarians.Remove(member);
                await context.SaveChangesAsync();
            }
        }

        public async Task UpdateVeterinarian(Veterinarian member)
        {
            var context = new Pets4lifeContext();
            context.Veterinarians.Update(member);
            await context.SaveChangesAsync();
        }
    }
}
