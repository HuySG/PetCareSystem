import 'package:flutter/material.dart';
import 'package:petcare/cart.dart';
import 'package:petcare/model-petcare/cart-item.dart';
import 'package:petcare/model-petcare/product.dart';
import 'package:petcare/api-petcare/api.dart';
import 'package:petcare/model-petcare/user.dart';
import 'package:petcare/noti-petcare/CustomSnackBar.dart';
import 'package:petcare/session-petcare/session.dart';
import 'package:petcare/shop.dart';

class productdetail extends StatefulWidget {
  final Product product;

  productdetail({required this.product});

  @override
  State<productdetail> createState() => _productdetailState();
}

class _productdetailState extends State<productdetail>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int numberOfItemsInCart = 1;
  bool isClicked = false;
  bool isPickUpelected = false;
  bool isShipSelected = false;
  TextEditingController textController = TextEditingController();

  List<String> genders = [
    '121 Le Van Viet, Thu Duc City',
    '222 Le Van Viet, Thu Duc City'
  ];
  bool isExpanded = true;
  String? selectedGender;

  //+1.00 to price
  double priceModifier = 0.0; // Initialize as 0.0

  User? user;

  //cart
  List<CartItem> cartItems = [];

  bool areAllFieldsFilled() {
    return (isPickUpelected || isShipSelected);
  }

  double deliveryFee = 1.00; // Step 1: Initialize the delivery fee

  @override
  void initState() {
    super.initState();
    print('this is product in detail: ' + widget.product.productId.toString());

    //try to get userId in session
    int? userId = SessionManager().getUserId();

    if (userId != null) {
      // You have the userId, you can use it here
      print('User ID trong session home: $userId');

      //try print list pets by userId
      fetchUserData(userId);
    } else {
      // User is not logged in or userId is not set
      print('User ID trong session home: $userId');
    }

    _controller = AnimationController(vsync: this);

    cartItems = SessionManager().getCart() ?? [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //function get user detail
  Future<void> fetchUserData(int userId) async {
    try {
      User _user = await API.getUser(userId);

      setState(() {
        // Set the user object in your state
        user = _user;
      });
    } catch (e) {
      // Handle any exceptions that may occur during the API call
      print('Error fetching user data: $e');
    }
  }

  Future<void> loadCartSession() async {
    List<CartItem> c = SessionManager().getCart();

    setState(() {
      // Set the list of pet containers in your state
      cartItems = c;
    });
  }

  // Function to handle the "Delivery + $1.00" button click
  void handleDeliveryButtonClick() {
    setState(() {
      // Step 2: Update the total price of the product in the cart
      for (var cartItem in cartItems) {
        if (cartItem.itemType == ItemType.Product && cartItem.product != null) {
          final product = cartItem.product!; // Safe access to product
          if (product.price != null) {
            product.price = (product.price ?? 0) + deliveryFee;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double originalPrice =
        widget.product.price ?? 0.0; // Replace 0.0 with your default price

    // Calculate the final price based on the selected delivery method and price modifier
    double finalPrice = originalPrice + priceModifier;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                          50), // Khoảng cách giữa biểu tượng và văn bản "Home"
                  Text(
                    'Product Detail',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  SizedBox(width: 50),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.width * 0.1,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 2,
                          top: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.width * 0.1,
                            decoration: ShapeDecoration(
                              color: Color(0xFFEFEFEF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
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
                              Icons.favorite,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  // Khoảng cách giữa biểu tượng và văn bản "Home"
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Image.network(
                widget.product.image!,
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.cover, // Để hình ảnh tự động lấp đầy
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 50), // Điều chỉnh giá trị left tùy ý
                  child: Row(
                    children: [
                      Text(
                        widget.product.brand!,
                        style: TextStyle(
                          color: Color(0xFF979797),
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                      Container(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                        ), // Khoảng cách giữa "Type:" và "Cat"
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Text(
                        '4.9',
                        style: TextStyle(
                          color: Color(0xFFABABAB),
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width *
                    0.8, // Đặt độ rộng tùy ý
                child: Text(
                  widget.product.productName!,
                  style: TextStyle(
                    color: Color(0xFF3F434A),
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.2, // Điều chỉnh khoảng cách giữa các dòng
                  ),
                  overflow: TextOverflow
                      .ellipsis, // Cho phép văn bản tự động xuống dòng và hiển thị dấu chấm ba chấm khi cắt
                  maxLines: 2, // Đặt số lượng dòng tối đa
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Row(children: [
                    Text(
                      '\$${finalPrice.toStringAsFixed(2)}', // Format the price to two decimal places
                      style: TextStyle(
                        color: Color(0xFFB12A1C),
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                  ]),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 16.0), // Điều chỉnh giá trị left tùy ý
                      child: Text(
                        'Select Delivery Method',
                        style: TextStyle(
                          color: Color(0xFF767676),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isPickUpelected = true;
                        isShipSelected = false;
                        priceModifier =
                            0.0; // Set modifier to 1.0 for "Delivery + $1.00"
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: isPickUpelected
                            ? Color(0xFFB12A1C)
                            : Color(0xFFD4D4D4),
                        borderRadius:
                            BorderRadius.circular(15), // Đây là border radius
                      ),
                      child: Center(
                          child: Text(
                        'Pick Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      )),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isPickUpelected = false;
                        isShipSelected = true;
                        priceModifier = 1.0; // Set modifier to 0.0 for "Basic"
                        handleDeliveryButtonClick();
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: isShipSelected
                            ? Color(0xFFB12A1C)
                            : Color(0xFFD4D4D4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                          child: Text(
                        'Delivery + \$1.00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      )),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 16.0), // Điều chỉnh giá trị left tùy ý
                    child: Text(
                      'Pick Up Location',
                      style: TextStyle(
                        color: Color(0xFF767676),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  obscureText: false,
                  enabled: false, // Disable editing
                  controller: textController, // Set the controller
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFD9D9D9),
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    hintText: isPickUpelected
                        ? 'My Store'
                        : user != null
                            ? user?.address ?? ''
                            : 'Select Pick Up or Delivery',
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: isExpanded
                          ? Icon(Icons.expand_less)
                          : Icon(Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (isExpanded)
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    widget.product.description!,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Positioned(
                    left: 6,
                    top: 20,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.width * 0.1,
                      decoration: ShapeDecoration(
                        color: Color(0xFFEFEFEF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isClicked =
                              !isClicked; // Chuyển đổi trạng thái khi nút được nhấn
                        });
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => cart(),
                        ));
                      },
                      icon: Icon(
                        Icons.shopping_bag,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  if (cartItems
                      .isNotEmpty) // Only display the badge if the cart is not empty
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(
                              0xFFB12A1C), // You can change the color to match your design
                        ),
                        child: Text(
                          cartItems.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              ElevatedButton(
                onPressed: areAllFieldsFilled()
                    ? () {
                        // Create a CartItem using the selected product
                        // Create a cartItem using the selected product
                        final cartItem = CartItem(
                            product: widget.product,
                            totalPrice: finalPrice,
                            quantity:
                                1, // Start with a quantity of 1 when adding to the cart
                            itemType: ItemType.Product);

// Add the cartItem to the cart using the SessionManager
                        SessionManager().addToCart(cartItem);

                        // Increment the cart item count
                        loadCartSession();

// Show a custom SnackBar at the center of the screen
                        CustomSnackBar.showSnackBar(
                          context,
                          '${cartItem.product?.productName} added to cart',
                        );
// Now, you can get the updated cart items and item count from SessionManager
                        final cartItems = SessionManager().getCart();
                        final numberOfItemsInCart = cartItems.length;
                      }
                    : null, // Disable the button if not all required fields are filled
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: isClicked ? Colors.black : Color(0xFFB12A1C),
                ),
                child: Text('Add to Cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
