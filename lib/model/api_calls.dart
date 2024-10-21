import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

final ApiService apiService = ApiService(baseUrl: 'http://13.50.58.181:8085');

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> login(String username, String password) async {
    String apiUrl = '$baseUrl/user/login';

    Map<String, dynamic> data = {
      'username': username,
      'password': password,
    };

    String requestBody = jsonEncode(data);

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': response.statusCode,
          'errorMsg': jsonDecode(response.body)['errorMsg'] ?? 'Unknown error'
        };
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  //verify otp
  Future<Map<String, dynamic>> verifyOtp(String otp, String userId) async {
    String apiUrl = "$baseUrl/user/verify-otp";

    Map<String, dynamic> data = {
      "otp": otp,
      "userId": userId,
    };

    String requestBody = jsonEncode(data);

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to verify OTP');
    }
  }

  //sign up api

  Future<Map<String, dynamic>> registerUser(
      String firstName,
      String lastName,
      String middleName,
      String email,
      String password,
      String phoneNo,
      String country,
      String countryCode,
      String companyName) async {            //added companyname
    String apiUrl = "$baseUrl/user/signup";

    Map<String, dynamic> data = {
      "firstName": firstName,
      "lastName": lastName,
      "middleName": middleName,
      "email": email,
      "password": password,
      "phoneNo": phoneNo,
      "country": country,
      "countryCode": countryCode,
      "companyNmae" : companyName   //added to get company name
    };

    String requestBody = jsonEncode(data);

    print("requestBody $requestBody");

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }

  //forgot api

  Future<Map<String, dynamic>> forgotPassword(
      String userId, bool isMobile) async {
    String apiUrl = '$baseUrl/user/forgotpassword';

    Map<String, dynamic> data = {
      'userId': userId,
      'isMobile': isMobile.toString(),
    };

    String requestBody = jsonEncode(data);

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': response.statusCode,
          'errorMsg': jsonDecode(response.body)['errorMsg'] ?? 'Unknown error'
        };
      }
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  //reset password

  Future<Map<String, dynamic>> resetPassword(
      String userId, String otp, String newPassword) async {
    String apiUrl = '$baseUrl/user/resetpassword';

    Map<String, dynamic> data = {
      'userId': userId,
      'otpForVerification': otp,
      'password': newPassword,
    };

    String requestBody = jsonEncode(data);

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': response.statusCode,
          'errorMsg': jsonDecode(response.body)['errorMsg'] ?? 'Unknown error'
        };
      }
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

//socialRegister

  Future<Map<String, dynamic>> socialRegister(
      String firstName, String lastName, String email, String provider) async {
    String apiUrl = "$baseUrl/user/socialregister";

    Map<String, dynamic> data = {
      "firstName": firstName,
      "lastName": lastName,
      "middleName": lastName,
      "email": email,
      "password": "",
      "provider": provider,
      "phoneNo": "",
      "country": "",
      "countryCode": "",
    };

    String requestBody = jsonEncode(data);

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBody,
    );

    print("requestBody $requestBody");

    print("response $response");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 500) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }

  //resend otp
  Future<Map<String, dynamic>> resendotp(String userId, bool isMobile) async {
    String apiUrl = '$baseUrl/user/forgotpassword';

    Map<String, dynamic> data = {
      'userId': userId,
      'isMobile': isMobile.toString(),
    };

    String requestBody = jsonEncode(data);

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': response.statusCode,
          'errorMsg': jsonDecode(response.body)['errorMsg'] ?? 'Unknown error'
        };
      }
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  //google login

  Future<Map<String, dynamic>> loginWithSocial(
      String idToken, String provider) async {
    String apiUrl = '$baseUrl/user/sociallogin';
    String platformName = Platform.isIOS ? "IOS" : "ANDROID";

    Map<String, dynamic> data = {
      'idToken': idToken,
      'provider': provider,
      'platform': platformName,
    };

    String requestBody = jsonEncode(data);

    print("requestBody, $requestBody");

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': response.statusCode,
          'errorMsg': jsonDecode(response.body)['errorMsg'] ?? 'Unknown error'
        };
      }
    } catch (e) {
      throw Exception('Failed to login with social account: $e');
    }
  }

