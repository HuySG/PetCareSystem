using BusinessObject.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
    public class OrderDAO
    {
        private static OrderDAO instance = null;
        private static readonly object instanceLock = new object();

        public static OrderDAO Instance
        {
            get
            {
                lock (instanceLock)
                {
                    if (instance == null)
                    {
                        instance = new OrderDAO();
                    }

                    return instance;
                }
            }
        }

        public async Task<IEnumerable<Order>> GetAllOrders()
        {
            var context = new Pets4lifeContext();
            return await context.Orders.ToListAsync();
        }

        public async Task<IEnumerable<Order>> GetOrdersByUser(int userId)
        {
            var context = new Pets4lifeContext();
            return await context.Orders
                .Where(o => o.UserId == userId)
                .ToListAsync();
        }

        public async Task<Order?> GetOrder(int id)
        {
            var context = new Pets4lifeContext();
            Order? member = await context.Orders.Where(member => member.OrderId == id).FirstOrDefaultAsync();
            return member;
        }

        public async Task AddOrder(Order member)
        {
            var context = new Pets4lifeContext();
            member.IsPaid = false;
            context.Orders.Add(member);
            await context.SaveChangesAsync();
        }

        public async Task DeleteOrder(int id)
        {
            if ((await GetOrder(id)) != null)
            {
                var context = new Pets4lifeContext();
                Order member = new Order() { OrderId = id };
                context.Orders.Attach(member);
                context.Orders.Remove(member);
                await context.SaveChangesAsync();
            }
        }

        public async Task UpdateOrder(Order member)
        {
            var context = new Pets4lifeContext();
            context.Orders.Update(member);
            await context.SaveChangesAsync();
        }
    }
}
