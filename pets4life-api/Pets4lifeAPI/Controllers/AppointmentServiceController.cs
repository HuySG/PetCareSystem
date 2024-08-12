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
    public class AppointmentServiceController : ControllerBase
    {
        private readonly IAppointmentServiceRepository _appointmentServiceRepo;

        public AppointmentServiceController(IAppointmentServiceRepository appointmentServiceRepo)
        {
            _appointmentServiceRepo = appointmentServiceRepo;
        }


        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<AppointmentService>))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<IEnumerable<AppointmentService>>> GetAppointments()
        {
            var list = await _appointmentServiceRepo.GetAllAppointmentServices();
            if (list == null)
            {
                return NotFound();
            }

            return Ok(list);
        }


        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(AppointmentService))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<AppointmentService>> GetAppointmentService(int id)
        {
            var AppointmentService = await _appointmentServiceRepo.GetAppointmentService(id);

            if (AppointmentService == null)
            {
                return NotFound();
            }

            return Ok(AppointmentService);
        }


        [HttpPost]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<Appointment>> AddAppointmentService(AppointmentService AppointmentService)
        {
            try
            {
                await _appointmentServiceRepo.AddAppointmentService(AppointmentService);
            }
            catch (DbUpdateException)
            {
                throw;
            }

            return Ok();
        }


    }
}
