import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:timetablegenerating/widgets/custom_snackbar.dart';
import 'package:timetablegenerating/widgets/custom_button.dart';
import 'package:timetablegenerating/constants/app_typography.dart';
import 'package:timetablegenerating/viewmodel/subject_viewmodel.dart'; // Import your SubjectViewModel

class SubjectPage extends StatefulWidget {
  final int courseId;

  SubjectPage({required this.courseId});

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  final TextEditingController _subjectController = TextEditingController();

  void _addSubject() {
    final viewModel = Provider.of<SubjectViewModel>(context, listen: false);
    if (_subjectController.text.isNotEmpty) {
      viewModel.addSubject(_subjectController.text, widget.courseId);
      CustomSnackBar.show(
        context,
        snackBarType: SnackBarType.success,
        label: 'Subject "${_subjectController.text}" added successfully!',
        bgColor: Colors.green,
      );
      _subjectController.clear();
    }
  }

  void _showDeleteDialog(
      BuildContext context, int subjectId, SubjectViewModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Subject',
              style: AppTypography.outfitboldmainHead),
          content: const Text('Are you sure you want to delete this Subject?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                  child:
                      const Text('No', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 20),
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
                    await model.deleteSubject(subjectId,
                        widget.courseId); // Use the deleteSubject method
                    CustomSnackBar.show(
                      context,
                      snackBarType: SnackBarType.success,
                      label: 'Subject deleted successfully!',
                      bgColor: Colors.green,
                    );
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text('Yes', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<SubjectViewModel>(context, listen: false);
    viewModel.fetchSubjects(widget.courseId); // Fetch subjects on init
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SubjectViewModel>(context);

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
              onTap: _addSubject, // Call the add subject function
              buttonColor: Theme.of(context).primaryColor,
              height: 50,
              width: double.infinity,
            ),
            SizedBox(height: 20),
            // List of Subjects
            Expanded(
              child: viewModel.subjects.isEmpty
                  ? Center(
                      child: Text(
                        'No subjects available.',
                        style: AppTypography.outfitRegular,
                      ),
                    )
                  : ListView.builder(
                      itemCount: viewModel.subjects.length,
                      itemBuilder: (context, index) {
                        final subject = viewModel.subjects[index];
                        return ListTile(
                          title: Text(subject['name']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Show the delete confirmation dialog
                              _showDeleteDialog(
                                  context, subject['id'], viewModel);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
