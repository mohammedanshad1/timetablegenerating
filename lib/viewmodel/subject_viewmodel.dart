import 'package:flutter/material.dart';
import 'package:timetablegenerating/service/database_helper.dart';

class SubjectViewModel extends ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _subjects = [];

  List<Map<String, dynamic>> get subjects => _subjects;
  List<Map<String, dynamic>> _courses = []; // Add this line

  List<Map<String, dynamic>> get courses => _courses; // Add this line

  Future<void> fetchCourses() async {
    _courses = await dbHelper.getCourses(); // Access instance method
    notifyListeners();
  }

  Future<void> fetchSubjects(int courseId) async {
    _subjects = await dbHelper.getSubjects(courseId);
    notifyListeners();
  }

  Future<void> addSubject(String name, int courseId) async {
    await dbHelper.addSubject(name, courseId);
    await fetchSubjects(courseId);
    print(name);
  }

  List<Map<String, dynamic>> getSubjectsForCourse(int courseId) {
    // Filter the subjects based on the courseId
    return _subjects
        .where((subject) => subject['courseId'] == courseId)
        .toList();
  }

  Future<void> deleteSubject(int id, int courseId) async {
    await dbHelper.deleteSubject(id);
    await fetchSubjects(courseId); // Refresh the subjects list after deletion
  }

  List<String> getCoursesForSubject(int courseId) {
    // Implement logic to retrieve course names based on courseId.
    // This is just a placeholder example.
    return subjects
        .where((subject) => subject['courseId'] == courseId)
        .map((subject) => subject['name'] as String)
        .toList();
  }

  Future<void> fetchAllSubjects() async {
  _subjects = await dbHelper.getAllSubjects();
  notifyListeners();
}

}
