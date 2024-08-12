using BusinessObject.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Repository;
using System.Diagnostics.Metrics;
using System.Net.Mime;

namespace Pets4lifeAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PetController : ControllerBase
    {
        private readonly IPetRepository _petRepo;

        public PetController(IPetRepository petRepo)
        {
            _petRepo = petRepo;
        }


        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<Pet>))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<IEnumerable<Pet>>> GetPets()
        {
            var list = await _petRepo.GetAllPets();
            if (list == null)
            {
                return NotFound();
            }

            return Ok(list);
        }

        [HttpGet("byUser/{userId}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<Pet>))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<IEnumerable<Pet>>> GetPetsByUserId(int userId)
        {
            var list = await _petRepo.GetPetsByUserId(userId);
            if (list == null)
            {
                return NotFound();
            }

            return Ok(list);
        }


        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(Pet))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Pet>> GetPet(int id)
        {
            var pet = await _petRepo.GetPet(id);

            if (pet == null)
            {
                return NotFound();
            }

            return Ok(pet);
        }


        [HttpPost]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<Pet>> AddPet(Pet pet)
        {
            try
            {
                // Set the UTC offset for UTC+7
                TimeSpan utcOffset = TimeSpan.FromHours(7);

                // Get the current UTC time
                DateTime utcNow = DateTime.UtcNow;

                // Convert the UTC time to UTC+7
                DateTime localTime = utcNow + utcOffset;


                pet.CreatedDate = localTime;
                await _petRepo.AddPet(pet);
            }
            catch (DbUpdateException)
            {
                if (await _petRepo.GetPet(pet.PetId) != null)
                {
                    return Conflict();
                }

                throw;
            }

            return CreatedAtAction("GetPet", new { id = pet.PetId }, pet);
        }

        

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdatePet(int id, Pet pet)
        {
            if (id != pet.PetId)
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

                pet.UpdatedDate = localTime;
                await _petRepo.UpdatePet(pet);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (await _petRepo.GetPet(id) == null)
                {
                    return NotFound();
                }

                throw;
            }

            return NoContent();
        }


    }
}
