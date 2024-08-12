import 'package:flutter/material.dart';
import 'package:petcare/api-petcare/api.dart';
import 'package:petcare/model-petcare/appointment.dart';
import 'package:petcare/model-petcare/order-detail.dart';
import 'package:petcare/model-petcare/order.dart';
import 'package:petcare/model-petcare/pet.dart';
import 'package:petcare/session-petcare/session.dart';
import 'package:petcare/userprofile.dart';

class order extends StatefulWidget {
  const order({super.key});

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isClicked = false;

  late List<Appointment> listAppointment = [];
  late List<Pet> listPets = [];
  final userId = SessionManager().getUserId() ?? 0;

  @override
  void initState() {
    super.initState();
    loadAppointments();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void loadAppointments() async {
    List<Appointment> loadedAppointments =
        await API.getAppointmentByUser(userId);
    List<Pet> loadedPets = [];

    for (Appointment a in loadedAppointments) {
      // Use await to get the pet data
      Pet pet = await API.getPet(a.petId);
      loadedPets.add(pet);
    }

    setState(() {
      listAppointment = loadedAppointments;
      listPets = loadedPets; // Assuming you have a list for pets
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF9F1EF),
        title: Text(
          'History Treatment',
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
              for (final appointment in listAppointment)
                GestureDetector(
                  onTap: () {
                    // Xử lý khi bấm vào toàn bộ Container
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => Scaffold(),
                    // ));
                  },
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 0,
                          child: Divider(
                            color: Colors.black, // Thay đổi màu sắc tại đây
                            thickness: 0.7, // Đặt độ dày của đường kẻ
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFFFE8CC),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFFFBD58),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 150,
                                  top: 90,
                                  child: SizedBox(
                                    width: 270.87,
                                    height: 67.87,
                                    child: Text(
                                      'X1',
                                      style: TextStyle(
                                        color: Color(0xFFB12A1C),
                                        fontSize: 15,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 150,
                                  top: 70,
                                  child: SizedBox(
                                    width: 270.87,
                                    height: 67.87,
                                    child: Text(
                                      'Type: ${appointment.purpose}',
                                      style: TextStyle(
                                        color: Color(0xFFB12A1C),
                                        fontSize: 15,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 150,
                                  top: 60.33,
                                  child: SizedBox(
                                    width: 270.87,
                                    height: 67.87,
                                    child: Text(
                                      'Date: ${appointment.appointmentDate?.toString().substring(0, 10) ?? "N/A"}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        height: 0.12,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 150,
                                  top: 10,
                                  child: SizedBox(
                                    width: 200,
                                    height: 50,
                                    child: Text(
                                      '${appointment.timeSlot}',
                                      style: TextStyle(
                                        color: Color(0xFF3F434A),
                                        fontSize: 15,
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
                                ),
                                for (final pet in listPets)
                                  Positioned(
                                    left: 25,
                                    top: 18.85,
                                    child: Container(
                                      width: 96.74,
                                      height: 100.55,
                                      decoration: ShapeDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              '${listPets.firstWhere((pet) => pet.petId == appointment.petId).imageProfile}'),
                                          fit: BoxFit.fill,
                                        ),
                                        shape: OvalBorder(
                                          side: BorderSide(
                                              width: 4,
                                              color: Color(0xFFFDCECE)),
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 0,
                          child: Divider(
                            color: Colors.black, // Thay đổi màu sắc tại đây
                            thickness: 0.7, // Đặt độ dày của đường kẻ
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFFFE8CC),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFFFBD58),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 120,
                                  top: 30,
                                  child: SizedBox(
                                    width: 100,
                                    child: Text(
                                      'Status:',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0.07,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 190,
                                  top: 30,
                                  child: SizedBox(
                                    width: 190,
                                    child: Text(
                                      '${appointment.notes}',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0.07,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 0,
                          child: Divider(
                            color: Colors.black, // Thay đổi màu sắc tại đây
                            thickness: 0.7, // Đặt độ dày của đường kẻ
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              // phân cách giữa cái orders
            ],
          ),
        ),
      ),
    );
  }
}
