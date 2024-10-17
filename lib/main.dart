import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetablegenerating/view/course_view.dart';
import 'package:timetablegenerating/viewmodel/cousre_viewmodel.dart';
import 'package:timetablegenerating/viewmodel/day_viewmodel.dart';
import 'package:timetablegenerating/viewmodel/staff_viewmodel.dart';
import 'package:timetablegenerating/viewmodel/subject_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseViewModel()),
        ChangeNotifierProvider(create: (_) => SubjectViewModel()),
        ChangeNotifierProvider(create: (_) => StaffViewModel()),
        ChangeNotifierProvider(create: (_) => DayViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timetable Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CoursePage(),
    );
  }
}
