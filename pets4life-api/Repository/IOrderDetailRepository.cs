using BusinessObject.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public interface IOrderDetailRepository
    {
        public Task AddOrderDetail(OrderDetail c);
        public Task<IEnumerable<OrderDetail>> GetOrderDetailByOrderId(int orderId);
        Task<OrderDetail?> GetOrderDetail(int id);
    }
}
