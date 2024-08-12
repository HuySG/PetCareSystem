using BusinessObject.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
    public class AppointmentServiceDAO
    {
        private static AppointmentServiceDAO instance;
        private static object instanceLock = new object();

        public static AppointmentServiceDAO Instance
        {
            get
            {
                lock (instanceLock)
                {
                    if (instance == null)
                    {
                        instance = new AppointmentServiceDAO();
                    }
                    return instance;
                }
            }
        }

        public async Task<IEnumerable<AppointmentService>> GetAllAppointmentServices()
        {
            var context = new Pets4lifeContext();
            return await context.AppointmentServices.ToListAsync();
        }

        public async Task<AppointmentService?> GetAppointmentService(int id)
        {
            var context = new Pets4lifeContext();
            AppointmentService? member = await context.AppointmentServices.Where(member => member.AppointmentId == id).FirstOrDefaultAsync();
            return member;
        }

        public async Task AddAppointmentService(AppointmentService member)
        {
            var context = new Pets4lifeContext();
            context.AppointmentServices.Add(member);
            await context.SaveChangesAsync();
        }

        public async Task DeleteAppointmentService(int id)
        {
            if ((await GetAppointmentService(id)) != null)
            {
                var context = new Pets4lifeContext();
                AppointmentService member = new AppointmentService() { AppointmentId = id };
                context.AppointmentServices.Attach(member);
                context.AppointmentServices.Remove(member);
                await context.SaveChangesAsync();
            }
        }

        public async Task UpdateAppointmentService(AppointmentService member)
        {
            var context = new Pets4lifeContext();
            context.AppointmentServices.Update(member);
            await context.SaveChangesAsync();
        }
    }
}
