import 'package:flutter/foundation.dart';
import 'package:timetablegenerating/service/database_helper.dart';

class StaffViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> _staffList = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Map<String, dynamic>> get staffList => _staffList;

  // Fetch staff from the database
  Future<void> fetchStaff() async {
    _staffList = await _databaseHelper.getStaff();
    notifyListeners();
  }

  // Add staff to the database
  Future<void> addStaff(String name) async {
    await _databaseHelper.addStaff(name);
    await fetchStaff(); // Refresh the staff list
  }

  // Delete staff from the database
  Future<void> deleteStaff(int id) async {
    await _databaseHelper.deleteStaff(id);
    await fetchStaff(); // Refresh the staff list
  }
}
