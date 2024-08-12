using BusinessObject.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pets4lifeAPI.MailConfig;
using Repository;
using System.Net.Mail;
using System.Net.Mime;

namespace Pets4lifeAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AppoinmentController : ControllerBase
    {
        private readonly IAppointmentRepository _appointmentRepo;
        private readonly IUserRepository _userRepo;

        public AppoinmentController(IAppointmentRepository appointmentRepo, IUserRepository userRepo)
        {
            _appointmentRepo = appointmentRepo;
            _userRepo = userRepo;
        }


        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<Appointment>))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<IEnumerable<Appointment>>> GetAppointments()
        {
            var list = await _appointmentRepo.GetAllAppointments();
            if (list == null)
            {
                return NotFound();
            }

            return Ok(list);
        }


        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(Appointment))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Appointment>> GetAppointment(int id)
        {
            var Appointment = await _appointmentRepo.GetAppointment(id);

            if (Appointment == null)
            {
                return NotFound();
            }

            return Ok(Appointment);
        }


        [HttpPost]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<Appointment>> AddAppointment(Appointment Appointment)
        {
            try
            {
                await _appointmentRepo.AddAppointment(Appointment);
            }
            catch (DbUpdateException)
            {
                if (await _appointmentRepo.GetAppointment(Appointment.AppointmentId) != null)
                {
                    return Conflict();
                }

                throw;
            }

            return CreatedAtAction("GetAppointment", new { id = Appointment.AppointmentId }, Appointment);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateAppointment(int id, Appointment Appointment)
        {
            if (id != Appointment.AppointmentId)
            {
                return BadRequest();
            }

            try
            {
                await _appointmentRepo.UpdateAppointment(Appointment);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (await _appointmentRepo.GetAppointment(id) == null)
                {
                    return NotFound();
                }

                throw;
            }

            return NoContent();
        }

        [HttpGet("byUser/{userId}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<Appointment>))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<IEnumerable<Appointment>>> GetAppointmentByUser(int userId)
        {
            var list = await _appointmentRepo.GetAppointmentsByUser(userId);
            if (list == null)
            {
                return NotFound();
            }

            return Ok(list);
        }


        [HttpGet("byPet/{petId}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<Appointment>))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<IEnumerable<Appointment>>> GetAppointmentByPet(int petId)
        {
            var list = await _appointmentRepo.GetAppointmentsByPet(petId);
            if (list == null)
            {
                return NotFound();
            }

            return Ok(list);
        }

        //send mail: appointment to user email
        [HttpPost("sendMailAppointment")]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<Appointment>> SendMail(int appointmentId)
        {
            var member = await _userRepo.GetMemberByAppointment(appointmentId);
            var appointment = await _appointmentRepo.GetAppointment(appointmentId);
            try
            {
               
                try
                {
                    MailMessage msg = new MailMessage();
                    msg.From = new MailAddress("pets4life.system@gmail.com");
                    msg.To.Add(member.Email);
                    msg.Subject = "Appointment at Pets4life center";
                    // Use an HTML template for the email body

                    string formattedDate = appointment.AppointmentDate?.ToString("MM/dd/yyyy");

                    string htmlBody = $@"
            <html>
            <body>
                <h1>Appointment Confirmation</h1>
                <p>Dear {member.FullName},</p>
                <p>Your appointment at Pets4life Center has been confirmed.</p>
                <p>Date: {formattedDate}</p>
                <p>Time: {appointment.TimeSlot}</p> 
                <p>Please join us on time.</p>
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
            catch (DbUpdateException)
            {
           
            }
            return Ok(member);
        }

    }
}
