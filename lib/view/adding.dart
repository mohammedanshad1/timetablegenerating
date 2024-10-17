import 'package:flutter/material.dart';
import 'package:timetablegenerating/view/couse_view.dart';
import 'package:timetablegenerating/view/staff_view.dart';
import 'package:timetablegenerating/constants/app_typography.dart';
import 'package:timetablegenerating/view/subject_view.dart';

class AddingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Table Generating',
            style: AppTypography.outfitboldmainHead),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Grid View for adding different functionalities
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  // Card for Adding Course
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCourseView(),
                        ),
                      );
                    },
                    child: const Card(
                      elevation: 4,
                      child: Center(
                        child: Text(
                          'Add Course',
                          style: AppTypography.outfitRegular,
                        ),
                      ),
                    ),
                  ),
                  // Card for Subjects
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubjectPage(courseId: 1),
                        ),
                      );
                    },
                    child: const Card(
                      elevation: 4,
                      child: Center(
                        child: Text(
                          'Subjects',
                          style: AppTypography.outfitRegular,
                        ),
                      ),
                    ),
                  ),
                  // Card for Staff
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StaffViewScreen(),
                        ),
                      );
                    },
                    child: const Card(
                      elevation: 4,
                      child: Center(
                        child: Text(
                          'Staff',
                          style: AppTypography.outfitRegular,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
