import 'package:flutter/material.dart';
import 'package:petcare/home.dart';
import 'package:petcare/shop.dart';

class payment extends StatefulWidget {
  const payment({super.key});

  @override
  State<payment> createState() => _paymentState();
}

class _paymentState extends State<payment> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isClicked = false;
  int _currentIndex = 2;
  final List<Widget> _screens = [];
  bool isShopSelected = false;
  bool isServiceeSelected = false;
  bool _isShopActive = true;
  bool _isServiceActive = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      'Insight',
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
                ],
              ),
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
                          'Leo’s Data',
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
                            image: NetworkImage(
                                'https://via.placeholder.com/97x101'),
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
                            // Xử lý khi nút "Shop" được nhấn
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => shop()),
                            );
                            setState(() {
                              _isShopActive = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: _isShopActive
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
                            'Health',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
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
                            // Xử lý khi nút "Service" được nhấn
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => home()),
                            );
                            setState(() {
                              _isServiceActive = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: _isServiceActive
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
                              color: Color(0xFF888888),
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
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0), // Điều chỉnh giá trị left tùy ý
                  child: Row(
                    children: [
                      Text(
                        'Based on your inputs',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF979797),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )
                    ],
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
    );
  }
}
