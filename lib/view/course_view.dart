import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetablegenerating/view/subject_view.dart';
import 'package:timetablegenerating/viewmodel/cousre_viewmodel.dart';

class CoursePage extends StatelessWidget {
  final TextEditingController _courseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final courseViewModel = Provider.of<CourseViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Courses')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _courseController,
              decoration: InputDecoration(labelText: 'Course Name'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_courseController.text.isNotEmpty) {
                courseViewModel.addCourse(_courseController.text);
                _courseController.clear();
              }
            },
            child: Text('Add Course'),
          ),
          Expanded(
            child: FutureBuilder(
              future: courseViewModel.fetchCourses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return ListView.builder(
                  itemCount: courseViewModel.courses.length,
                  itemBuilder: (context, index) {
                    final course = courseViewModel.courses[index];
                    return ListTile(
                      title: Text(course['name']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubjectPage(courseId: course['id']),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
