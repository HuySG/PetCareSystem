import 'package:flutter/material.dart';
import 'package:petcare/api-petcare/api.dart';
import 'package:petcare/home.dart';
import 'package:petcare/insight.dart';
import 'package:petcare/model-petcare/pet.dart';
import 'package:petcare/session-petcare/session.dart';
import 'package:petcare/shop.dart';
import 'package:petcare/userprofile.dart';

class InsightPageView extends StatefulWidget {
  const InsightPageView({Key? key}) : super(key: key);

  @override
  _InsightPageViewState createState() => _InsightPageViewState();
}

class _InsightPageViewState extends State<InsightPageView> {
  int _currentIndexx = 0;
  int _currentIndex = 2;

  final List<Pet> listPet = []; // Your list of pets
  final userId = SessionManager().getUserId() ??
      0; // Use 0 as a default value, but you can choose a different default if needed

  @override
  void initState() {
    super.initState();
    loadPets();
  }

  void loadPets() async {
    List<Pet> loadedPets = await API.getPetsByUserId(userId);
    setState(() {
      listPet.addAll(loadedPets);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Insight', // Display the pet's name
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: listPet.length,
              controller: PageController(initialPage: _currentIndexx),
              onPageChanged: (int index) {
                setState(() {
                  _currentIndexx = index;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return insight(pet: listPet[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => home()),
            );
          }
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
        selectedItemColor: Colors.red, // Màu của label khi được chọn
        unselectedItemColor: Colors.black, // Màu của label khi không được chọn
        selectedLabelStyle: TextStyle(color: Colors.black), // Màu của chữ label
        unselectedLabelStyle: TextStyle(color: Colors.red),
      ),
      // Other widgets and configurations
    );
  }
}
