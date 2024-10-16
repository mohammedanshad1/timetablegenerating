import 'package:flutter/material.dart';
import 'package:timetablegenerating/constants/app_typography.dart';
import 'package:timetablegenerating/utils/responsive.dart';

class CustomButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onTap;
  final Color buttonColor;
  final double height;
  final double width;

  const CustomButton({
    super.key,
    required this.buttonName,
    required this.onTap,
    required this.buttonColor,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          buttonName,
          style: AppTypography.outfitBold.copyWith(
            color: Colors.white,
            fontSize: responsive.sp(16), // Adjust the font size as needed
          ),
        ),
      ),
    );
  }
}
