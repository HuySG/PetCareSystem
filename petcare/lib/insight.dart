import 'package:flutter/material.dart';
import 'package:petcare/InsightPageView.dart';
import 'package:petcare/api-petcare/api.dart';
import 'package:petcare/home.dart';
import 'package:petcare/model-petcare/appointment.dart';
import 'package:petcare/model-petcare/pet.dart';
import 'package:petcare/session-petcare/session.dart';

import 'package:petcare/shop.dart';
import 'package:petcare/userprofile.dart';

class insight extends StatefulWidget {
  final Pet pet;
  const insight({required this.pet, Key? key}) : super(key: key);

  @override
  State<insight> createState() => _insightState();
}

class _insightState extends State<insight> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isClicked = false;
  int _currentIndex = 2;
  final List<Widget> _screens = [];
  bool isShopSelected = false;
  bool isServiceeSelected = false;
  bool _isShopActive = true;
  bool _isServiceActive = true;
  double _sliderValue = 0.0;
  double _sliderValue1 = 0.0;
  bool _showMonitoringContent =
      false; // Control the visibility of the Monitoring content
  bool _showHealthContent = false;

  bool isHealthButtonClicked = true;
  bool isMonitoringButtonClicked = false;

  //get pets
  final userId = SessionManager().getUserId() ??
      0; // Use 0 as a default value, but you can choose a different default if needed

  late List<Appointment> listAppointmentByPet = [];
  @override
  void initState() {
    super.initState();
    // Set _sliderValue based on pet.Diabetes
    _sliderValue = widget.pet.diabetes!.toDouble();
    _sliderValue1 = widget.pet.arthritis!.toDouble();
    _controller = AnimationController(vsync: this);
    // Set initial values for content visibility
    _showMonitoringContent = false;
    _showHealthContent = true;

    fetchAppointments();
  }

  // Container buildPetContainer() {
  //   return Container;
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<Appointment>?> fetchAppointments() async {
    listAppointmentByPet = await API.getAppointmentByPet(widget.pet.petId ?? 0);

    // Filtering appointments where notes is equal to 'APPROVED'
    List<Appointment> approvedAppointments = listAppointmentByPet
        .where((appointment) => appointment.notes == 'DONE')
        .toList();

    for (Appointment a in approvedAppointments) {
      print(a.appointmentId.toString());
    }

    print('Pet co id: ' +
        widget.pet.petId.toString() +
        "co" +
        approvedAppointments.length.toString() +
        " cuoc hen");

    listAppointmentByPet = approvedAppointments;

    return approvedAppointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
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
                            side:
                                BorderSide(width: 3, color: Color(0xFFFFCFCF)),
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
                          'Letting data talk for your pet.',
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
                      top: 21.37,
                      child: SizedBox(
                        width: 108.83,
                        height: 27.65,
                        child: Text(
                          '${widget.pet.petName} Data',
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
                            image: NetworkImage(widget.pet.imageProfile ?? ""),
                            fit: BoxFit.fill,
                          ),
                          shape: OvalBorder(
                            side:
                                BorderSide(width: 4, color: Color(0xFFFDCECE)),
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
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isHealthButtonClicked = true;
                              isMonitoringButtonClicked = false;
                              _showMonitoringContent = false;
                              _showHealthContent = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: isHealthButtonClicked
                                ? Colors.black
                                : Color(0xFFFAFAFA),
                            side: BorderSide(
                              color: Color(0xFF888888),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200),
                            ),
                          ),
                          child: Text(
                            'Health',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isHealthButtonClicked
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          )),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isHealthButtonClicked = false;
                              isMonitoringButtonClicked = true;
                              _showMonitoringContent = true;
                              _showHealthContent = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: isMonitoringButtonClicked
                                ? Colors.black
                                : Color(0xFFFAFAFA),
                            side: BorderSide(
                              color: Color(0xFFECECEC),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200),
                            ),
                          ),
                          child: Text(
                            'Monitoring',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isMonitoringButtonClicked
                                  ? Colors.white
                                  : Color(0xFF888888),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              if (_showMonitoringContent)
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: -20,
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
                          height: MediaQuery.of(context).size.height * 1,
                          decoration: ShapeDecoration(
                            color: Color(0xFFECECEC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 50,
                        top: 20,
                        child: Text(
                          'History Treatment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 50,
                        top: 50,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${widget.pet.petName} is ',
                                style: TextStyle(
                                  color: Color(0xFF767676),
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${listAppointmentByPet.length.toString()}',
                                style: TextStyle(
                                  color: Color(0xFFB12A1C),
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                              TextSpan(
                                text: ' ',
                                style: TextStyle(
                                  color: Color(0xFFB12A1C),
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                              TextSpan(
                                text: 'time',
                                style: TextStyle(
                                  color: Color(0xFFB12A1C),
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 250,
                        top: 10,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.medical_services),
                          iconSize: 50,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              if (_showHealthContent)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 16.0), // Điều chỉnh giá trị left tùy ý
                    child: Row(
                      children: [
                        Text(
                          'Health Risks',
                          style: TextStyle(
                            color: Colors.black,
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
                height: 30,
              ),
              if (_showHealthContent)
                GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 1,
                            decoration: ShapeDecoration(
                              color: Color(0xFFECECEC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 40,
                          top: 10,
                          child: Text(
                            'Risk of Diabetes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 80,
                          width: 330,
                          child: Slider(
                            value: _sliderValue,
                            min: 0.0,
                            max: 100.0,
                            activeColor: Color(0xFFB12A1C),
                            onChanged: (newValue) {
                              setState(
                                () {
                                  _sliderValue = newValue;
                                },
                              );
                            },
                          ),
                        ),
                        Positioned(
                          left: 165,
                          top: 93,
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, 0.0)
                              ..rotateZ(1.57),
                            child: Container(
                              width: 24.10,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 50,
                          top: 120,
                          child: Text(
                            'Low Risk',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 230,
                          top: 120,
                          child: Text(
                            'High Risk',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 30,
              ),
              if (_showHealthContent)
                GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.3,
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
                            height: MediaQuery.of(context).size.height * 1,
                            decoration: ShapeDecoration(
                              color: Color(0xFFECECEC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            left: 40,
                            top: 10,
                            child: Text(
                              'Risk of Arthritis',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            )),
                        Positioned(
                          left: 0,
                          top: 80,
                          width: 330,
                          child: Slider(
                            value: _sliderValue1,
                            min: 0.0,
                            max: 100.0,
                            activeColor: Color(0xFFFFBD58),
                            onChanged: (newValue) {
                              setState(
                                () {
                                  _sliderValue1 = newValue;
                                },
                              );
                            },
                          ),
                        ),
                        Positioned(
                          left: 165,
                          top: 93,
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, 0.0)
                              ..rotateZ(1.57),
                            child: Container(
                              width: 24.10,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 50,
                          top: 120,
                          child: Text(
                            'Low Risk',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 230,
                          top: 120,
                          child: Text(
                            'High Risk',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
    );
  }
}
