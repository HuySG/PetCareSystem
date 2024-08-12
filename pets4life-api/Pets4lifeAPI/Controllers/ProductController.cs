using BusinessObject.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Repository;
using System.Net.Mime;

namespace Products4lifeAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly IProductRepository _productRepo;

        public ProductController(IProductRepository productRepo)
        {
            _productRepo = productRepo;
        }


        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<Product>))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<IEnumerable<Product>>> GetProducts()
        {
            var list = await _productRepo.GetAllProducts();
            if (list == null)
            {
                return NotFound();
            }

            return Ok(list);
        }


        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(Product))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Product>> GetProduct(int id)
        {
            var Product = await _productRepo.GetProduct(id);

            if (Product == null)
            {
                return NotFound();
            }

            return Ok(Product);
        }


        [HttpPost]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<Product>> AddProduct(Product Product)
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
                Product.CreatedDate = localTime;
                await _productRepo.AddProduct(Product);
            }
            catch (DbUpdateException)
            {
                if (await _productRepo.GetProduct(Product.ProductId) != null)
                {
                    return Conflict();
                }

                throw;
            }

            return CreatedAtAction("GetProduct", new { id = Product.ProductId }, Product);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateProduct(int id, Product Product)
        {
            if (id != Product.ProductId)
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


                Product.UpdatedDate = localTime;
                await _productRepo.UpdateProduct(Product);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (await _productRepo.GetProduct(id) == null)
                {
                    return NotFound();
                }

                throw;
            }

            return NoContent();
        }


    }
}
