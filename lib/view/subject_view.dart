import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:timetablegenerating/viewmodel/subject_viewmodel.dart';
import 'package:timetablegenerating/widgets/custom_snackbar.dart';
import 'package:timetablegenerating/widgets/custom_button.dart';
import 'package:timetablegenerating/constants/app_typography.dart';

class SubjectPage extends StatelessWidget {
  final int courseId;
  final TextEditingController _subjectController = TextEditingController();

  SubjectPage({required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects', style: AppTypography.outfitboldmainHead),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Subject Name Text Field
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Subject Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 12),
            // Custom Button for Adding Subject
            CustomButton(
              buttonName: 'Add Subject',
              onTap: () {
                if (_subjectController.text.isNotEmpty) {
                  Provider.of<SubjectViewModel>(context, listen: false)
                      .addSubject(_subjectController.text, courseId);
                  CustomSnackBar.show(
                    context,
                    snackBarType: SnackBarType.success,
                    label:
                        'Subject "${_subjectController.text}" added successfully!',
                    bgColor: Colors.green,
                  );
                  _subjectController.clear();
                }
              },
              buttonColor: Theme.of(context).primaryColor,
              height: 50,
              width: double.infinity,
            ),
            SizedBox(height: 20),
            // Subjects List
            Expanded(
              child: Consumer<SubjectViewModel>(
                builder: (context, subjectViewModel, child) {
                  if (subjectViewModel.subjects.isEmpty) {
                    return Center(child: Text('No subjects available.'));
                  } else {
                    return ListView.builder(
                      itemCount: subjectViewModel.subjects.length,
                      itemBuilder: (context, index) {
                        final subject = subjectViewModel.subjects[index];
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(subject['name'],
                                style: AppTypography.outfitRegular),
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
