class OrderDetail {
  int? orderDetailId;
  int? orderId;
  int? productId;
  int? serviceId;
  int? quantity;
  double? price;

  OrderDetail(
      {this.orderDetailId,
      this.orderId,
      this.productId,
      this.serviceId,
      this.quantity,
      this.price});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    orderDetailId = json['orderDetailId'];
    orderId = json['orderId'];
    productId = json['productId'];
    serviceId = json['serviceId'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderDetailId'] = this.orderDetailId;
    data['orderId'] = this.orderId;
    data['productId'] = this.productId;
    data['serviceId'] = this.serviceId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    return data;
  }
}
