import 'package:flutter/material.dart';
import 'package:petcare/api-petcare/api.dart';
import 'package:petcare/model-petcare/user.dart';
import 'package:petcare/session-petcare/session.dart';
import 'package:petcare/userprofile.dart';

class informationuser extends StatefulWidget {
  const informationuser({super.key});

  @override
  State<informationuser> createState() => _informationuserState();
}

class _informationuserState extends State<informationuser>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isClicked = false;

  late User? user = User();

  final userId = SessionManager().getUserId() ?? 0;

  // Define form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    fetchUserData().then((_) {
      // print('User data retrieved: $user');
      if (user != null) {
        _passwordController.text = user!.password ?? '';
        _fullNameController.text = user!.fullName ?? '';
        _addressController.text = user!.address ?? '';
        _phonecontroller.text = user!.phone ?? '';
      }
      setState(() {});
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

  //register form get data
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phonecontroller = TextEditingController();

  //register function
  Future<void> _updateUser() async {
    final password = _passwordController.text;
    final fullName = _fullNameController.text;
    final address = _addressController.text;
    final phone = _phonecontroller.text;
    final email = user!.email ?? "";
    final gender = user!.gender;
    final createdDate = user!.createdDate;
    final authCode = user!.authCode ?? "";
    final status = user!.status;
    final isStaff = user!.isStaff;
    final dob = user!.dateOfBirth;

    // Call the registerUser function from the API class
    await API.updateUser(
        userId: userId,
        password: password,
        fullName: fullName,
        address: address,
        phone: phone,
        email: email,
        gender: gender ?? false,
        createdDate: createdDate.toString(),
        authCode: authCode.toString(),
        status: status ?? false,
        isStaff: isStaff ?? false,
        dateOfBirth: dob.toString());
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => userprofile(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFF9F1EF),
          title: Text(
            'Information',
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
                isClicked =
                    !isClicked; // Chuyển đổi trạng thái khi nút được nhấn
              });
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => userprofile(),
              ));
            },
          ),
        ),
        backgroundColor: Color(0xFFF9F1EF),
        body: SingleChildScrollView(
          child: Center(
            key: _formKey, // Assign the form key
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    obscureText: true, // To hide the password input
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Color(0xFFD9D9D9),
                      labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      enabledBorder: OutlineInputBorder(
                        // Độ to và màu sắc của viền khi trường chưa được chọn
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      // You can add additional email format validation here if needed
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      filled: true,
                      fillColor: Color(0xFFD9D9D9),
                      labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      enabledBorder: OutlineInputBorder(
                        // Độ to và màu sắc của viền khi trường chưa được chọn
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    controller: _fullNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      // You can add additional email format validation here if needed
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Address',
                      filled: true,
                      fillColor: Color(0xFFD9D9D9),
                      labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      enabledBorder: OutlineInputBorder(
                        // Độ to và màu sắc của viền khi trường chưa được chọn
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    controller: _addressController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address is required';
                      }
                      // You can add additional email format validation here if needed
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      filled: true,
                      fillColor: Color(0xFFD9D9D9),
                      labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      enabledBorder: OutlineInputBorder(
                        // Độ to và màu sắc của viền khi trường chưa được chọn
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    controller: _phonecontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone is required';
                      }
                      // Check if the value starts with '0' and contains exactly 10 digits
                      if (!RegExp(r'^0[0-9]{9}$').hasMatch(value)) {
                        return 'Phone must start with 0 and be a 10-digit number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _updateUser();
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor:
                          isClicked ? Colors.black : Color(0xFFFFBD58),
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: isClicked ? Colors.white : Colors.black,
                        fontSize: 25,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
