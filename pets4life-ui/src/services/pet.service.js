import axios from "axios";
// const API_URL = "https://pets4life.azurewebsites.net/api";
const API_URL = "http://pets4life.fptu.meu-solutions.com/api";

class PetService {
    getAllPet() {
      return axios.get(API_URL + "/Pet");
    }
    updatePet(id, pet) {
      return axios.put(API_URL + "/Pet/" + id, pet);
    }
  
  
    getPetById(id) {
      return axios.get(API_URL + "/Pet/" + id);
    }
  }
export default new PetService;