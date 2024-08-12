import 'package:petcare/model-petcare/appointment.dart';
import 'package:petcare/model-petcare/product.dart';
import 'package:petcare/model-petcare/service.dart';

class CartItem {
  final Product? product;
  final Service? service;
  final Appointment? appointment;
  final double? totalPrice;
  int quantity;
  final ItemType itemType;

  CartItem({
    this.product,
    this.service,
    this.appointment,
    this.totalPrice,
    this.quantity = 1,
    required this.itemType,
  });
}

enum ItemType {
  Product,
  Service,
}
