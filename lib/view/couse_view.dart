import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:timetablegenerating/viewmodel/cousre_viewmodel.dart';
import 'package:timetablegenerating/widgets/custom_snackbar.dart';
import 'package:timetablegenerating/widgets/custom_button.dart';
import 'package:timetablegenerating/constants/app_typography.dart';

class AddCourseView extends StatelessWidget {
  final TextEditingController _courseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final courseViewModel = Provider.of<CourseViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Course', style: AppTypography.outfitboldmainHead),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _courseController,
              decoration: InputDecoration(
                labelText: 'Course Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 12),
            CustomButton(
              buttonName: 'Add Course',
              onTap: () async {
                if (_courseController.text.isNotEmpty) {
                  await courseViewModel.addCourse(_courseController.text);

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
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<CourseViewModel>(
                builder: (context, model, child) {
                  return ListView.builder(
                    itemCount: model.courses.length,
                    itemBuilder: (context, index) {
                      final course = model.courses[index];
                      return ListTile(
                        title: Text(
                          course['name'],
                          style: AppTypography.outfitRegular,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () =>
                              _showDeleteDialog(context, course['id'], model),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, int courseId, CourseViewModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title:
                const Text('Delete Course', style: AppTypography.outfitboldmainHead),
            content: const Text('Are you sure you want to delete this course?'),
            actions: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () async {
                    await model.deleteCourse(courseId);
                    CustomSnackBar.show(
                      context,
                      snackBarType: SnackBarType.success,
                      label: 'Course deleted successfully!',
                      bgColor: Colors.green,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes', style: TextStyle(color: Colors.white)),
                ),
              ]),
            ]);
      },
    );
  }
}
