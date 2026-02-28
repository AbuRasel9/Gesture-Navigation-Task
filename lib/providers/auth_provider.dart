import 'package:flutter/foundation.dart';
import 'package:gesture_coordination_task/repository/auth_api/auth_repository.dart';
import 'package:gesture_coordination_task/repository/auth_api/auth_repository_impl.dart';
import '../model/user/user_model.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  UserProfile? _user;
  bool _loading = false;
  String? _error;

  String? get token => _token;
  UserProfile? get user => _user;
  bool get loading => _loading;
  String? get error => _error;
  bool get isLoggedIn => _token != null;

  Future<bool> login(String username, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _token = await AuthRepositoryImpl().login(username, password);
      _user = await AuthRepositoryImpl().getUser(1);
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _token = null;
    _user = null;
    notifyListeners();
  }
}
