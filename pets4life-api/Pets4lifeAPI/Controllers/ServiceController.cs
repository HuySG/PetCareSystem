using BusinessObject.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Repository;
using System.Net.Mime;

namespace Services4lifeAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ServiceController : ControllerBase
    {
        private readonly IServiceRepository _serviceRepo;

        public ServiceController(IServiceRepository serviceRepo)
        {
            _serviceRepo = serviceRepo;
        }


        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<Service>))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<IEnumerable<Service>>> GetServices()
        {
            var list = await _serviceRepo.GetAllServices();
            if (list == null)
            {
                return NotFound();
            }

            return Ok(list);
        }


        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(Service))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Service>> GetService(int id)
        {
            var service = await _serviceRepo.GetService(id);

            if (service == null)
            {
                return NotFound();
            }

            return Ok(service);
        }


        [HttpPost]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<Service>> AddService(Service service)
        {
            try
            {
                // Set the UTC offset for UTC+7
                TimeSpan utcOffset = TimeSpan.FromHours(7);

                // Get the current UTC time
                DateTime utcNow = DateTime.UtcNow;

                // Convert the UTC time to UTC+7
                DateTime localTime = utcNow + utcOffset;


                service.CreatedDate = localTime;
                await _serviceRepo.AddService(service);
            }
            catch (DbUpdateException)
            {
                if (await _serviceRepo.GetService(service.ServiceId) != null)
                {
                    return Conflict();
                }

                throw;
            }

            return CreatedAtAction("GetService", new { id = service.ServiceId }, service);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateService(int id, Service service)
        {
            if (id != service.ServiceId)
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


                service.UpdatedDate = localTime;
                await _serviceRepo.UpdateService(service);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (await _serviceRepo.GetService(id) == null)
                {
                    return NotFound();
                }

                throw;
            }

            return NoContent();
        }

    }
}
