import 'package:flutter/material.dart';
import 'package:timetablegenerating/constants/app_typography.dart';
import 'package:timetablegenerating/service/database_helper.dart';

import 'package:timetablegenerating/utils/responsive.dart'; // Assuming you have Responsive helper here

class AutomaticTimetableGenerator extends StatefulWidget {
  @override
  _AutomaticTimetableGeneratorState createState() =>
      _AutomaticTimetableGeneratorState();
}

class _AutomaticTimetableGeneratorState
    extends State<AutomaticTimetableGenerator> {
  final DatabaseHelper _db = DatabaseHelper();
  List<Map<String, dynamic>> courses = [];
  Map<int, List<Map<String, dynamic>>> subjectsMap = {};
  List<Map<String, dynamic>> staffAssignments = [];
  List<Map<String, dynamic>> days = [];
  Map<int, List<Map<String, dynamic>>> generatedTimetable = {};
  bool isLoading = true;
  int? selectedCourseId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      courses = await _db.getCourses();
      days = await _db.getDays();
      staffAssignments = await _db.getStaffAssignments();
      for (var course in courses) {
        subjectsMap[course['id']] = await _db.getSubjects(course['id']);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _generateTimetable(int courseId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final subjects = subjectsMap[courseId] ?? [];
      final Map<int, List<Map<String, dynamic>>> newTimetable = {};
      final timeSlots = [
        {'start': '9:00', 'end': '10:00'},
        {'start': '10:00', 'end': '11:00'},
        {'start': '11:15', 'end': '12:15'},
        {'start': '12:15', 'end': '1:15'},
        {'start': '2:00', 'end': '3:00'},
        {'start': '3:00', 'end': '4:00'},
      ];

      for (var day in days) {
        List<Map<String, dynamic>> dayPeriods = [];
        List<int> availableSubjects =
            subjects.map<int>((s) => s['id'] as int).toList();

        for (int periodIndex = 0;
            periodIndex < timeSlots.length;
            periodIndex++) {
          if (availableSubjects.isEmpty) {
            availableSubjects =
                subjects.map<int>((s) => s['id'] as int).toList();
          }
          availableSubjects.shuffle();
          final subjectId = availableSubjects.removeAt(0);

          final staffAssignment = staffAssignments.firstWhere(
            (sa) => sa['subjectId'] == subjectId,
            orElse: () => {'staffId': null},
          );

          final period = {
            'dayId': day['id'],
            'periodNumber': periodIndex + 1,
            'startTime': timeSlots[periodIndex]['start'],
            'endTime': timeSlots[periodIndex]['end'],
            'subjectId': subjectId,
            'staffId': staffAssignment['staffId'],
          };

          await _db.addPeriod(
            dayId: day['id'],
            periodNumber: periodIndex + 1,
            startTime: timeSlots[periodIndex]['start']!,
            endTime: timeSlots[periodIndex]['end']!,
            subjectId: subjectId,
          );

          dayPeriods.add(period);
        }

        newTimetable[day['id']] = dayPeriods;
      }

      setState(() {
        generatedTimetable = newTimetable;
        selectedCourseId = courseId;
        isLoading = false;
      });
    } catch (e) {
      print('Error generating timetable: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating timetable')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable Generator',
            style: AppTypography.outfitboldmainHead),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(responsive.wp(4)),
              child: Column(
                children: [
                  _buildCourseDropdown(responsive),
                  if (selectedCourseId != null) _buildTimetableView(responsive),
                ],
              ),
            ),
    );
  }

  Widget _buildCourseDropdown(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: 'Select Course',
          labelStyle: AppTypography.outfitRegular,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: responsive.wp(4)),
        ),
        value: selectedCourseId,
        items: courses.map((course) {
          return DropdownMenuItem<int>(
            value: course['id'],
            child: Text(course['name'], style: AppTypography.outfitRegular),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            _generateTimetable(value);
          }
        },
      ),
    );
  }

  Widget _buildTimetableView(Responsive responsive) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimetableHeader(responsive),
              ..._buildPeriodRows(responsive),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimetableHeader(Responsive responsive) {
    return Row(
      children: [
        _buildHeaderCell('Time', responsive),
        ...days
            .map((day) => _buildHeaderCell(day['name'], responsive))
            .toList(),
      ],
    );
  }

  Widget _buildHeaderCell(String text, Responsive responsive) {
    return Container(
      width: responsive.wp(20),
      padding: EdgeInsets.all(responsive.wp(2)),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey),
      ),
      child: Text(text, style: AppTypography.outfitBold),
    );
  }

  List<Widget> _buildPeriodRows(Responsive responsive) {
    return List.generate(6, (periodIndex) {
      return Row(
        children: [
          _buildTimeCell('${periodIndex + 1}', responsive),
          ...days.map((day) {
            final periods = generatedTimetable[day['id']] ?? [];
            final period = periods.firstWhere(
              (p) => p['periodNumber'] == periodIndex + 1,
              orElse: () => {},
            );
            return _buildPeriodCell(period, responsive);
          }).toList(),
        ],
      );
    });
  }

  Widget _buildTimeCell(String time, Responsive responsive) {
    return Container(
      width: responsive.wp(20),
      padding: EdgeInsets.all(responsive.wp(2)),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey),
      ),
      child: Center(child: Text(time, style: AppTypography.outfitRegular)),
    );
  }

  Widget _buildPeriodCell(Map<String, dynamic> period, Responsive responsive) {
    return Container(
      width: responsive.wp(20),
      height: responsive.hp(10),
      padding: EdgeInsets.all(responsive.wp(2)),
      decoration: BoxDecoration(
        color: period.isEmpty ? Colors.white : Colors.blue[50],
        border: Border.all(color: Colors.grey),
      ),
      child: period.isEmpty
          ? Center(child: Text('No Class', style: AppTypography.outfitLight))
          : FutureBuilder<String>(
              future: _getSubjectName(period['subjectId']),
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data ?? 'Loading...',
                      style: AppTypography.outfitBold,
                    ),
                    Text('${period['startTime']} - ${period['endTime']}',
                        style: AppTypography.outfitRegular),
                  ],
                );
              },
            ),
    );
  }

  Future<String> _getSubjectName(int subjectId) async {
    final subjects = subjectsMap[selectedCourseId!] ?? [];
    final subject = subjects.firstWhere(
      (s) => s['id'] == subjectId,
      orElse: () => {'name': 'Unknown'},
    );
    return subject['name'];
  }
}
