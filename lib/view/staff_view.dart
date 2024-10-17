import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:timetablegenerating/widgets/custom_snackbar.dart';
import 'package:timetablegenerating/widgets/custom_button.dart';
import 'package:timetablegenerating/constants/app_typography.dart';

class StaffViewScreen extends StatelessWidget {
  final TextEditingController _staffController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Staff', style: AppTypography.outfitboldmainHead),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Staff Name Text Field
            TextField(
              controller: _staffController,
              decoration: InputDecoration(
                labelText: 'Staff Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 12),
            // Custom Button for Adding Staff
            CustomButton(
              buttonName: 'Add Staff',
              onTap: () {
                if (_staffController.text.isNotEmpty) {
                  CustomSnackBar.show(
                    context,
                    snackBarType: SnackBarType.success,
                    label: 'Staff "${_staffController.text}" added successfully!',
                    bgColor: Colors.green,
                  );
                  _staffController.clear();
                }
              },
              buttonColor: Theme.of(context).primaryColor,
              height: 50,
              width: double.infinity,
            ),
            SizedBox(height: 20),
            // Placeholder for Staff List
            Expanded(
              child: Center(
                child: Text(
                  'No staff available.',
                  style: AppTypography.outfitRegular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
