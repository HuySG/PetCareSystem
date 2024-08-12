import axios from "axios";
// const API_URL = "https://pets4life.azurewebsites.net/api";
const API_URL = "http://pets4life.fptu.meu-solutions.com/api";

class OrderService {
    getAllOrder() {
      return axios.get(API_URL + "/Order");
    }
    getOrderDetailByOrderId(id){
        return axios.get(API_URL + "/OrderDetail/byOrder/" + id);
    }
    getOrder(id) {
      return axios.get(API_URL + "/Order/" + id);
    }

    updateOrder(id, order) {
      return axios.put(API_URL + "/Order/" + id, order);
    }

    sendEmailAppointment(id){
      return axios.post(API_URL + "/Order/sendMailPaymentSuccess?userId=" + id);
    }
}
export default new OrderService;