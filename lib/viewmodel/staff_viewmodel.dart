import 'package:flutter/foundation.dart';
import 'package:timetablegenerating/service/database_helper.dart';

class StaffViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> _staffList = [];
  List<Map<String, dynamic>> _courseList = [];
  List<Map<String, dynamic>> _subjectList = []; // Store subjects here
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Map<String, dynamic>> get staffList => _staffList;
  List<Map<String, dynamic>> get courseList => _courseList;
  List<Map<String, dynamic>> get subjectList => _subjectList; // Expose subjects

  int? _selectedCourseId; // Store the selected course ID

  int? get selectedCourseId => _selectedCourseId;

  Future<void> fetchStaff() async {
    _staffList = await _databaseHelper.getStaff();
    notifyListeners();
  }

  Future<void> addStaff(String name) async {
    await _databaseHelper.addStaff(name);
    await fetchStaff();
  }

  Future<void> deleteStaff(int id) async {
    await _databaseHelper.deleteStaff(id);
    await fetchStaff();
  }

  Future<void> fetchCourses() async {
    _courseList = await _databaseHelper.getCourses();
    notifyListeners();
  }

  Future<void> fetchSubjectsForCourses(List<int> courseIds) async {
    // Use a set to ensure unique subjects
    final Set<Map<String, dynamic>> subjectSet = {};

    // Clear the current subject list
    _subjectList = [];

    if (courseIds.isEmpty || courseIds.contains(0)) {
      // If "All" is selected or no course IDs are provided, fetch all subjects
      final allSubjects = await _databaseHelper.getAllSubjects();
      subjectSet.addAll(allSubjects); // Add all subjects to the set
    } else {
      // Fetch subjects only for the selected course IDs
      for (var courseId in courseIds) {
        final subjects = await _databaseHelper.getSubjects(courseId);
        subjectSet.addAll(subjects); // Add each course's subjects to the set
      }
    }

    // Convert the set back to a list
    _subjectList = subjectSet.toList();

    notifyListeners(); // Notify listeners after updating the subject list
  }

  void selectCourse(int courseId) {
    _selectedCourseId = courseId;
    if (courseId == 0) {
      // "All" option (assuming 0 is used for "All")
      fetchAllSubjects();
    } else {
      fetchSubjectsForCourses(
          [courseId]); // Fetch subjects for the selected course
    }
    notifyListeners();
  }

  Future<void> fetchAllSubjects() async {
    _subjectList = []; // Clear previous subjects
    // Fetch all subjects from the database
    final allSubjects = await _databaseHelper.getAllSubjects();
    _subjectList.addAll(allSubjects);
    notifyListeners();
  }
}