//get user events
  Future<Map<String, dynamic>> getMyEvents(
      String userId, String authToken) async {
    String apiUrl = '$baseUrl/event/getEvents?userId=$userId';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        return {
          'status': response.statusCode,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'status': response.statusCode,
          'data': {},
        };
      }
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }

  Future<Map<String, dynamic>> refreshToken(String authToken) async {
    String apiUrl = '$baseUrl/user/refreshToken';

    Map<String, dynamic> data = {
      'token': authToken,
    };

    String requestBody = jsonEncode(data);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        return {
          'status': response.statusCode,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'status': response.statusCode,
          'data': {},
        };
      }
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }

// getting event type in drop down
  Future<Map<String, dynamic>> getEventTypes(String authToken) async {
    String apiUrl = '$baseUrl/event/eventtype';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        return {
          'status': response.statusCode,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'status': response.statusCode,
          'data': {},
        };
      }
    } catch (e) {
      throw Exception('Failed to load event types: $e');
    }
  }

//create event
  Future<Map<String, dynamic>> createEvent(
      Map<String, dynamic> eventData, String authToken) async {
    String apiUrl = '$baseUrl/event/createEvent';

    String requestBody = jsonEncode(eventData);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        return {
          'status': response.statusCode,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'status': response.statusCode,
          'data': jsonDecode(response.body),
        };
      }
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

//upload images to server
  Future<Map<String, dynamic>> uploadImage(
      List<File> images, String authToken) async {
    var uri = Uri.parse('$baseUrl/media/upload');
    var request = http.MultipartRequest('POST', uri);

    // Determine the mime type of the file
    for (var image in images) {
      var mimeType = lookupMimeType(image.path);
      var mimeTypeData =
          mimeType != null ? mimeType.split('/') : ['image', 'jpeg'];

      request.files.add(await http.MultipartFile.fromPath(
        'file', // Ensure this matches the server's expected part name
        image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ));
    }

    // Add the authorization header
    request.headers['Authorization'] = 'Bearer $authToken';

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return {
          'status': response.statusCode,
          'data': jsonDecode(responseBody),
        };
      } else {
        return {
          'status': response.statusCode,
          'data': jsonDecode(responseBody),
        };
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

//getting the respounce who can come
  Future<Map<String, dynamic>> getEventDetails(
      String eventId, String authToken) async {
    var uri = Uri.parse(
        'http://13.50.58.181:8085/event/getEventDetails?eventId=$eventId');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return {
        'status': response.statusCode,
        'data': jsonDecode(response.body),
      };
    } else if (response.statusCode == 204) {
      return {
        'status': response.statusCode,
        'data': null,
      };
    } else {
      throw Exception('Failed to load event details');
    }
  }

//event cancle
  Future<Map<String, dynamic>> CancleEvent(
      String userId, String eventId, String eventDate, String authToken) async {
    String apiUrl = "$baseUrl/event/updateEvent";

    Map<String, dynamic> data = {
      "userId": userId,
      "id": eventId,
      "eventDate": eventDate,
      "eventStatus": "CANCELLED",
    };

    String requestBody = jsonEncode(data);

    var response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update event');
    }
  }

//update the event
  Future<Map<String, dynamic>> updateEvent(
      String userId,
      String eventId,
      String eventDate,
      String location,
      String eventStatus,
      String authToken) async {
    String apiUrl = "$baseUrl/event/updateEvent";

    Map<String, dynamic> eventData = {
      'id': eventId,
      "userId": userId,
      "eventDate": eventDate,
      "location": location,
      "eventStatus": eventStatus,
    };

    String jsonData = jsonEncode(eventData);

    print("Updated JSON Data: $jsonData");

    var response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonData,
    );

    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update event');
    }
  }

  //update mobile number

  Future<Map<String, dynamic>> updatePhoneNumber({
    required String? authToken,
    required String? userId,
    required String phoneNo,
    required String countryCode,
    required String country,
  }) async {
    String apiUrl = "$baseUrl/profile/updatephone";

    Map<String, dynamic> data = {
      "userId": userId,
      "phoneNo": phoneNo,
      "countryCode": countryCode,
      "country": country,
    };

    String requestBody = jsonEncode(data);

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update phone number');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
