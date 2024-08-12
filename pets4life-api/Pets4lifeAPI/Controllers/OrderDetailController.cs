using BusinessObject.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Repository;
using System.Net.Mime;

namespace Pets4lifeAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrderDetailController : ControllerBase
    {
        private readonly IOrderDetailRepository _orderDetailRepo;

        public OrderDetailController(IOrderDetailRepository orderDetailRepo)
        {
            _orderDetailRepo = orderDetailRepo;
        }

        [HttpGet("byOrder/{orderId}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<OrderDetail>))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<IEnumerable<OrderDetail>>> GetOrderDetailsByOrderId(int orderId)
        {
            var list = await _orderDetailRepo.GetOrderDetailByOrderId(orderId);
            if (list == null)
            {
                return NotFound();
            }

            return Ok(list);
        }

        [HttpPost]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<OrderDetail>> AddOrderDetail(OrderDetail OrderDetail)
        {
            try
            {
                await _orderDetailRepo.AddOrderDetail(OrderDetail);
            }
            catch (DbUpdateException)
            {
                if (await _orderDetailRepo.GetOrderDetail(OrderDetail.OrderDetailId) != null)
                {
                    return Conflict();
                }

                throw;
            }

            return CreatedAtAction("GetOrderDetail", new { id = OrderDetail.OrderDetailId }, OrderDetail);
        }

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(OrderDetail))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<OrderDetail>> GetOrderDetail(int id)
        {
            var OrderDetail = await _orderDetailRepo.GetOrderDetail(id);

            if (OrderDetail == null)
            {
                return NotFound();
            }

            return Ok(OrderDetail);
        }
    }
}
