import axios from "axios";
// const API_URL = "https://pets4life.azurewebsites.net/api";
const API_URL = "http://pets4life.fptu.meu-solutions.com/api";

class CustomerService {
    getAllDelivery() {
      return axios.get(API_URL + "/Delivery");
    }
  }
export default new CustomerService;