import 'package:flutter/material.dart';
import 'package:petcare/api-petcare/api.dart';
import 'package:petcare/checkout.dart';
import 'package:petcare/home.dart';
import 'package:petcare/model-petcare/appointment.dart';
import 'package:petcare/model-petcare/cart-item.dart';
import 'package:petcare/model-petcare/order-detail.dart';
import 'package:petcare/model-petcare/order.dart';
import 'package:petcare/model-petcare/pet.dart';
import 'package:petcare/session-petcare/session.dart';
import 'package:petcare/shop.dart';
import 'package:vnpay_flutter/vnpay_flutter.dart';

class cart extends StatefulWidget {
  //get value from service detail:

  const cart({
    Key? key,
  }) : super(key: key);

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isClicked = false;
  int itemCount = 1;
  void increaseItemCount(CartItem cartItem) {
    setState(() {
      cartItem.quantity++; // Increase the quantity
    });
  }

  void decreaseItemCount(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      setState(() {
        cartItem.quantity--; // Decrease the quantity, but not less than 1
        // You can update the total price here if needed
      });
    }
  }

  List<CartItem> cartItems = [];

  late Order? order;
  late OrderDetail? orderDetail;

  late int? orderId;

  //vnpay
  String responseCode = '';

  void onPayment() async {}

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    // Retrieve the cart items from the session
    // SessionManager().clearCart();
    cartItems = SessionManager().getCart() ?? [];
  }

  // Calculate the total price of all items in the cart
  double calculateTotalPrice(List<CartItem> cartItems) {
    double total = 0.0;
    for (var cartItem in cartItems) {
      total += (cartItem.product != null
              ? cartItem.totalPrice ?? 0
              : cartItem.totalPrice ?? 0) *
          cartItem.quantity;
    }
    return total;
  }

  // Function to remove an item from the cart
  void removeItemFromCart(CartItem cartItem) {
    setState(() {
      cartItems.remove(cartItem);
    });
  }

  // Function to check if the cart is empty
  bool isCartEmpty() {
    return cartItems.isEmpty;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _createAppointment(Appointment? appointment) async {
    await API.createAppointment(appointment: appointment);
  }

  Future<int?> _createOrder(Order? order) async {
    try {
      orderId = await API.createOrder(order: order);
      // orderId now contains the order ID returned from the API
      print('Order ID: $orderId');
      orderId = orderId;
      return orderId;
    } catch (e) {
      print('Error creating order: $e');
    }
    return -1;
  }

  Future<void> _createOrderDetail(OrderDetail? orderDetail) async {
    await API.createOrderDetail(orderDetail: orderDetail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.width * 0.1,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isClicked =
                                    !isClicked; // Chuyển đổi trạng thái khi nút được nhấn
                              });
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => shop(),
                              ));
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      width:
                          110), // Khoảng cách giữa biểu tượng và văn bản "Home"
                  Text(
                    'Cart',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // Inside the build method where you display cart items
              Column(
                children: cartItems.map((cartItem) {
                  print('productName: ${cartItem.product?.productName}');
                  print('serviceName: ${cartItem.service?.serviceName}');
                  if (cartItem.itemType == ItemType.Service) {
                    final description = cartItem.service?.description ?? "";
                    // Split the description into words
                    final words = description.split(' ');
                    // Take the first 5 words
                    final truncatedDescription = words.take(5).join(' ');
                    // Add '...' if there are more words
                    final displayedDescription = words.length > 5
                        ? '$truncatedDescription...'
                        : truncatedDescription;
                  }
                  return Column(
                    children: [
                      Container(
                        width: 383,
                        height: 170.35,
                        decoration: ShapeDecoration(
                          color: Color(0xFFECECEC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.all(
                                  10), // Khoảng cách giữa hình ảnh và nội dung bên phải
                              child: Image.network(
                                cartItem.product != null
                                    ? cartItem.product?.image ?? ""
                                    : cartItem.service?.image ?? "",
                                fit:
                                    BoxFit.cover, // Để hình ảnh tự động lấp đầy
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 50),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.product != null
                                        ? cartItem.product!.brand ?? ""
                                        : "", // Display an empty string if there's no brand
                                    style: TextStyle(
                                      color: Color(0xFF979797),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                  if (cartItem.product ==
                                      null) // Check if it's a service
                                    Icon(
                                      Icons.pets,
                                      color: Color(0xFFB12A1C),
                                    ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.5, // Đặt độ rộng tùy ý
                                    child: Text(
                                      cartItem.product != null
                                          ? cartItem.product?.productName ?? ""
                                          : cartItem.service?.serviceName ?? "",
                                      style: TextStyle(
                                        color: Color(0xFF3F434A),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height:
                                            1.2, // Điều chỉnh khoảng cách giữa các dòng
                                      ),
                                      overflow: TextOverflow
                                          .ellipsis, // Cho phép văn bản tự động xuống dòng và hiển thị dấu chấm ba chấm khi cắt
                                      maxLines: 2, // Đặt số lượng dòng tối đa
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (cartItem.itemType ==
                                      ItemType
                                          .Product) // Check if it's a product
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Quality: ',
                                            style: TextStyle(
                                              color: Color(0xFF888888),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                              height: 0.18,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "Best",
                                            style: TextStyle(
                                              color: Color(0xFF888888),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 0.18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (cartItem.itemType ==
                                      ItemType
                                          .Service) // Check if it's a product
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Time-slot: ',
                                            style: TextStyle(
                                              color: Color(0xFF888888),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                              height: 0.18,
                                            ),
                                          ),
                                          TextSpan(
                                            text: cartItem.service != null
                                                ? cartItem.appointment!
                                                        .timeSlot ??
                                                    ""
                                                : "",
                                            style: TextStyle(
                                              color: Color(0xFF888888),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 0.18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Biểu tượng giảm dần và số lượng
                                      Row(
                                        children: [
                                          if (cartItem.itemType ==
                                              ItemType
                                                  .Product) // Check if it's a product
                                            IconButton(
                                              onPressed: () {
                                                decreaseItemCount(cartItem);
                                              },
                                              icon: Icon(Icons.remove),
                                              iconSize: 12,
                                            ),
                                          if (cartItem.itemType ==
                                              ItemType
                                                  .Service) // Check if it's a product
                                            Text(
                                              'Pet: ' +
                                                  cartItem.appointment!.petName
                                                      .toString() +
                                                  "        ",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFFFBD58),
                                              ),
                                            ),
                                          if (cartItem.itemType ==
                                              ItemType
                                                  .Product) // Check if it's a product
                                            Text(
                                              cartItem.quantity.toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                        ],
                                      ),
                                      // Biểu tượng tăng dần
                                      if (cartItem.itemType ==
                                          ItemType
                                              .Product) // Check if it's a product
                                        IconButton(
                                          onPressed: () {
                                            increaseItemCount(cartItem);
                                          },
                                          icon: Icon(Icons.add),
                                          iconSize: 12,
                                        ),
                                      SizedBox(
                                        width: 65,
                                      ),
                                      FittedBox(
                                        child: Text(
                                          '\$${(cartItem.product != null ? cartItem.totalPrice ?? 0 : cartItem.totalPrice ?? 0) * cartItem.quantity}',
                                          style: TextStyle(
                                            color: Color(0xFFB12A1C),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Remove the item from the cart
                          removeItemFromCart(cartItem);
                        },
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Color(0xFFB12A1C), // Set the color to red
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),

              SizedBox(
                height: 20,
              ),
              Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 50), // Điều chỉnh giá trị left tùy ý
                    child: Row(
                      children: [],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 50), // Điều chỉnh giá trị left tùy ý
                    child: Row(
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0.07,
                          ),
                        ),
                        SizedBox(width: 150),
                        Text(
                          '\$${calculateTotalPrice(cartItems).toStringAsFixed(2)}', // Calculate and display the cart total
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0.07,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Visibility(
                visible: isCartEmpty(),
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Your cart is currently empty.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFBD58),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.09,
                child: Visibility(
                  visible: cartItems
                      .isNotEmpty, // Show the button only if the cart is not empty
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isClicked = !isClicked;
                      });

                      order = Order()
                        ..userId = SessionManager().getUserId()
                        ..totalAmount = calculateTotalPrice(cartItems);
                      // _createOrder(order);
                      await _createOrder(order);

                      for (CartItem c in cartItems) {
                        // Create the appointment
                        if (c.itemType == ItemType.Service &&
                            c.itemType == ItemType.Product) {
                          await _createAppointment(c.appointment);
                          orderDetail = OrderDetail()
                            ..orderId = orderId
                            ..productId = c.product!.productId
                            ..serviceId = c.service!.serviceId;
                          print(orderDetail!.toJson());
                          print('appoint ment sau khi checkout: ');
                          print(c.appointment!.toJson());

                          _createOrderDetail(orderDetail);
                        }
                        if (c.itemType == ItemType.Service) {
                          await _createAppointment(c.appointment);
                          orderDetail = OrderDetail()
                            ..orderId = orderId
                            ..serviceId = c.service!.serviceId;
                          print('appoint ment sau khi checkout: ');

                          print(orderDetail!.toJson());
                          print(c.appointment!.toJson());

                          _createOrderDetail(orderDetail);
                        }
                        if (c.itemType == ItemType.Product) {
                          // If it's a product, create an order detail
                          orderDetail = OrderDetail()
                            ..orderId = orderId
                            ..productId = c.product!.productId;
                          print(orderDetail!.toJson());
                          _createOrderDetail(orderDetail);
                        }
                      }
                      //clear cart

                      //pass orderId to checkout.dart
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => checkout(orderId: orderId),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor:
                          isClicked ? Color(0xFFB12A1C) : Color(0xFFB12A1C),
                    ),
                    child: Text(
                      'Checkout',
                      style: TextStyle(
                        color: isClicked ? Colors.white : Colors.white,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
