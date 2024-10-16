import 'package:flutter/material.dart';
import 'package:timetablegenerating/service/database_helper.dart';

class DayViewModel extends ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _days = [];

  List<Map<String, dynamic>> get days => _days;

  Future<void> fetchDays() async {
    _days = await dbHelper.getDays();
    notifyListeners();
  }
}
