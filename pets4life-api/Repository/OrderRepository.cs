using BusinessObject.Models;
using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public class OrderRepository : IOrderRepository
    {
        public Task<IEnumerable<Order>> GetAllOrders()
        {
           return OrderDAO.Instance.GetAllOrders();
        }

        public Task<IEnumerable<Order>> GetOrdersByUser(int userId)
        {
            return OrderDAO.Instance.GetOrdersByUser(userId);
        }
        public Task AddOrder(Order Order)
        {
            return OrderDAO.Instance.AddOrder(Order);
        }
     

        public Task<Order?> GetOrder(int id)
        {
            return OrderDAO.Instance.GetOrder(id);
        }

        public Task UpdateOrder(Order o)
        {
            return OrderDAO.Instance.UpdateOrder(o);
        }
    }
}
