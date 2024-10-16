import 'package:flutter/material.dart';
import 'package:timetablegenerating/service/database_helper.dart';

class SubjectViewModel extends ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _subjects = [];

  List<Map<String, dynamic>> get subjects => _subjects;

  Future<void> fetchSubjects(int courseId) async {
    _subjects = await dbHelper.getSubjects(courseId);
    notifyListeners();
  }

  Future<void> addSubject(String name, int courseId) async {
    await dbHelper.addSubject(name, courseId);
    await fetchSubjects(courseId);
  }
}
