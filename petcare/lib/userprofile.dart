import 'package:flutter/material.dart';
import 'package:petcare/InsightPageView.dart';
import 'package:petcare/api-petcare/api.dart';
import 'package:petcare/home.dart';
import 'package:petcare/information_user.dart';
import 'package:petcare/insight.dart';
import 'package:petcare/login.dart';
import 'package:petcare/model-petcare/user.dart';
import 'package:petcare/order.dart';
import 'package:petcare/pets.dart';
import 'package:petcare/session-petcare/session.dart';
import 'package:petcare/shop.dart';

class userprofile extends StatefulWidget {
  const userprofile({super.key});

  @override
  State<userprofile> createState() => _userprofileState();
}

class _userprofileState extends State<userprofile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDrawerOpen = false;
  bool isClicked = false;
  int _currentIndex = 3;
  final List<Widget> _screens = [];

  late User? user = User();

  final userId = SessionManager().getUserId() ??
      0; // Use 0 as a default value, but you can choose a different default if needed

  String fullName = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();

    _controller = AnimationController(vsync: this);
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
    return Scaffold(
      key: _scaffoldKey,
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
                  SizedBox(
                      width:
                          50), // Khoảng cách giữa biểu tượng và văn bản "Home"
                  Text(
                    'Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  SizedBox(width: 50),
                  // Khoảng cách giữa biểu tượng và văn bản "Home"
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text(
                  'Hi, ${user!.fullName ?? ""}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: Ink(
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFFBD58), // Màu nền cho nút
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Bo góc nút
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Xử lý khi người dùng nhấn nút
                      setState(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => order(),
                          ),
                        );
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0), // Khoảng cách giữa phần tử
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.history, color: Colors.black),
                        title: Text(
                          'History Treatment',
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(
                          Icons.arrow_right_sharp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Ink(
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFFBD58), // Màu nền cho nút
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Bo góc nút
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Xử lý khi người dùng nhấn nút
                      setState(() {
                        isDrawerOpen = false; // Ẩn Drawer sau khi nhấn nút
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => informationuser(),
                          ),
                        );
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0), // Khoảng cách giữa phần tử
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.people, color: Colors.black),
                        title: Text(
                          'Information',
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(
                          Icons.arrow_right_sharp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Ink(
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFFBD58), // Màu nền cho nút
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Bo góc nút
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Xử lý khi người dùng nhấn nút
                      setState(() {
                        isDrawerOpen = false; // Ẩn Drawer sau khi nhấn nút
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => pets()),
                        );
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0), // Khoảng cách giữa phần tử
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.pets, color: Colors.black),
                        title: Text(
                          'Pets',
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(
                          Icons.arrow_right_sharp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Ink(
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFFBD58), // Màu nền cho nút
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Bo góc nút
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Xử lý khi người dùng nhấn nút
                      setState(() {
                        isDrawerOpen = false; // Ẩn Drawer sau khi nhấn nút
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0), // Khoảng cách giữa phần tử
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.exit_to_app, color: Colors.black),
                        title: Text(
                          'Log Out',
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          //log out
                          SessionManager().clearSession();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => login(),
                          ));
                        },
                        trailing: Icon(
                          Icons.arrow_right_sharp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
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
        unselectedItemColor: Colors.black, // Màu của label khi không được chọn
        selectedLabelStyle: TextStyle(color: Colors.black), // Màu của chữ label
        unselectedLabelStyle: TextStyle(color: Color(0xFFB12A1C)),
      ),
    );
  }
}
