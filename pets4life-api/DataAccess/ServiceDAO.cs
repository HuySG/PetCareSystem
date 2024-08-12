using BusinessObject.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
    public class ServiceDAO
    {
        private static ServiceDAO instance;
        private static object instanceLock = new object();

        public static ServiceDAO Instance
        {
            get
            {
                lock (instanceLock)
                {
                    if (instance == null)
                    {
                        instance = new ServiceDAO();
                    }
                    return instance;
                }
            }
        }

        public async Task<IEnumerable<Service>> GetAllServices()
        {
            var context = new Pets4lifeContext();
            return await context.Services.ToListAsync();
        }

        public async Task<Service?> GetService(int id)
        {
            var context = new Pets4lifeContext();
            Service? member = await context.Services.Where(member => member.ServiceId == id).FirstOrDefaultAsync();
            return member;
        }

        public async Task AddService(Service member)
        {
            var context = new Pets4lifeContext();
            context.Services.Add(member);
            await context.SaveChangesAsync();
        }

        public async Task DeleteService(int id)
        {
            if ((await GetService(id)) != null)
            {
                var context = new Pets4lifeContext();
                Service member = new Service() { ServiceId = id };
                context.Services.Attach(member);
                context.Services.Remove(member);
                await context.SaveChangesAsync();
            }
        }

        public async Task UpdateService(Service member)
        {
            var context = new Pets4lifeContext();
            context.Services.Update(member);
            await context.SaveChangesAsync();
        }
    }
}
