import axios from "axios";

// const API_URL = "https://pets4life.azurewebsites.net/api";
const API_URL = "http://pets4life.fptu.meu-solutions.com/api";

class AppointmentService {
    getAllAppointment() {
      return axios.get(API_URL + "/Appoinment");
    }

    updateAppointment(id, Appointment) {
      return axios.put(API_URL + "/Appoinment/" + id, Appointment);
    }
  
  
    getAppointmentById(id) {
      return axios.get(API_URL + "/Appoinment/" + id);
    }

    sendEmailAppointment(id){
      return axios.post(API_URL + "/Appoinment/sendMailAppointment?appointmentId=" + id);
    }

}
export default new AppointmentService;