using BusinessObject.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
    public class ProductDAO
    {
        private static ProductDAO instance;
        private static object instanceLock = new object();

        public static ProductDAO Instance
        {
            get
            {
                lock (instanceLock)
                {
                    if (instance == null)
                    {
                        instance = new ProductDAO();
                    }
                    return instance;
                }
            }
        }

        public async Task<IEnumerable<Product>> GetAllProducts()
        {
            var context = new Pets4lifeContext();
            return await context.Products.ToListAsync();
        }

        public async Task<Product?> GetProduct(int id)
        {
            var context = new Pets4lifeContext();
            Product? member = await context.Products.Where(member => member.ProductId == id).FirstOrDefaultAsync();
            return member;
        }

        public async Task AddProduct(Product member)
        {
            var context = new Pets4lifeContext();
            context.Products.Add(member);
            await context.SaveChangesAsync();
        }

        public async Task DeleteProduct(int id)
        {
            if ((await GetProduct(id)) != null)
            {
                var context = new Pets4lifeContext();
                Product member = new Product() { ProductId = id };
                context.Products.Attach(member);
                context.Products.Remove(member);
                await context.SaveChangesAsync();
            }
        }

        public async Task UpdateProduct(Product member)
        {
            var context = new Pets4lifeContext();
            context.Products.Update(member);
            await context.SaveChangesAsync();
        }
    }
}
