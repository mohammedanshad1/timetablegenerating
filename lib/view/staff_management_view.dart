import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetablegenerating/viewmodel/staff_viewmodel.dart';
import 'package:timetablegenerating/constants/app_typography.dart';
import 'package:timetablegenerating/utils/responsive.dart';

class StaffManagementPage extends StatefulWidget {
  final int staffId;
  final String staffName;

  StaffManagementPage({required this.staffId, required this.staffName});

  @override
  _StaffManagementPageState createState() => _StaffManagementPageState();
}

class _StaffManagementPageState extends State<StaffManagementPage> {
  @override
  void initState() {
    super.initState();
    final staffViewModel = Provider.of<StaffViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      staffViewModel
          .fetchCourses(); // Fetch courses after the build is complete
      staffViewModel.fetchSubjectsForCourses(
          []); // Clear subjects after the build is complete
    });
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
                        staffViewModel.selectCourse(0); // "All" selected
                        staffViewModel
                            .fetchSubjectsForCourses([0]); // Fetch all subjects
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
                          staffViewModel
                              .selectCourse(course['id']); // Course selected
                          staffViewModel.fetchSubjectsForCourses([
                            course['id']
                          ]); // Fetch subjects for selected course
                        }
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: responsive.hp(2)), // Reduced space before subjects
            Text(
              'Subjects',
              style: AppTypography.outfitboldsubHead.copyWith(
                fontSize: responsive.sp(18),
              ),
            ),
            SizedBox(
                height: responsive.hp(1)), // Less space before subjects list
            Expanded(
              flex: 2, // Allocate more space for subjects
              child: ListView.builder(
                itemCount: staffViewModel.subjectList.length,
                itemBuilder: (context, index) {
                  final subject = staffViewModel.subjectList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(
                        vertical: responsive.hp(1)), // Space between items
                    child: ListTile(
                      title: Text(
                        subject['name'],
                        style: AppTypography.outfitRegular.copyWith(
                          fontSize: responsive.sp(16),
                        ),
                      ),
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
