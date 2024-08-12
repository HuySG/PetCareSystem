import 'package:flutter/material.dart';
import 'package:petcare/api-petcare/api.dart';
import 'package:petcare/information_pet.dart';
import 'package:petcare/model-petcare/pet.dart';
import 'package:petcare/session-petcare/session.dart';
import 'package:petcare/update_information_pet.dart';
import 'package:petcare/userprofile.dart';

class pets extends StatefulWidget {
  const pets({super.key});

  @override
  State<pets> createState() => _petsState();
}

class _petsState extends State<pets> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isClicked = false;

  late List<Pet> listPet = [];

  final userId = SessionManager().getUserId() ??
      0; // Use 0 as a default value, but you can choose a different default if needed

  @override
  void initState() {
    super.initState();
    loadPets();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void loadPets() async {
    List<Pet> loadedPets = await API.getPetsByUserId(userId);
    setState(() {
      listPet = loadedPets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF9F1EF),
        title: Text(
          'Pets',
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
              builder: (context) => userprofile(),
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
              for (final pet in listPet)
                GestureDetector(
                  // onTap: () {
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => updateinformationpets(),
                  //   ));
                  // },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10), // Add margin here
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: ShapeDecoration(
                              color: Color(0xFFFFE8CC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: ShapeDecoration(
                              color: Color(0xFFFFBD58),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 261.19,
                          top: 54.05,
                          child: Container(
                            width: 181.38,
                            height: 188.53,
                            decoration: ShapeDecoration(
                              color: Color(0xFFFFCFCF),
                              shape: OvalBorder(),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 245.47,
                          top: 38.96,
                          child: Container(
                            width: 211.62,
                            height: 219.95,
                            decoration: ShapeDecoration(
                              shape: OvalBorder(
                                side: BorderSide(
                                    width: 3, color: Color(0xFFFFCFCF)),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 18.14,
                          top: 60.33,
                          child: SizedBox(
                            width: 270.87,
                            height: 67.87,
                            child: Text(
                              'Weight: ${pet.weight} kg',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0.12,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 18.14,
                          top: 70.33,
                          child: SizedBox(
                            width: 270.87,
                            child: Text(
                              'DOB: ${pet.dateOfBirth?.substring(0, 10)}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 18.14,
                          top: 21.37,
                          child: SizedBox(
                            width: 108.83,
                            height: 27.65,
                            child: Text(
                              '${pet.petName}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 273.29,
                          top: 18.85,
                          child: Container(
                            width: 96.74,
                            height: 100.55,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: NetworkImage(pet.imageProfile ??
                                    'https://via.placeholder.com/97x101'),
                                fit: BoxFit.fill,
                              ),
                              shape: OvalBorder(
                                side: BorderSide(
                                    width: 4, color: Color(0xFFFDCECE)),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x26646464),
                                  blurRadius: 20,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => informationpets(),
                  ));
                },
                child: Container(
                  width: 100,
                  height: 100,
                  child: Stack(
                    children: [
                      // Hình tròn màu xám
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: ShapeDecoration(
                            color: Color(0xFFE7E7E7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      // Biểu tượng "plus"
                      Positioned(
                        left: 25,
                        top: 25,
                        child: Icon(
                          Icons.add,
                          size: 50,
                          color: Colors.black,
                        ),
                      ),
                    ],
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
