import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetablegenerating/constants/app_typography.dart';
import 'package:timetablegenerating/utils/responsive.dart';
import 'package:timetablegenerating/viewmodel/staff_viewmodel.dart';

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
    Provider.of<StaffViewModel>(context, listen: false).fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    final staffViewModel = Provider.of<StaffViewModel>(context);
    final responsive = context.responsive;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assign Subject for "${widget.staffName}"',
          style: AppTypography.outfitboldmainHead.copyWith(
            fontSize: responsive.sp(20), // Use responsive text scaling
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(responsive.wp(4)), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Courses',
              style: AppTypography.outfitboldsubHead.copyWith(
                fontSize: responsive.sp(18),
              ),
            ),
            SizedBox(height: responsive.hp(2)), // Responsive spacing
            Expanded(
              child: Wrap(
                spacing: responsive.wp(2),
                runSpacing: responsive.hp(1),
                children: staffViewModel.courseList.map((course) {
                  return ChoiceChip(
                    label: Text(
                      course['name'],
                      style: AppTypography.outfitRegular.copyWith(
                        fontSize: responsive.sp(16),
                      ),
                    ),
                    selected: false, // Manage the selected state as needed
                    onSelected: (bool selected) {
                      // Handle course selection here if needed
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
