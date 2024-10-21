import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:timetablegenerating/viewmodel/staff_viewmodel.dart';
import 'package:timetablegenerating/constants/app_typography.dart';
import 'package:timetablegenerating/utils/responsive.dart';
import 'package:timetablegenerating/widgets/custom_snackbar.dart';

class StaffManagementPage extends StatefulWidget {
  final int staffId;
  final String staffName;

  StaffManagementPage({required this.staffId, required this.staffName});

  @override
  _StaffManagementPageState createState() => _StaffManagementPageState();
}

class _StaffManagementPageState extends State<StaffManagementPage> {
  int? selectedSubjectId; // Variable to hold the selected subject ID

  @override
  void initState() {
    super.initState();
    final staffViewModel = Provider.of<StaffViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeStaffManagement(staffViewModel);
    });
  }

  Future<void> _initializeStaffManagement(StaffViewModel staffViewModel) async {
    staffViewModel.fetchCourses();
    staffViewModel.fetchSubjectsForCourses([]);
    staffViewModel.printStaff();
    staffViewModel.printCourses();
    staffViewModel.printSubjects();
    staffViewModel.printStaffAssignments();
  }

  @override
  Widget build(BuildContext context) {
    final staffViewModel = Provider.of<StaffViewModel>(context);
    final responsive = context.responsive;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assign Subject for ${widget.staffName}',
          style: AppTypography.outfitboldmainHead.copyWith(
            fontSize: responsive.sp(20),
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(responsive.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Courses',
              style: AppTypography.outfitboldsubHead.copyWith(
                fontSize: responsive.sp(18),
              ),
            ),
            SizedBox(height: responsive.hp(2)),
            Expanded(
              child: Wrap(
                spacing: responsive.wp(2),
                runSpacing: responsive.hp(1),
                children: [
                  ChoiceChip(
                    label: Text(
                      'All',
                      style: AppTypography.outfitRegular.copyWith(
                        fontSize: responsive.sp(16),
                      ),
                    ),
                    selected: staffViewModel.selectedCourseId == 0,
                    onSelected: (bool selected) {
                      if (selected) {
                        staffViewModel.selectCourse(0);
                        staffViewModel.fetchSubjectsForCourses([0]);
                      }
                    },
                  ),
                  ...staffViewModel.courseList.map((course) {
                    return ChoiceChip(
                      label: Text(
                        course['name'],
                        style: AppTypography.outfitRegular.copyWith(
                          fontSize: responsive.sp(16),
                        ),
                      ),
                      selected: staffViewModel.selectedCourseId == course['id'],
                      onSelected: (bool selected) {
                        if (selected) {
                          staffViewModel.selectCourse(course['id']);
                          staffViewModel
                              .fetchSubjectsForCourses([course['id']]);
                        }
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: responsive.hp(2)),
            Text(
              'Subjects',
              style: AppTypography.outfitboldsubHead.copyWith(
                fontSize: responsive.sp(18),
              ),
            ),
            SizedBox(height: responsive.hp(1)),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: staffViewModel.subjectList.length,
                itemBuilder: (context, index) {
                  final subject = staffViewModel.subjectList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                    child: ListTile(
                      title: Text(
                        subject['name'],
                        style: AppTypography.outfitRegular.copyWith(
                          fontSize: responsive.sp(16),
                        ),
                      ),
                      onTap: () {
                        selectedSubjectId =
                            subject['id']; // Store selected subject ID
                        _showConfirmationDialog(context, subject);
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

  void _showConfirmationDialog(
      BuildContext context, Map<String, dynamic> subject) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Assignment',
            style: AppTypography.outfitboldmainHead,
          ),
          content: Text(
            'Are you sure you want to assign ${subject['name']} to ${widget.staffName}?',
            style: AppTypography.outfitRegular,
          ),
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
                    if (selectedSubjectId != null) {
                      final staffViewModel =
                          Provider.of<StaffViewModel>(context, listen: false);
                      await staffViewModel.assignStaffToSubject(
                          widget.staffId, selectedSubjectId!);
                      _showSuccessSnackbar(context);
                    }
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

  void _showSuccessSnackbar(BuildContext context) {
    CustomSnackBar.show(
      context,
      snackBarType: SnackBarType.success,
      label: 'Subject assigned successfully!',
      bgColor: Colors.green,
    );
  }
}
