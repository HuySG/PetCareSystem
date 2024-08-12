import axios from "axios";
// const API_URL = "https://pets4life.azurewebsites.net/api";
const API_URL = "http://pets4life.fptu.meu-solutions.com/api";
// const API_URL = "https://localhost:7148/api";


class ServiceService {
    getAllService() {
      return axios.get(API_URL + "/Service");
    }

    saveService(ser) {
      return axios.post(API_URL + "/Service/", ser);
    }

    updateService(id, service) {
      return axios.put(API_URL + "/Service/" + id, service);
    }
  
  
    getServiceById(id) {
      return axios.get(API_URL + "/Service/" + id);
    }
  }
export default new ServiceService;