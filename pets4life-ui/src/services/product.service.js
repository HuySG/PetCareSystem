import axios from "axios";
// const API_URL = "https://pets4life.azurewebsites.net/api";
const API_URL = "http://pets4life.fptu.meu-solutions.com/api";
// const API_URL = "https://localhost:7148/api";

class ProductService {
  getAllProduct() {
    return axios.get(API_URL + "/Product");
  }

  saveProduct(pro) {
    return axios.post(API_URL + "/Product/", pro);
  }

  updateProduct(id, product) {
    return axios.put(API_URL + "/Product/" + id, product);
  }


  getProductById(id) {
    return axios.get(API_URL + "/Product/" + id);
  }

}
export default new ProductService;