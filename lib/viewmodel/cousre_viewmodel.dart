import 'package:flutter/material.dart';
import 'package:timetablegenerating/service/database_helper.dart';

class CourseViewModel extends ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _courses = [];

  List<Map<String, dynamic>> get courses => _courses;

  Future<void> fetchCourses() async {
    _courses = await dbHelper.getCourses();
    notifyListeners();
  }

  Future<void> addCourse(String name) async {
    await dbHelper.addCourse(name);
    await fetchCourses();
  }
}
