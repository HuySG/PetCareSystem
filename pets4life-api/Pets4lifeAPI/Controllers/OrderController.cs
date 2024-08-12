using BusinessObject.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Repository;
using System.Net.Mail;
using System.Net.Mime;

namespace Pets4lifeAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrderController : ControllerBase
    {
        private readonly IOrderRepository _orderRepo;
        private readonly IUserRepository _userRepo;


        public OrderController(IOrderRepository orderRepo, IUserRepository userRepo)
        {
            _orderRepo = orderRepo;
            _userRepo = userRepo;
        }

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<Order>))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<IEnumerable<Order>>> GetOrders()
        {
            var list = await _orderRepo.GetAllOrders();
            if (list == null)
            {
                return NotFound();
            }

            return Ok(list);
        }

        [HttpGet("byUser/{id}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<Order>))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<IEnumerable<Order>>> GetOrdersByUser(int id)
        {
            var list = await _orderRepo.GetOrdersByUser(id);
            if (list == null)
            {
                return NotFound();
            }

            return Ok(list);
        }

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(Order))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Order>> GetOrder(int id)
        {
            var Order = await _orderRepo.GetOrder(id);

            if (Order == null)
            {
                return NotFound();
            }

            return Ok(Order);
        }


        [HttpPost]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<Order>> AddOrder(Order Order)
        {
            try
            {
                // Set the UTC offset for UTC+7
                TimeSpan utcOffset = TimeSpan.FromHours(7);

                // Get the current UTC time
                DateTime utcNow = DateTime.UtcNow;

                // Convert the UTC time to UTC+7
                DateTime localTime = utcNow + utcOffset;


                // Assign the local time to your Product.CreatedDate
                Order.OrderDate = localTime;
                await _orderRepo.AddOrder(Order);
            }
            catch (DbUpdateException)
            {
                if (await _orderRepo.GetOrder(Order.OrderId) != null)
                {
                    return Conflict();
                }

                throw;
            }

            return CreatedAtAction("GetOrder", new { id = Order.OrderId }, Order);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateOrder(int id, Order order)
        {
            if (id != order.OrderId)
            {
                return BadRequest();
            }

            try
            {
                await _orderRepo.UpdateOrder(order);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (await _orderRepo.GetOrder(id) == null)
                {
                    return NotFound();
                }

                throw;
            }

            return Ok(order);
        }

        //send mail: appointment to user email
        [HttpPost("sendMailPaymentSuccess")]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<Appointment>> SendMail(int userId)
        {
            var member = await _userRepo.GetMember(userId);
            try
            {
                if(member != null)
                {
                    try
                    {
                        MailMessage msg = new MailMessage();
                        msg.From = new MailAddress("pets4life.system@gmail.com");
                        msg.To.Add(member.Email);
                        msg.Subject = "Payment Successfully!";
                        // Use an HTML template for the email body
                        // Specify the time zone you want (UTC+7 in this case)
                        // Set the UTC offset for UTC+7
                        TimeSpan utcOffset = TimeSpan.FromHours(7);

                        // Get the current UTC time
                        DateTime utcNow = DateTime.UtcNow;

                        // Convert the UTC time to UTC+7
                        DateTime localTime = utcNow + utcOffset;


                        string formattedDate = localTime.ToString();

                        string htmlBody = $@"
            <html>
            <body>
                <h1>Appointment Confirmation</h1>
                <p>Dear {member.FullName},</p>
                <p>Thanks for giving time with us.</p>
                <p>You have paid at: {formattedDate}</p>
                <p>Dear, Pets4life.</p>
            </body>
            </html>";

                        msg.Body = htmlBody;
                        msg.IsBodyHtml = true; // Specify that the body is HTML

                        msg.Body = htmlBody;
                        msg.IsBodyHtml = true; // Specify that the body is HTML

                        SmtpClient smtp = new SmtpClient();
                        smtp.Host = "smtp.gmail.com";
                        System.Net.NetworkCredential ntcd = new System.Net.NetworkCredential();
                        ntcd.UserName = "pets4life.system@gmail.com";
                        ntcd.Password = "pfoo rgvi ligl aexx"; // Retrieve the password from a secure configuration

                        smtp.Credentials = ntcd;
                        smtp.EnableSsl = true;
                        smtp.Port = 587;
                        smtp.Send(msg);
                    }
                    catch (Exception ex)
                    {
                        // Handle or log the exception, e.g., log.Error(ex.Message);
                        // You can also return a 500 Internal Server Error response if email sending fails.
                        return StatusCode(StatusCodes.Status500InternalServerError, "Email sending failed.");
                    }
                }

                
            }
            catch (DbUpdateException)
            {

            }
            return Ok(member);
        }
    }
}
