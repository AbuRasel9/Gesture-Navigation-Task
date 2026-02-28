import 'dart:convert';

import 'package:gesture_coordination_task/configs/app_url.dart';
import 'package:gesture_coordination_task/repository/auth_api/auth_repository.dart';
import 'package:http/http.dart' as http;

import '../../model/user/user_model.dart';

class AuthRepositoryImpl extends AuthRepository{
  @override
  Future<UserProfile> getUser(int id) async {   final res = await http.get(Uri.parse('${AppUrl.base}/users/$id'));
  if (res.statusCode == 200) {
    return UserProfile.fromJson(jsonDecode(res.body));
  }
  throw Exception('Failed to get user');


  }

  @override
  Future<String> login(String username, String password) async {


    try{
      final res = await http.post(
        Uri.parse('${AppUrl.base}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      if (res.statusCode == 200 || res.statusCode==201) {

        final result=jsonDecode(res.body);


        return result['token'];
      }
      throw Exception("${res.body}-");
    }catch(e){
      throw Exception('Login failed: ${e}');

    }


  }
  
}