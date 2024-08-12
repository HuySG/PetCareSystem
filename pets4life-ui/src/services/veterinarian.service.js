import axios from "axios";
// const API_URL = "https://pets4life.azurewebsites.net/api";
const API_URL = "http://pets4life.fptu.meu-solutions.com/api";
// const API_URL = "https://localhost:7148/api";


class VeterinarianService {
    getAllVeterinarian() {
      return axios.get(API_URL + "/Veterinarian");
    }

    saveVeterinarian(vet) {
      return axios.post(API_URL + "/Veterinarian/", vet);
    }

    updateVeterinarian(id, veterinarian) {
      return axios.put(API_URL + "/Veterinarian/" + id, veterinarian);
    }
  
  
    getVeterinarianById(id) {
      return axios.get(API_URL + "/Veterinarian/" + id);
    }
  }
export default new VeterinarianService;