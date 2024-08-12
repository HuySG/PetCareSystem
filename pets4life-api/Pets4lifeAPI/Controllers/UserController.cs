using BusinessObject.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pets4lifeAPI.MailConfig;
using Repository;
using System.Diagnostics.Metrics;
using System.Net.Mime;
using System.Net;
using System.Net.Mail;


namespace Pets4lifeAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserRepository _memberRepo;
        private readonly IAppointmentRepository _appointmentRepo;
        private readonly IPetRepository _petRepo;
        private readonly IConfiguration _configuration;

        public class LoginMem
        {
            public string? Email { get; set; }
            public string? Password { get; set; }
        }


        public UserController(IUserRepository memberRepository, IAppointmentRepository appointmentRepository, IPetRepository petRepository,
            IConfiguration configuration)
        {
            _memberRepo = memberRepository;
            _appointmentRepo = appointmentRepository;
            _petRepo = petRepository;
            _configuration = configuration;
        }

        [HttpPost("login")]
        [Consumes(MediaTypeNames.Application.Json)]
        public async Task<ActionResult<User>> LoginMember(LoginMem logMem)
        {
            User member = await _memberRepo.LoginMember(logMem.Email!, logMem.Password!);
            if (member == null)
            {
                if (logMem.Email!.Equals(_configuration["Admin:Email"], StringComparison.OrdinalIgnoreCase)
                    && logMem.Password!.Equals(_configuration["Admin:Password"]))
                {
                    return new User
                    {
                        Email = _configuration["Admin:Email"],
                        Password = _configuration["Admin:Password"],
                        isAdmin = true
                    };
                }

                return NotFound();
            }
            else
            {
                if(member.Status == true)
                {
                    return Ok(member);
                }
                else
                {
                    return NotFound();
                }
              
            }
        }


        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<User>))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<IEnumerable<User>>> GetMembers()
        {
            var list = await _memberRepo.GetAllMembers();
            if (list == null)
            {
                return NotFound();
            }
            return Ok(list);
        }

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(User))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<User>> GetMember(int id)
        {
            var member = await _memberRepo.GetMember(id);

            if (member == null)
            {
                return NotFound();
            }
            return Ok(member);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateMember(int id, User member)
        {
            if (id != member.UserId)
            {
                return BadRequest();
            }


            try
            {
                // Set the UTC offset for UTC+7
                TimeSpan utcOffset = TimeSpan.FromHours(7);

                // Get the current UTC time
                DateTime utcNow = DateTime.UtcNow;

                // Convert the UTC time to UTC+7
                DateTime localTime = utcNow + utcOffset;


                member.UpdatedDate = localTime;
                await _memberRepo.UpdateMember(member);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (await _memberRepo.GetMember(member.UserId) == null)
                {
                    return NotFound();
                }

                throw;
            }

            return Ok(member);
        }

        [HttpPost]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<User>> CreateMember(User member)
        {
            try
            {
                // Set the UTC offset for UTC+7
                TimeSpan utcOffset = TimeSpan.FromHours(7);

                // Get the current UTC time
                DateTime utcNow = DateTime.UtcNow;

                // Convert the UTC time to UTC+7
                DateTime localTime = utcNow + utcOffset;

                member.CreatedDate = localTime;
                await _memberRepo.AddMember(member);
            }
            catch (DbUpdateException)
            {
                if (await _memberRepo.GetMember(member.UserId) != null)
                {
                    return Conflict();
                }

                throw;
            }

            return CreatedAtAction("GetMember", new { id = member.UserId }, member);
        }

        #region REGISTER

        [HttpPost("register")]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<User>> RegisterMember(User member)
        {
            try
            {
                member.Status = false;
                // Specify the time zone you want (UTC+7 in this case)
                // Set the UTC offset for UTC+7
                TimeSpan utcOffset = TimeSpan.FromHours(7);

                // Get the current UTC time
                DateTime utcNow = DateTime.UtcNow;

                // Convert the UTC time to UTC+7
                DateTime localTime = utcNow + utcOffset;

                member.CreatedDate = localTime;
                member.UpdatedDate = null;
                member.IsStaff = false;

                // Generate OTP
                int OTP = SendMail.GenerateOTP();
                member.AuthCode = OTP;

                await _memberRepo.AddMember(member);

                try
                {
                    MailMessage msg = new MailMessage();
                    msg.From = new MailAddress("pets4life.system@gmail.com");
                    msg.To.Add(member.Email);
                    msg.Subject = "OTP Verification";
                    msg.Body = "Your Verification OTP is: " + member.AuthCode.ToString();

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
                if (await _memberRepo.GetMember(member.UserId) != null)
                {
                    return Conflict();
                }

                throw;
            }

            return CreatedAtAction("GetMember", new { id = member.UserId }, member);
        }

        [HttpGet("verify")]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<User?>> VerifyMember([FromQuery] int otp, [FromQuery] string email)
        {

            User? user = await _memberRepo.GetMemberByEmail(email);

            if(user != null)
            {
                if(otp == user.AuthCode)
                {
                    user.Status = true;
                    await _memberRepo.UpdateMember(user);
                    return Ok(user);
                }
                return BadRequest();
            }
            return NotFound();
           
        }

        #endregion



        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMember(int id)
        {
            var member = await _memberRepo.GetMember(id);
            if (member == null)
            {
                return NotFound();
            }

            await _memberRepo.DeleteMember(id);
            return NoContent();
        }

        [HttpGet("byAppointment/{appointmentId}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(User))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<User>> GetMemberByAppointment(int appointmentId)
        {
            var member = await _memberRepo.GetMemberByAppointment(appointmentId);
            if (member != null)
            {
                return Ok(member);
            }

            return NotFound();
        }

        //request delete account (google play)
        [HttpGet("deleteAccount/{userId}")]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<DeleteUserResponse>> SendMailDelete(int userId)
        {
            var member = await _memberRepo.GetMember(userId);

            var DataResponse = new DeleteUserResponse()
            {
                Message = "You have sent a request for deleting your account",
                Member = member
            };
            try
            {

                try
                {
                    MailMessage msg = new MailMessage();
                    msg.From = new MailAddress("pets4life.system@gmail.com");
                    msg.To.Add(member.Email);
                    msg.Subject = "Appointment at Pets4life center";
                    // Use an HTML template for the email body

                    // Set the UTC offset for UTC+7
                    TimeSpan utcOffset = TimeSpan.FromHours(7);

                    // Get the current UTC time
                    DateTime utcNow = DateTime.UtcNow;

                    // Convert the UTC time to UTC+7
                    DateTime localTime = utcNow + utcOffset;

                    string htmlBody = $@"
            <html>
            <body>
                <h1>Delete Account Confirmation</h1>
                <p> {member.FullName},</p>
                <p>Wish to delete his/her account</p>
                <p>Date Request: {localTime}</p>
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
            return Ok(DataResponse);
        }

        
    }

    public class DeleteUserResponse
    {
        public string Message { get; set; }
        public User Member { get; set; }
    }
}
