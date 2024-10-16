import 'package:flutter/material.dart';
import 'package:timetablegenerating/service/database_helper.dart';

class StaffViewModel extends ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _staff = [];

  List<Map<String, dynamic>> get staff => _staff;

  Future<void> fetchStaff() async {
    _staff = await dbHelper.getStaff();
    notifyListeners();
  }

  Future<void> addStaff(String name) async {
    await dbHelper.addStaff(name);
    await fetchStaff();
  }
}
