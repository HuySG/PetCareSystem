import axios from "axios";
// const API_URL = "https://pets4life.azurewebsites.net/api";
const API_URL = "http://pets4life.fptu.meu-solutions.com/api";
// const API_URL = "https://localhost:7148/api";


class CustomerService {
    getAllCustomer() {
      return axios.get(API_URL + "/User");
    }

    loginUser(email, password) {
      return axios.post(API_URL + "/User/login", {
        email: email,
        password: password,
      });
    }

    saveStaff(staff){
      return axios.post(API_URL + "/User", staff);
    }

    updateStaff(id, staff) {
      return axios.put(API_URL + "/User/" + id, staff);
    }
  
  
    getStaffById(id) {
      return axios.get(API_URL + "/User/" + id);
    }
  }
export default new CustomerService;