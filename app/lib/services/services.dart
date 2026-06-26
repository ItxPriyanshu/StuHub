import 'dart:convert';

import 'package:http/http.dart' as http;

class Services {
  static const String baseUrl = "http://10.0.2.2:5000/api";
  // static const String baseUrl = "http://localhost:5000/api";



  //profile API
  Future<Map<String,dynamic>> getProfile(String token) async{
    final response = await http.get(Uri.parse("$baseUrl/user/profile"),
    headers: {"Authorization":"Bearer $token"},
    );

    final data = jsonDecode(response.body);

    if(response.statusCode == 200){
      return data;
    }
    throw Exception(data["message"]);
  }
}