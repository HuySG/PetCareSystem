using BusinessObject.Models;
using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public class OrderDetailRepository : IOrderDetailRepository
    {
        public Task AddOrderDetail(OrderDetail orderDetail)
        {
            return OrderDetailDAO.Instance.AddOrderDetail(orderDetail);
        }

        public Task<OrderDetail?> GetOrderDetail(int id)
        {
            return OrderDetailDAO.Instance.GetOrderDetail(id);
        }

        public Task<IEnumerable<OrderDetail>> GetOrderDetailByOrderId(int orderId)
        {
            return OrderDetailDAO.Instance.GetOrderDetailByOrderId(orderId);
        }
    }
}
