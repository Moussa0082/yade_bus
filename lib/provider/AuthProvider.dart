import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/models/user.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> login(String username, String password) async {
    final url = Uri.parse(
        '$apiUrl/agent_login.php?username=$username&password=$password');

    final response = await http.get(url);

    final data = jsonDecode(response.body);

    if (data['agent'] != null) {
      _user = UserModel.fromJson(data['agent']);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user', jsonEncode(_user!.toJson()));
      notifyListeners();
    } else {
      throw Exception(data['message'] ?? "Erreur de connexion");
    }
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');

    if (userData != null) {
      
      debugPrint("User ${userData.toString()}");
      _user = UserModel.fromJson(jsonDecode(userData));
      notifyListeners();
    }else{
      debugPrint("User null ${userData.toString()}");
    }
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    notifyListeners();
  }
}
