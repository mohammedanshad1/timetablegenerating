import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:timetablegenerating/widgets/custom_snackbar.dart';
import 'package:timetablegenerating/widgets/custom_button.dart';
import 'package:timetablegenerating/constants/app_typography.dart';

class AddCourseView extends StatelessWidget {
  final TextEditingController _courseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course', style: AppTypography.outfitboldmainHead),
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
                  // Simulate adding the course
                  CustomSnackBar.show(
                    context,
                    snackBarType: SnackBarType.success,
                    label: 'Course "${_courseController.text}" added successfully!',
                    bgColor: Colors.green,
                  );
                  _courseController.clear();
                }
              },
              buttonColor: Theme.of(context).primaryColor,
              height: 50,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
