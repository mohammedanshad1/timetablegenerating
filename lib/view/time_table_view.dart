import 'package:flutter/material.dart';
import 'package:timetablegenerating/constants/app_typography.dart';
import 'package:timetablegenerating/service/database_helper.dart';

class TimetableGenerator extends StatefulWidget {
  @override
  _TimetableGeneratorState createState() => _TimetableGeneratorState();
}

class _TimetableGeneratorState extends State<TimetableGenerator> {
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
      // Load all necessary data
      courses = await _db.getCourses();
      days = await _db.getDays();
      staffAssignments = await _db.getStaffAssignments();

      // Load subjects for each course
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

      // Define time slots
      final timeSlots = [
        {'start': '9:00', 'end': '10:00'},
        {'start': '10:00', 'end': '11:00'},
        {'start': '11:15', 'end': '12:15'},
        {'start': '12:15', 'end': '1:15'},
        {'start': '2:00', 'end': '3:00'},
        {'start': '3:00', 'end': '4:00'},
      ];

      // Generate timetable for each day
      for (var day in days) {
        List<Map<String, dynamic>> dayPeriods = [];
        List<int> availableSubjects =
            subjects.map<int>((s) => s['id'] as int).toList();

        // For each time slot
        for (int periodIndex = 0;
            periodIndex < timeSlots.length;
            periodIndex++) {
          if (availableSubjects.isEmpty) {
            availableSubjects =
                subjects.map<int>((s) => s['id'] as int).toList();
          }

          // Randomly select a subject
          availableSubjects.shuffle();
          final subjectId = availableSubjects.removeAt(0);

          // Find staff assignment for this subject
          final staffAssignment = staffAssignments.firstWhere(
            (sa) => sa['subjectId'] == subjectId,
            orElse: () => {'staffId': null},
          );

          // Create period entry
          final period = {
            'dayId': day['id'],
            'periodNumber': periodIndex + 1,
            'startTime': timeSlots[periodIndex]['start'],
            'endTime': timeSlots[periodIndex]['end'],
            'subjectId': subjectId,
            'staffId': staffAssignment['staffId'],
          };

          // Save to database
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
        const SnackBar(content: Text('Error generating timetable')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Automatic Timetable Generator',
          style: AppTypography.outfitboldmainHead,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          hint: const Text(
                            'Select Course',
                            style: AppTypography.outfitRegular,
                          ),
                          value: selectedCourseId,
                          items: courses.map((course) {
                            return DropdownMenuItem<int>(
                              value: course['id'],
                              child: Text(
                                course['name'],
                                style: AppTypography.outfitRegular,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              _generateTimetable(value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: selectedCourseId == null
                      ? const Center(
                          child: Text(
                            'Select a course to generate timetable',
                            style: AppTypography.outfitRegular,
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header Row
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.grey[200],
                                      ),
                                      child: const Text(
                                        'Time',
                                        style: AppTypography.outfitBold,
                                      ),
                                    ),
                                    ...days.map((day) => Container(
                                          width: 200,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.grey[200],
                                          ),
                                          child: Text(
                                            day['name'],
                                            style: AppTypography.outfitBold,
                                          ),
                                        )),
                                  ],
                                ),
                                // Periods
                                ...List.generate(6, (periodIndex) {
                                  return Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          color: Colors.grey[100],
                                        ),
                                        child: Text(
                                          '${periodIndex + 1}',
                                          style: AppTypography.outfitRegular,
                                        ),
                                      ),
                                      ...days.map((day) {
                                        final periods =
                                            generatedTimetable[day['id']] ?? [];
                                        final period = periods.firstWhere(
                                          (p) =>
                                              p['periodNumber'] ==
                                              periodIndex + 1,
                                          orElse: () => {},
                                        );

                                        return Container(
                                          width: 200,
                                          height: 80,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: period.isEmpty
                                                ? Colors.white
                                                : Colors.blue[50],
                                          ),
                                          child: period.isEmpty
                                              ? const Center(
                                                  child: Text(
                                                    'No Class',
                                                    style: AppTypography
                                                        .outfitRegular,
                                                  ),
                                                )
                                              : FutureBuilder<String>(
                                                  future: _getSubjectName(
                                                      period['subjectId']),
                                                  builder: (context, snapshot) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          snapshot.data ??
                                                              'Loading...',
                                                          style: AppTypography
                                                              .outfitBold,
                                                        ),
                                                        Text(
                                                          '${period['startTime']} - ${period['endTime']}',
                                                          style: AppTypography
                                                              .outfitRegular,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                        );
                                      }),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
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
