using BusinessObject.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
   public class OrderDetailDAO
    {
        // Using Singleton Pattern
        private static OrderDetailDAO instance = null;
        private static object instanceLook = new object();

        public static OrderDetailDAO Instance
        {
            get
            {
                lock (instanceLook)
                {
                    if (instance == null)
                    {
                        instance = new OrderDetailDAO();
                    }
                    return instance;
                }
            }
        }

        public async Task AddOrderDetail(OrderDetail c)
        {

            var context = new Pets4lifeContext();
            context.OrderDetails.Add(c);
            await context.SaveChangesAsync();
        }

        public async Task<IEnumerable<OrderDetail>> GetOrderDetailByOrderId(int orderId)
        {
            var context = new Pets4lifeContext();

            return await context.OrderDetails.Include(pro => pro.Product)
                    .Include(ser => ser.Service)
                    .Where(c => c.OrderId == orderId).ToListAsync();
        }

        public async Task<OrderDetail?> GetOrderDetail(int id)
        {
            var context = new Pets4lifeContext();
            OrderDetail? member = await context.OrderDetails.Where(member => member.OrderDetailId == id).FirstOrDefaultAsync();
            return member;
        }
    }
}
