import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petcare/model-petcare/appointment.dart';
import 'package:petcare/model-petcare/order-detail.dart';
import 'package:petcare/model-petcare/order.dart';
import 'package:petcare/model-petcare/pet.dart';
import 'package:petcare/model-petcare/product.dart';
import 'package:petcare/model-petcare/service.dart';
import 'package:petcare/model-petcare/user.dart';
import 'package:petcare/session-petcare/session.dart';

typedef AuthCodeCallback = void Function(String authCode);

class API {
  static Future<void> registerUser({
    required String email,
    required String password,
    required String fullName,
    required String address,
    required bool gender,
    required String dateOfBirth,
    required String phone,
    required AuthCodeCallback authCodeCallback, // Add the callback parameter
  }) async {
    final userData = {
      "email": email,
      "password": password,
      "fullName": fullName,
      "address": address,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "phone": phone
    };

    final jsonData = jsonEncode(userData);

    // Print the JSON data before making the API call
    print('JSON Data: $jsonData');

    final response = await http.post(
      Uri.parse('http://pets4life.fptu.meu-solutions.com/api/User/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 201) {
      print('Registration successful');
      // Parse the JSON response
      final jsonResponse = jsonDecode(response.body);

      // Extract the authCode
      final authCode = jsonResponse['authCode'];
      final userId = jsonResponse['userId'];

      // Set the userId in session
      SessionManager().setUserId(userId);

      // Now you can use the authCode as needed
      print('Auth Code: $authCode');

      // Pass the authCode to the callback function
      authCodeCallback(authCode.toString());
    } else {
      print('Registration failed');
      // Print the JSON data before making the API call
      print('JSON Data: $jsonData');
    }
  }

  //update user
  static Future<void> updateUser(
      {required int userId,
      required String email,
      required String password,
      required String fullName,
      required String address,
      required bool gender,
      required String dateOfBirth,
      required String phone,
      required String createdDate,
      required String authCode,
      required bool status,
      required bool isStaff}) async {
    final userData = {
      "userId": userId,
      "email": email,
      "password": password,
      "fullName": fullName,
      "address": address,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "phone": phone,
      "createdDate": createdDate,
      "authCode": authCode,
      "status": status,
      "isStaff": isStaff
    };

    final jsonData = jsonEncode(userData);

    // Print the JSON data before making the API call
    print('JSON Data: $jsonData');

    final response = await http.put(
      Uri.parse('http://pets4life.fptu.meu-solutions.com/api/User/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      print('Update successful');
      // Parse the JSON response
      final jsonResponse = jsonDecode(response.body);

      final userId = jsonResponse['userId'];

      // Now you can use the authCode as needed
    } else {
      print('Update failed');
      // Print the JSON data before making the API call
      print('JSON Data: $jsonData');
    }
  }

//get list users
  static Future<void> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://pets4life.fptu.meu-solutions.com/api/User'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final List<dynamic> userList = jsonDecode(response.body);

        // Print the list of users
        userList.forEach((user) {
          print('User ID: ${user['userId']}');
          print('Email: ${user['email']}');
          print('Full Name: ${user['fullName']}');
          // Add more fields as needed
          print('--------------------------');
        });
      } else {
        // If the request fails, print an error message
        print('Failed to fetch users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      print('An error occurred: $e');
    }
  }

//verify
  static Future<void> verifyUser(String otp, String email) async {
    final apiUrl =
        'http://pets4life.fptu.meu-solutions.com/api/User/verify?otp=$otp&email=$email';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        // Verification successful
        print('Verification successful');
        print('link: ' + apiUrl);
        // Handle the response data here if needed
      } else if (response.statusCode == 400) {
        // Bad request
        print('Verification failed. Bad request.');
        print('link: ' + apiUrl);
      } else {
        // Request failed with another status code
        print('Verification failed with status code: ${response.statusCode}');
        print('link: ' + apiUrl);
      }
    } catch (e) {
      // An error occurred
      print('Error during verification: $e');
      print('link: ' + apiUrl);
    }
  }

  //login
  static Future<bool> loginUser(String email, String password) async {
    final loginData = {
      "email": email,
      "password": password,
    };

    final jsonData = jsonEncode(loginData);

    // Print the JSON data before making the API call
    print('JSON Data: $jsonData');

    try {
      final response = await http.post(
        Uri.parse('http://pets4life.fptu.meu-solutions.com/api/User/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        // Login successful
        print('Login successful');
        // Parse the JSON response
        final jsonResponse = jsonDecode(response.body);

        // Handle the response data here if needed
        final userId = jsonResponse['userId'];

        // Set the userId in session
        SessionManager().setUserId(userId);

        print('day la session id: ' + SessionManager().getUserId().toString());

        // Return true to indicate a successful login
        return true;
      } else if (response.statusCode == 400) {
        // Bad request
        print('Login failed. Bad request.');
      } else {
        // Request failed with another status code
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      // An error occurred
      print('Error during login: $e');
    }

    // Return false to indicate a failed login
    return false;
  }

  //get detail user
  static Future<User> getUser(int userId) async {
    final apiUrl =
        'http://pets4life.fptu.meu-solutions.com/api/User/$userId'; // Replace with your API URL

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final dynamic userJson = jsonDecode(response.body);

        // Map the JSON object to a User object and return it
        return User.fromJson(userJson);
      } else {
        // If the request fails, throw an exception or return null
        throw Exception(
            'Failed to fetch user by user id. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      throw Exception('An error occurred: $e');
    }
  }

  //create pet api
  static Future<void> createPet({
    required String petName,
    required String petType,
    required String breed,
    required bool gender,
    required String dateOfBirth,
    required double weight,
    required String currentDiet,
    required String note,
    required String imageProfile,
    required int? userId,
  }) async {
    final userData = {
      "petName": petName,
      "petType": petType,
      "breed": breed,
      "weight": weight,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "note": note,
      "currentDiet": currentDiet,
      "imageProfile": imageProfile,
      "userId": userId
    };

    final jsonData = jsonEncode(userData);

    // Print the JSON data before making the API call
    print('JSON Data: $jsonData');

    final response = await http.post(
      Uri.parse('http://pets4life.fptu.meu-solutions.com/api/Pet'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 201) {
      print('Pet Created successful');
      // Parse the JSON response
      final jsonResponse = jsonDecode(response.body);
    } else {
      print('Pet Created failed');
      // Print the JSON data before making the API call
      print('JSON Data: $jsonData');
    }
  }

  //get pets by userID
  static Future<List<Pet>> getPetsByUserId(int userId) async {
    final apiUrl =
        'http://pets4life.fptu.meu-solutions.com/api/Pet/byUser/$userId'; // Replace with your API URL

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final List<dynamic> petListJson = jsonDecode(response.body);

        // Map each JSON object to a Pet object and return a list of pets
        return petListJson.map((json) => Pet.fromJson(json)).toList();
      } else {
        // If the request fails, throw an exception or return an empty list
        throw Exception(
            'Failed to fetch pets. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      throw Exception('An error occurred: $e');
    }
  }

  static Future<Pet> getPet(int? petId) async {
    final apiUrl =
        'http://pets4life.fptu.meu-solutions.com/api/Pet/$petId'; // Replace with your API URL

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final dynamic petJson = jsonDecode(response.body);

        // Map the JSON object to a User object and return it
        return Pet.fromJson(petJson);
      } else {
        // If the request fails, throw an exception or return null
        throw Exception(
            'Failed to fetch pet. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      throw Exception('An error occurred: $e');
    }
  }

  //get list products
  static Future<List<Product>> getProducts() async {
    final apiUrl =
        'http://pets4life.fptu.meu-solutions.com/api/Product'; // Replace with your API URL

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final List<dynamic> productListJson = jsonDecode(response.body);

        // Map each JSON object to a Pet object and return a list of pets
        return productListJson.map((json) => Product.fromJson(json)).toList();
      } else {
        // If the request fails, throw an exception or return an empty list
        throw Exception(
            'Failed to fetch products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      throw Exception('An error occurred: $e');
    }
  }

  //get product by productId
  static Future<List<Product>> getProduct(int productId) async {
    final apiUrl =
        'http://pets4life.fptu.meu-solutions.com/api/Product/$productId'; // Replace with your API URL

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final dynamic productDetail = jsonDecode(response.body);

        // Map each JSON object to a Pet object and return a list of pets
        return productDetail.map((json) => Product.fromJson(json));
      } else {
        // If the request fails, throw an exception or return an empty list
        throw Exception(
            'Failed to fetch product. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      throw Exception('An error occurred: $e');
    }
  }

  //get list services
  static Future<List<Service>> getServices() async {
    final apiUrl =
        'http://pets4life.fptu.meu-solutions.com/api/Service'; // Replace with your API URL

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final List<dynamic> serviceListJson = jsonDecode(response.body);
        print('lay list service thanh cong');

        // Map each JSON object to a Pet object and return a list of pets
        return serviceListJson.map((json) => Service.fromJson(json)).toList();
      } else {
        // If the request fails, throw an exception or return an empty list
        print('lay list service khong thanh cong');
        throw Exception(
            'Failed to fetch services. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      throw Exception('An error occurred: $e');
    }
  }

  //add appointment
  static Future<void> createAppointment(
      {required Appointment? appointment}) async {
    final userData = {
      "petId": appointment!.petId,
      "vetId": 1,
      "timeSlot": appointment.timeSlot,
      "purpose": appointment.purpose,
      "notes": appointment.notes
    };

    final jsonData = jsonEncode(userData);

    // Print the JSON data before making the API call
    print('JSON Data: $jsonData');

    final response = await http.post(
      Uri.parse('http://pets4life.fptu.meu-solutions.com/api/Appoinment'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 201) {
      print('Appointment Created successful');
      // Parse the JSON response
      final jsonResponse = jsonDecode(response.body);
    } else {
      print('Appointment Created failed');
      // Print the JSON data before making the API call
      print('JSON Data: $jsonData');
    }
  }

  // Add 'Future<int>' as the return type
  static Future<int> createOrder({required Order? order}) async {
    final orderData = {
      "userId": order!.userId,
      "totalAmount": order.totalAmount
    };

    final jsonData = jsonEncode(orderData);

    // Print the JSON data before making the API call
    print('JSON Data: $jsonData');

    final response = await http.post(
      Uri.parse('http://pets4life.fptu.meu-solutions.com/api/Order'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 201) {
      print('Order Created successful');
      // Parse the JSON response
      final jsonResponse = jsonDecode(response.body);

      // Extract and return the orderID from the jsonResponse
      final orderID = jsonResponse['orderId'] as int;

      return orderID; // Return the orderID
    } else {
      print('Order Created failed');
      // Print the JSON data before making the API call
      print('JSON Data: $jsonData');
      // Return a default value or throw an exception if the order creation fails
      return -1; // You can choose an appropriate default value or handle the failure accordingly
    }
  }

//get product by productId
  static Future<Order> getOrder(int orderId) async {
    final apiUrl =
        'http://pets4life.fptu.meu-solutions.com/api/Order/$orderId'; // Replace with your API URL

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final dynamic orderJson = jsonDecode(response.body);

        // Map the JSON object to a User object and return it
        return Order.fromJson(orderJson);
      } else {
        // If the request fails, throw an exception or return null
        throw Exception(
            'Failed to fetch order by order id. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      throw Exception('An error occurred: $e');
    }
  }

  //get order by userId
  static Future<List<Order>> getOrderByUser(int userId) async {
    final apiUrl =
        'http://pets4life.fptu.meu-solutions.com/api/Order/byUser/$userId'; // Replace with your API URL

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final List<dynamic> orderListJson = jsonDecode(response.body);

        // Map each JSON object to a Pet object and return a list of pets
        return orderListJson.map((json) => Order.fromJson(json)).toList();
      } else {
        // If the request fails, throw an exception or return an empty list
        throw Exception(
            'Failed to fetch order by user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      throw Exception('An error occurred: $e');
    }
  }

  //create orderDetailByOrderID
  static Future<void> createOrderDetail(
      {required OrderDetail? orderDetail}) async {
    final orderDetailData = {
      "orderId": orderDetail!.orderId,
      "productId": orderDetail.productId,
      "serviceId": orderDetail.serviceId,
    };

    final jsonData = jsonEncode(orderDetailData);

    // Print the JSON data before making the API call
    print('JSON Data: $jsonData');

    final response = await http.post(
      Uri.parse('http://pets4life.fptu.meu-solutions.com/api/OrderDetail'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 201) {
      print('OrderDetail Created successful');
      // Parse the JSON response
      final jsonResponse = jsonDecode(response.body);

      // Extract and return the orderID from the jsonResponse
    } else {
      print('OrderDetail Created failed');
      // Print the JSON data before making the API call
      print('JSON Data: $jsonData');
      // Return a default value or throw an exception if the order creation fails
    }
  }

  //get order by userId
  static Future<List<OrderDetail>> getOrderDetailByOrder(int? orderId) async {
    final apiUrl =
        'http://pets4life.fptu.meu-solutions.com/api/OrderDetail/byOrder/$orderId'; // Replace with your API URL

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final List<dynamic> orderDetailListJson = jsonDecode(response.body);

        // Map each JSON object to a Pet object and return a list of pets
        return orderDetailListJson
            .map((json) => OrderDetail.fromJson(json))
            .toList();
      } else {
        // If the request fails, throw an exception or return an empty list
        throw Exception(
            'Failed to fetch order detail by order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      throw Exception('An error occurred: $e');
    }
  }

  //get appointment by userId
  static Future<List<Appointment>> getAppointmentByUser(int userId) async {
    final apiUrl =
        'http://pets4life.fptu.meu-solutions.com/api/Appoinment/byUser/$userId'; // Replace with your API URL

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final List<dynamic> appointmentListJson = jsonDecode(response.body);

        // Map each JSON object to a Pet object and return a list of pets
        return appointmentListJson
            .map((json) => Appointment.fromJson(json))
            .toList();
      } else {
        // If the request fails, throw an exception or return an empty list
        throw Exception(
            'Failed to fetch appointment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      throw Exception('An error occurred: $e');
    }
  }

  //get appointment by userId
  static Future<List<Appointment>> getAppointmentByPet(int petId) async {
    final apiUrl =
        'http://pets4life.fptu.meu-solutions.com/api/Appoinment/byPet/$petId'; // Replace with your API URL

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final List<dynamic> appointmentListJson = jsonDecode(response.body);

        // Map each JSON object to a Pet object and return a list of pets
        return appointmentListJson
            .map((json) => Appointment.fromJson(json))
            .toList();
      } else {
        // If the request fails, throw an exception or return an empty list
        throw Exception(
            'Failed to fetch appointment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      throw Exception('An error occurred: $e');
    }
  }
}
