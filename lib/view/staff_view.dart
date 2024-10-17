import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:timetablegenerating/widgets/custom_snackbar.dart';
import 'package:timetablegenerating/widgets/custom_button.dart';
import 'package:timetablegenerating/constants/app_typography.dart';
import 'package:timetablegenerating/viewmodel/staff_viewmodel.dart';

class StaffViewScreen extends StatefulWidget {
  @override
  _StaffViewScreenState createState() => _StaffViewScreenState();
}

class _StaffViewScreenState extends State<StaffViewScreen> {
  final TextEditingController _staffController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Call the method to fetch staff when the screen is initialized.
    Provider.of<StaffViewModel>(context, listen: false).fetchStaff();
  }

  @override
  Widget build(BuildContext context) {
    final staffViewModel = Provider.of<StaffViewModel>(context);

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
              onTap: () async {
                if (_staffController.text.isNotEmpty) {
                  await staffViewModel.addStaff(_staffController.text);
                  CustomSnackBar.show(
                    context,
                    snackBarType: SnackBarType.success,
                    label:
                        'Staff "${_staffController.text}" added successfully!',
                    bgColor: Colors.green,
                  );
                  _staffController.clear();
                  // Refresh the staff list after adding a new staff member
                  staffViewModel.fetchStaff();
                }
              },
              buttonColor: Theme.of(context).primaryColor,
              height: 50,
              width: double.infinity,
            ),
            SizedBox(height: 20),
            // List of Staff
            Expanded(
              child: ListView.builder(
                itemCount: staffViewModel.staffList.length,
                itemBuilder: (context, index) {
                  final staff = staffViewModel.staffList[index];
                  return ListTile(
                    title: Text(staff['name']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteDialog(context, staff['id'], staffViewModel);
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

  void _showDeleteDialog(
      BuildContext context, int staffId, StaffViewModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Staff',
              style: AppTypography.outfitboldmainHead),
          content:
              const Text('Are you sure you want to delete this staff member?'),
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
                    await model.deleteStaff(staffId);
                    CustomSnackBar.show(
                      context,
                      snackBarType: SnackBarType.success,
                      label: 'Staff deleted successfully!',
                      bgColor: Colors.green,
                    );
                    Navigator.of(context).pop();
                    // Refresh the staff list after deletion
                    model.fetchStaff();
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
}
