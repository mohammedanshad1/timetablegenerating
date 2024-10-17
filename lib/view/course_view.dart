import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:timetablegenerating/view/subject_view.dart';
import 'package:timetablegenerating/viewmodel/cousre_viewmodel.dart';
import 'package:timetablegenerating/viewmodel/subject_viewmodel.dart';
import 'package:timetablegenerating/widgets/custom_snackbar.dart';
import 'package:timetablegenerating/widgets/custom_button.dart';
import 'package:timetablegenerating/constants/app_typography.dart';

class CoursePage extends StatelessWidget {
  final TextEditingController _courseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses', style: AppTypography.outfitboldmainHead),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Course Name Text Field
            TextField(
              controller: _courseController,
              decoration: InputDecoration(
                labelText: 'Course Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 12),
            // Custom Button for Adding Course
            CustomButton(
              buttonName: 'Add Course',
              onTap: () {
                if (_courseController.text.isNotEmpty) {
                  Provider.of<CourseViewModel>(context, listen: false)
                      .addCourse(_courseController.text);
                  CustomSnackBar.show(
                    context,
                    snackBarType: SnackBarType.success,
                    label:
                        'Course "${_courseController.text}" added successfully!',
                    bgColor: Colors.green,
                  );
                  _courseController.clear();
                }
              },
              buttonColor: Theme.of(context).primaryColor,
              height: 50,
              width: double.infinity,
            ),
            SizedBox(height: 20),
            // Courses List with Expansion to show Subjects
            Expanded(
              child: Consumer2<CourseViewModel, SubjectViewModel>(
                builder: (context, courseViewModel, subjectViewModel, child) {
                  if (courseViewModel.courses.isEmpty) {
                    return Center(child: Text('No courses available.'));
                  } else {
                    return ListView.builder(
                      itemCount: courseViewModel.courses.length,
                      itemBuilder: (context, index) {
                        final course = courseViewModel.courses[index];
                        final courseId = course['id'];
                        final subjects =
                            subjectViewModel.getSubjectsForCourse(courseId);

                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ExpansionTile(
                            title: Text(
                              course['name'],
                              style: AppTypography.outfitRegular,
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            onExpansionChanged: (expanded) {
                              if (expanded) {
                                // Fetch subjects when tile is expanded
                                subjectViewModel.fetchSubjects(courseId);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SubjectPage(courseId: courseId),
                                  ),
                                );
                              }
                            },
                            children: subjects.isEmpty
                                ? [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          'No subjects available under this course.'),
                                    )
                                  ]
                                : subjects.map((subject) {
                                    return ListTile(
                                      title: Text(subject['name']),
                                    );
                                  }).toList(),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
