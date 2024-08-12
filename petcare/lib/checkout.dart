import 'package:flutter/material.dart';
import 'package:petcare/api-petcare/api.dart';
import 'package:petcare/cart.dart';
import 'package:petcare/home.dart';
import 'package:petcare/information_pet.dart';
import 'package:petcare/model-petcare/order.dart';
import 'package:petcare/model-petcare/pet.dart';
import 'package:petcare/session-petcare/session.dart';
import 'package:petcare/update_information_pet.dart';
import 'package:petcare/userprofile.dart';

class checkout extends StatefulWidget {
  final int? orderId;

  const checkout({Key? key, required this.orderId}) : super(key: key);

  @override
  State<checkout> createState() => _checkoutState();
}

class _checkoutState extends State<checkout>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isClicked = false;
  bool isLoading = false; // Add isLoading state variable

  final userId = SessionManager().getUserId() ?? 0;
  // Use 0 as a default value, but you can choose a different default if needed
  late Order? orderPro = Order();

  int orderId = 0;

  @override
  void initState() {
    super.initState();

    fetchOrderData();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onCheckPayment(BuildContext context) async {
    if (isLoading) {
      return; // Do nothing if data is currently being loaded
    }

    setState(() {
      isLoading = true;
    });

    await fetchOrderData(); // Wait for the order data to be fetched

    if (orderPro?.isPaid == false) {
      // Show a notification popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Payment Notification"),
            content: Text("You haven't paid yet."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      SessionManager().clearCart();

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => home(),
      ));
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchOrderData() async {
    setState(() {
      isLoading = true; // Set isLoading to true while fetching data
    });

    orderId = widget.orderId ?? 0;
    Order order = await API.getOrder(orderId);

    setState(() {
      orderPro = order; // Set the list of pet containers in your state
      isLoading = false; // Reset isLoading when data retrieval is complete
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF9F1EF),
        title: Text(
          'Checkout',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              isClicked = !isClicked; // Chuyển đổi trạng thái khi nút được nhấn
            });
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => cart(),
            ));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => updateinformationpets(),
                  ));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10), // Add margin here
                  width: 300,
                  child: Stack(
                    children: [
                      Image(
                        image: AssetImage("assets/huy_qr.jpg"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: Visibility(
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              setState(() {
                                isClicked = !isClicked;
                              });
                              onCheckPayment(context);
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
                      child: isLoading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              'I have paid already!',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
