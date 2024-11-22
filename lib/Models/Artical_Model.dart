import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountModel with ChangeNotifier {
  String _imagePath = '';

  String get imagePath => _imagePath;

  Future<void> updateAccount(
    String imagePath,
  ) async {
    _imagePath = imagePath;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('imagePath', _imagePath);
    notifyListeners();
  }
}
