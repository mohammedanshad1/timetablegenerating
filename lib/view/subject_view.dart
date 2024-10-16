import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetablegenerating/viewmodel/subject_viewmodel.dart';

class SubjectPage extends StatelessWidget {
  final int courseId;
  final TextEditingController _subjectController = TextEditingController();

  SubjectPage({required this.courseId});

  @override
  Widget build(BuildContext context) {
    final subjectViewModel = Provider.of<SubjectViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Subjects')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject Name'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_subjectController.text.isNotEmpty) {
                subjectViewModel.addSubject(_subjectController.text, courseId);
                _subjectController.clear();
              }
            },
            child: Text('Add Subject'),
          ),
          Expanded(
            child: FutureBuilder(
              future: subjectViewModel.fetchSubjects(courseId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return ListView.builder(
                  itemCount: subjectViewModel.subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjectViewModel.subjects[index];
                    return ListTile(title: Text(subject['name']));
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
