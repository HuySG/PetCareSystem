using BusinessObject.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
    public class DeliveryDAO
    {
        // Using Singleton Pattern
        private static DeliveryDAO instance = null;
        private static object instanceLook = new object();

        public static DeliveryDAO Instance
        {
            get
            {
                lock (instanceLook)
                {
                    if (instance == null)
                    {
                        instance = new DeliveryDAO();
                    }
                    return instance;
                }
            }
        }

        public async Task<IEnumerable<Delivery>> GetAllDelivery()
        {
            var context = new Pets4lifeContext();
            return await context.Deliveries.ToListAsync();
        }

        public async Task<Delivery?> GetDelivery(int id)
        {
            var context = new Pets4lifeContext();
            Delivery? member = await context.Deliveries.Where(member => member.DeliveryId == id).FirstOrDefaultAsync();
            return member;
        }
    }
}
