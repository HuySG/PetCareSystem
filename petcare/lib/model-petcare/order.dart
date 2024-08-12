class Order {
  int? orderId;
  int? userId;
  String? orderDate;
  double? totalAmount;
  bool? isPaid;

  Order(
      {this.orderId,
      this.userId,
      this.orderDate,
      this.totalAmount,
      this.isPaid});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    userId = json['userId'];
    orderDate = json['orderDate'];
    totalAmount = json['totalAmount'];
    isPaid = json['isPaid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['userId'] = this.userId;
    data['orderDate'] = this.orderDate;
    data['totalAmount'] = this.totalAmount;
    data['isPaid'] = this.isPaid;
    return data;
  }
}
