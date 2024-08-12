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
    public class VeterinarianController : ControllerBase
    {
        private readonly IVeterinarianRepository _vetRepo;

        public VeterinarianController(IVeterinarianRepository vetRepo)
        {
            _vetRepo = vetRepo;
        }


        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<Veterinarian>))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<IEnumerable<Veterinarian>>> GetVets()
        {
            var list = await _vetRepo.GetAllVeterinarians();
            if (list == null)
            {
                return NotFound();
            }

            return Ok(list);
        }


        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(Veterinarian))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Veterinarian>> GetVet(int id)
        {
            var vet = await _vetRepo.GetVeterinarian(id);

            if (vet == null)
            {
                return NotFound();
            }

            return Ok(vet);
        }


        [HttpPost]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<Veterinarian>> AddVeterinarian(Veterinarian vet)
        {
            try
            {
                await _vetRepo.AddVeterinarian(vet);
            }
            catch (DbUpdateException)
            {
                if (await _vetRepo.GetVeterinarian(vet.VetId) != null)
                {
                    return Conflict();
                }

                throw;
            }

            return CreatedAtAction("GetVet", new { id = vet.VetId }, vet);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateVeterinarian(int id, Veterinarian vet)
        {
            if (id != vet.VetId)
            {
                return BadRequest();
            }

            try
            {
                await _vetRepo.UpdateVeterinarian(vet);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (await _vetRepo.GetVeterinarian(id) == null)
                {
                    return NotFound();
                }

                throw;
            }

            return NoContent();
        }

    }
}
