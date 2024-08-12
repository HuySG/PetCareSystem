import 'package:flutter/material.dart';
import 'package:petcare/api-petcare/api.dart';
import 'package:petcare/cart.dart';
import 'package:petcare/model-petcare/appointment.dart';
import 'package:petcare/model-petcare/cart-item.dart';
import 'package:petcare/model-petcare/pet.dart';
import 'package:petcare/model-petcare/service.dart';
import 'package:petcare/noti-petcare/CustomSnackBar.dart';
import 'package:petcare/session-petcare/session.dart';
import 'package:petcare/shop.dart';

class servicedetail extends StatefulWidget {
  final Service service;

  servicedetail({required this.service});

  @override
  State<servicedetail> createState() => _servicedetailState();
}

class _servicedetailState extends State<servicedetail>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int numberOfItemsInCart = 1;
  bool isClicked = false;
  bool isPickUpelected = false;
  bool isShipSelected = false;
  List<String> genders = [
    '8am - 10am',
    '12am - 15pm',
    '16am - 18pm',
  ];
  bool isExpanded = true;
  Pet? selectedPet;
  String? selectedGender;

  late List<Pet> listPet = [];

  //click full thi price x2
  double priceMultiplier = 1.0; // Initialize as 1

  //cart
  List<CartItem> cartItems = [];

  bool areAllFieldsFilled() {
    return selectedPet != null &&
        selectedGender != null &&
        (isPickUpelected || isShipSelected);
  }

  //pass values to cart.dart
  String?
      selectedServiceType; // This variable will hold the selected service type.
  String? selectedTimeSlot; // This variable will hold the selected time slot.

  //add everything to appointment
  late Appointment? appointment;

  int cartItemCount = 0; // Variable to track the cart item count

  @override
  void initState() {
    super.initState();

    //try to get userId in session
    int? userId = SessionManager().getUserId();
    int? serviceId = widget.service.serviceId;

    if (userId != null) {
      // You have the userId, you can use it here
      print('User ID trong session servicedetail: $userId');
      print('Service ID trong session servicedetail: $serviceId');

      //try print list pets by userId
      fetchPetData(userId);
    } else {
      // User is not logged in or userId is not set
      print('User ID trong session servicedetail: $userId');
    }
    _controller = AnimationController(vsync: this);

    cartItems = SessionManager().getCart() ?? [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //function get pets by userId
  Future<void> fetchPetData(int userId) async {
    List<Pet> pets = await API.getPetsByUserId(userId);

    setState(() {
      // Set the list of pet containers in your state
      listPet = pets;
    });
  }

  Future<void> loadCartSession() async {
    List<CartItem> c = SessionManager().getCart();

    setState(() {
      // Set the list of pet containers in your state
      cartItems = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    double originalPrice =
        widget.service.price ?? 0.0; // Replace 0.0 with your default price

    // Adjust the price based on the selected delivery method
    double finalPrice = originalPrice * priceMultiplier;

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
                                builder: (context) => shop(initialTabIndex: 1),
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
                    'Service Detail',
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
                          // Adjust the position of the IconButton
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isClicked = !isClicked;
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
                      ],
                    ),
                  )

                  // Khoảng cách giữa biểu tượng và văn bản "Home"
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Image.network(
                widget.service.image!,
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
                      Icon(
                        Icons.pets,
                        color: Color(0xFFB12A1C),
                      ),
                      Icon(
                        Icons.pets,
                        color: Color(0xFFB12A1C),
                      ),
                      Icon(
                        Icons.pets,
                        color: Color(0xFFB12A1C),
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
                  widget.service.serviceName!,
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
                        'Select Service Type',
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
                        priceMultiplier =
                            1.0; // Set multiplier to 1 for "Basic"
                        selectedServiceType = "Basic";
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
                        'Basic',
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
                        priceMultiplier = 2.0; // Set multiplier to 2 for "Full"
                        selectedServiceType = "Full";
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
                        'Full',
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
                      'Select Pet',
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
                child: DropdownButtonFormField<Pet>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: '',
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
                  ),
                  hint: Text('Select a pet'),
                  value: selectedPet,
                  onChanged: (Pet? newValue) {
                    setState(() {
                      selectedPet = newValue;
                    });
                  },
                  items: listPet.map((Pet pet) {
                    return DropdownMenuItem<Pet>(
                      value: pet, // Use the petName as the value
                      child: Text(pet.petName ??
                          ''), // Handle null valueisplay the petName in the dropdown
                    );
                  }).toList(),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  dropdownColor: Color(0xFFD9D9D9),
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
                      'Select Time Slot',
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
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: '',
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
                  ),
                  hint: Text('Please Select A Time Slot'),
                  value: selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue;
                      selectedTimeSlot = selectedGender;
                    });
                  },
                  items: genders.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  dropdownColor: Color(0xFFD9D9D9),
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
                    widget.service.description!,
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
                          builder: (context) => cart(
                              // appointment: appointment,
                              ),
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
                        appointment = Appointment()
                          ..petId = selectedPet!.petId
                          ..petName = selectedPet!.petName
                          ..timeSlot = selectedTimeSlot
                          ..purpose = selectedServiceType
                          ..notes = "PROCESSING"
                          ..serviceId = widget.service.serviceId;
                        final cartItem = CartItem(
                            service: widget.service,
                            totalPrice: finalPrice,
                            appointment: appointment,
                            quantity:
                                1, // Start with a quantity of 1 when adding to the cart
                            itemType: ItemType.Service);

// Add the cartItem to the cart using the SessionManager
                        SessionManager().addToCart(cartItem);

                        //check appointment
                        print(appointment!.toJson());

                        // Increment the cart item count
                        loadCartSession();
// Show a custom SnackBar at the center of the screen
                        CustomSnackBar.showSnackBar(
                          context,
                          '${cartItem.service?.serviceName} added to cart',
                        );
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
