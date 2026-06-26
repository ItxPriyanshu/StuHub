import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stuhub/storage/token_storage.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2:5000/api";
  // static const String baseUrl = "http://localhost:5000/api";




///REGISTER API
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );
    final data = jsonDecode(response.body);

    if(response.statusCode == 201){
      return data;
    }
    throw Exception(
      data["message"],
    );
  }


  //LOGIN API
  Future<Map<String,dynamic>> login({required String email, required String password})async{
    final response = await http.post(Uri.parse("$baseUrl/auth/login"),
    headers: {'Content-Type':'application/json'},
    body: jsonEncode({'email':email, 'password':password}),
    );

    final data =jsonDecode(response.body);

    if(response.statusCode == 200){
      return data;
    }
    throw Exception(data["message"]);
  }


  Future<void> updateProfile({
  required String name,
  required String email,
}) async {

  final token =
      await TokenStorage.getToken();

  final response =
      await http.put(
    Uri.parse(
      "$baseUrl/user/profile",
    ),

    headers: {
      "Content-Type":
          "application/json",

      "Authorization":
          "Bearer $token",
    },

    body: jsonEncode({
      "name": name,
      "email": email,
    }),
  );

  if (response.statusCode != 200) {
    final data =
        jsonDecode(response.body);

    throw Exception(
      data["message"] ??
      "Failed to update profile",
    );
  }
}
}
