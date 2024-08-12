using BusinessObject.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public interface IOrderRepository
    {
        Task<IEnumerable<Order>> GetAllOrders();
        Task<IEnumerable<Order>> GetOrdersByUser(int userId);
        Task<Order?> GetOrder(int id);
        Task AddOrder(Order Order);
        Task UpdateOrder(Order o);

    }
}
