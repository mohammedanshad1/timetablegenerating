import 'package:flutter/material.dart';
import 'package:timetablegenerating/utils/responsive.dart';
import 'package:timetablegenerating/view/couse_view.dart';
import 'package:timetablegenerating/view/staff_view.dart';
import 'package:timetablegenerating/view/subject_view.dart';
import 'package:timetablegenerating/constants/app_typography.dart';

class AddingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Time Table Generating',
          style: AppTypography.outfitboldmainHead.copyWith(
            fontSize: responsive.sp(22),
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(responsive.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: responsive.width > 600 ? 3 : 2,
                crossAxisSpacing: responsive.wp(4),
                mainAxisSpacing: responsive.hp(2),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCourseView(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.book,
                            size: responsive.wp(12),
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(height: responsive.hp(1)),
                          Text(
                            'Add Course',
                            style: AppTypography.outfitRegular.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: responsive.sp(14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubjectPage(courseId: 1),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.subject,
                            size: responsive.wp(12),
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(height: responsive.hp(1)),
                          Text(
                            'Add Subjects',
                            style: AppTypography.outfitRegular.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: responsive.sp(14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StaffViewScreen(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_add,
                            size: responsive.wp(12),
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(height: responsive.hp(1)),
                          Text(
                            'Add Staff',
                            style: AppTypography.outfitRegular.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: responsive.sp(14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
