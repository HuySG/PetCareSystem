import 'package:flutter/material.dart';
import 'package:petcare/InsightPageView.dart';
import 'package:petcare/cart.dart';
import 'package:petcare/insight.dart';
import 'package:petcare/login.dart';
import 'package:petcare/model-petcare/appointment.dart';
import 'package:petcare/model-petcare/cart-item.dart';
import 'package:petcare/model-petcare/pet.dart';
import 'package:petcare/model-petcare/product.dart';
import 'package:petcare/model-petcare/service.dart';
import 'package:petcare/model-petcare/user.dart';
import 'package:petcare/noti-petcare/notification_service.dart';
import 'package:petcare/shop.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:petcare/session-petcare/session.dart';
import 'package:petcare/api-petcare/api.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:petcare/userprofile.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isClicked = false;
  int _currentIndex = 0;
  final List<Widget> _screens = [];
  List<Container> petContainersList = [];
  late List<Product> products = [];
  late List<Service> services = [];
  late List<Appointment> appointments = [];

  late User? user = User();

  final userId = SessionManager().getUserId() ??
      0; // Use 0 as a default value, but you can choose a different default if needed

  List<CartItem> cartItems = [];

  NotificationService notificationServices = NotificationService();

  //bar
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    //list products
    loadProducts();
    loadServices();
    loadAppointments();
    fetchUserData();

    //try to get userId in session
    // int? userId = SessionManager().userId;

    if (userId != null) {
      // You have the userId, you can use it here
      print('User ID trong session home: $userId');

      //try print list pets by userId
      fetchPetData(userId);
    } else {
      // User is not logged in or userId is not set
      print('User ID trong session home: $userId');
    }

    cartItems = SessionManager().getCart() ?? [];

    notificationServices.initialiseNotification();

    tzdata.initializeTimeZones(); // Initialize time zones
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
  }

  Container buildPetContainer(Pet pet) {
    final now = DateTime.now();

    DateTime? dateOfBirth;

    if (pet.dateOfBirth != null) {
      dateOfBirth = DateTime.tryParse(pet.dateOfBirth!);
    }

    final ageDifference = now.year - dateOfBirth!.year;

    return Container(
      width: 397.39,
      height: 213,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 400,
              height: 300,
              decoration: ShapeDecoration(
                color: Color(0xFFFFBD58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "${pet.petName ?? ''}'s Summary",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                )),
          ),
          Align(
            alignment: Alignment.topLeft, // Căn lề dưới và trái
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Row(
                children: [
                  Text(
                    "Type:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4), // Khoảng cách giữa "Type:" và "Cat"
                  Text(
                    pet.petType ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft, // Căn lề dưới và trái
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
              child: Row(
                children: [
                  Text(
                    "Breed:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4), // Khoảng cách giữa "Type:" và "Cat"
                  Text(
                    pet.breed ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft, // Căn lề dưới và trái
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
              child: Row(
                children: [
                  Text(
                    "Gender:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4), // Khoảng cách giữa "Type:" và "Cat"
                  Text(
                    pet.gender == true ? "Male" : "Female",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft, // Căn lề dưới và trái
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
              child: Row(
                children: [
                  Text(
                    "Age:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4), // Khoảng cách giữa "Type:" và "Cat"
                  Text(
                    "$ageDifference yrs old" ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10), // Căn chỉnh theo nhu cầu của bạn
              child: Container(
                width: 100,
                height: 100,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      pet.imageProfile ?? 'https://via.placeholder.com/116x119',
                    ),
                    fit: BoxFit.fill,
                  ),
                  shape: OvalBorder(),
                  shadows: [
                    BoxShadow(
                      color: Color(0x26646464),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight, // Align at the bottom right
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isClicked = !isClicked;
                  });
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InsightPageView(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: isClicked ? Colors.black : Color(0xFF8A3030),
                ),
                child: Text(
                  'Data Insights',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //function get pets by userId
  Future<void> fetchPetData(int userId) async {
    List<Pet> pets = await API.getPetsByUserId(userId);

// Create a list to store pets with vaccine count less than 3
    List<Pet> petsWithLowVaccineCount = [];

    for (Pet p in pets) {
      if (p.vaccine! < 3 && p.vaccine! >= 1) {
        print('This pet needs a vaccine: ' + p.petId.toString());
        petsWithLowVaccineCount.add(p); // Add pet to the list
      }
    }

    // Send notifications for all pets with low vaccine count
    for (Pet p in petsWithLowVaccineCount) {
      DateTime originalDateTime =
          DateTime(2023, 12, 30); // Your original DateTime with time
      // Create a new DateTime with the same date but without the time component
      notificationServices.sendNotificationVaccine(
        'You have an appointment to vaccinate your pet: ' +
            p.petName! +
            " on: ",
        originalDateTime.toString().substring(0, 10),
        p.petId!, // Pass the pet's ID as the notification ID
      );
    }

    List<Container> petContainers = pets.map((pet) {
      return buildPetContainer(pet);
    }).toList();

    setState(() {
      // Set the list of pet containers in your state
      petContainersList = petContainers;
    });
  }

  //function get products
  void loadProducts() async {
    List<Product> loadedProducts = await API.getProducts();
    setState(() {
      products = loadedProducts;
    });
  }

  //function get services
  void loadServices() async {
    List<Service> loadedServices = await API.getServices();

    setState(() {
      services = loadedServices;
    });
  }

  void loadAppointments() async {
    List<Appointment> loadedAppointments =
        await API.getAppointmentByUser(userId);

    // Filter the loaded appointments where notes is "APPROVED"
    List<Appointment> approvedAppointments = loadedAppointments
        .where((appointment) =>
            appointment.notes == "APPROVED" && appointment.notes != "DONE")
        .toList();

    setState(() {
      appointments = approvedAppointments;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //function get pets by userId
  Future<void> fetchUserData() async {
    User u = await API.getUser(userId);

    setState(() {
      // Set the list of pet containers in your state
      user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Return true to allow going back, or false to prevent it.
          return false; // Change this to true if you want to allow going back.
        },
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                Container(
                  height: 100,
                  child: UserAccountsDrawerHeader(
                    accountName: Text('${user!.fullName},'),
                    accountEmail: Text('${user!.email}'),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFBD58),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/home_ground.jpg"),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.shopping_bag),
                  title: Text('Shop'),
                  onTap: () {
                    // Xử lý khi người dùng chọn Option 1 từ menu
                    setState(() {
                      isDrawerOpen = false; // Ẩn Drawer sau khi chọn
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            shop(initialTabIndex: 0), // Set initialTabIndex
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.design_services_sharp),
                  title: Text('Service'),
                  onTap: () {
                    // Xử lý khi người dùng chọn Option 2 từ menu
                    setState(() {
                      isDrawerOpen = false; // Ẩn Drawer sau khi chọn
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            shop(initialTabIndex: 1), // Set initialTabIndex
                      ),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Log Out'),
                  onTap: () {
                    // Xử lý khi người dùng chọn Option 2 từ menu
                    setState(() {
                      isDrawerOpen = false; // Ẩn Drawer sau khi chọn
                    });

                    //log out
                    SessionManager().clearSession();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => login(),
                    ));
                  },
                ),
              ],
            ),
          ),
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
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: MediaQuery.of(context).size.width * 0.1,
                                decoration: ShapeDecoration(
                                  color: Color(0xFFFFBD58),
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
                                  _scaffoldKey.currentState?.openDrawer();
                                },
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ), // Adjust the spacing
                      Text(
                        'Home',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      Container(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.width * 0.1,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: MediaQuery.of(context).size.width * 0.1,
                                decoration: ShapeDecoration(
                                  color: Color(0xFFFFBD58),
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
                          ],
                        ),
                      ),
                      // Khoảng cách giữa biểu tượng và văn bản "Home"
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 220, // Chiều cao của slide
                      enlargeCenterPage: true,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                    ),
                    items: petContainersList,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 16.0), // Điều chỉnh giá trị left tùy ý
                      child: Row(
                        children: [
                          Text(
                            'Reminders',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          SizedBox(
                              width: 4), // Khoảng cách giữa "Type:" và "Cat"
                          Text(
                            '(${appointments.length})',
                            style: TextStyle(
                              color: Color(0xFFB12A1C),
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 362.03,
                    height: 117,
                    decoration: ShapeDecoration(
                      color: Color(0xFFEFEFEF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (BuildContext context, int index) {
                        final appointment = appointments[index];
                        // Assuming appointment.appointmentDate is a DateTime? type
                        DateTime? appointmentDate = appointment.appointmentDate;
                        String getFormattedDate() {
                          return appointmentDate != null
                              ? appointmentDate!.toString().substring(0, 10)
                              : '';
                        }

                        return Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  "Date: ${getFormattedDate()}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment:
                                  Alignment.topLeft, // Căn lề dưới và trái
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 40),
                                child: Row(
                                  children: [
                                    Text(
                                      "Time: ${appointment.timeSlot ?? ''}",
                                      style: TextStyle(
                                        color: Color(0xFF979797),
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        height: 0.16,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            4), // Khoảng cách giữa "Type:" và "Cat"
                                  ],
                                ),
                              ),
                            ),
                            // Add other widgets for appointment details if needed
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical:
                                        0), // Căn chỉnh theo nhu cầu của bạn
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 60, vertical: 10),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        //schedule appointmentDate
                                        notificationServices
                                            .sendNotificationFirst(
                                          'You have set an alert for appointment on: ',
                                          appointmentDate,
                                        );

                                        notificationServices.sendNotification(
                                          'You have an appointment at Pets4life tomorrow: ',
                                          appointmentDate,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        backgroundColor: isClicked
                                            ? Colors.black
                                            : Color(0xFFB12A1C),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.alarm,
                                            color: Colors.white,
                                            size:
                                                20, // Adjust the size as needed
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 16.0), // Điều chỉnh giá trị left tùy ý
                      child: Row(
                        children: [
                          Text(
                            'Recommended Products',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          SizedBox(
                              width: 40), // Khoảng cách giữa "Type:" và "Cat"
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => shop()),
                              );
                            },
                            child: Text(
                              'See All',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 16.0), // Điều chỉnh giá trị left tùy ý
                      child: Row(
                        children: [
                          Text(
                            'Based on previous purchases and similar pet owners',
                            style: TextStyle(
                              color: Color(0xFF979797),
                              fontSize: 10,
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
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 350,
                      enlargeCenterPage: true,
                      autoPlay: true,
                    ),
                    items: products.map((product) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  product.image ?? '',
                                  width: 200,
                                  height: 200,
                                ),
                                SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            80), // Điều chỉnh giá trị left tùy ý
                                    child: Row(
                                      children: [
                                        Text(
                                          product.brand ?? '',
                                          style: TextStyle(
                                            color: Color(0xFF979797),
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                50), // Khoảng cách giữa "Type:" và "Cat"
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        Text(
                                          '4.9',
                                          style: TextStyle(
                                            color: Color(0xFFABABAB),
                                            fontSize: 10,
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
                                  height: 20,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 60),
                                    child: Row(
                                      children: [
                                        Text(
                                          product.productName ?? '',
                                          style: TextStyle(
                                            color: Color(0xFF3F434A),
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            height: 0.14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 60),
                                    child: Row(
                                      children: [
                                        Text(
                                          "\$${product.price != null ? product.price!.toStringAsFixed(2) : 'N/A'}",
                                          style: TextStyle(
                                            color: Color(0xFFB12A1C),
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 16.0), // Điều chỉnh giá trị left tùy ý
                      child: Row(
                        children: [
                          Text(
                            'Recommended Services',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          SizedBox(
                              width: 40), // Khoảng cách giữa "Type:" và "Cat"
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => shop(
                                      initialTabIndex:
                                          1), // Set initialTabIndex
                                ),
                              );
                            },
                            child: Text(
                              'See All',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 16.0), // Điều chỉnh giá trị left tùy ý
                      child: Row(
                        children: [
                          Text(
                            'Based on previously booked services',
                            style: TextStyle(
                              color: Color(0xFF979797),
                              fontSize: 10,
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
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 350,
                      enlargeCenterPage: true,
                      autoPlay: true,
                    ),
                    items: services.map((service) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  service.image ?? '',
                                  width: 200,
                                  height: 200,
                                ),
                                SizedBox(height: 5),
                                SizedBox(
                                  height: 20,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 60),
                                    child: Row(
                                      children: [
                                        Text(
                                          service.serviceName ?? '',
                                          style: TextStyle(
                                            color: Color(0xFF3F434A),
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            height: 0.14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 60),
                                    child: Row(
                                      children: [
                                        Text(
                                          "\$${service.price != null ? service.price!.toStringAsFixed(2) : 'N/A'}",
                                          style: TextStyle(
                                            color: Color(0xFFB12A1C),
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  IndexedStack(
                    index: _currentIndex,
                    children: _screens,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              // Add conditions for other tabs if needed.
              // Add conditions for other tabs if needed.
              if (index == 1) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => shop()),
                );
              }
              if (index == 2) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => InsightPageView()),
                );
              }
              if (index == 3) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => userprofile()),
                );
              }
              if (index == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => home()),
                );
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0 ? Color(0xFFB12A1C) : Colors.black,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.pets,
                  color: _currentIndex == 1 ? Color(0xFFB12A1C) : Colors.black,
                ),
                label: 'Shop',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.bar_chart,
                  color: _currentIndex == 2 ? Color(0xFFB12A1C) : Colors.black,
                ),
                label: 'Insight',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: _currentIndex == 3 ? Color(0xFFB12A1C) : Colors.black,
                ),
                label: 'Profile',
              ),
            ],
            selectedItemColor: Color(0xFFB12A1C), // Màu của label khi được chọn
            unselectedItemColor:
                Colors.black, // Màu của label khi không được chọn
            selectedLabelStyle:
                TextStyle(color: Colors.black), // Màu của chữ label
            unselectedLabelStyle: TextStyle(color: Color(0xFFB12A1C)),
          ),
        ));
  }
}
