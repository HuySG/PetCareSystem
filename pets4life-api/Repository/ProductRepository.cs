using BusinessObject.Models;
using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public class ProductRepository : IProductRepository
    {
        public Task AddProduct(Product Product)
        {
            return ProductDAO.Instance.AddProduct(Product);
        }

        public Task DeleteProduct(int id)
        {
            return ProductDAO.Instance.DeleteProduct(id);
        }

        public Task<Product?> GetProduct(int id)
        {
            return ProductDAO.Instance.GetProduct(id);
        }

        public Task<IEnumerable<Product>> GetAllProducts()
        {
            return ProductDAO.Instance.GetAllProducts();
        }

        public Task UpdateProduct(Product Product)
        {
            return ProductDAO.Instance.UpdateProduct(Product);
        }

    }
}
