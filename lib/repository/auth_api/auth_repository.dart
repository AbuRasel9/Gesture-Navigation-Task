import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class AuthRepository {
   Future<String> login(String username, String password) ;

   Future<UserProfile> getUser(int id);




}