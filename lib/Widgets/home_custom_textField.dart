import 'package:flutter/material.dart';
import '../Themes/color_palette.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String iconPath;
  final double width;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.iconPath = 'assets/icons/gem-outline.png',
    this.width = 172, // Default width to match dropdown
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: width,
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: ColorPalette.mainBlue[8]!, // Text color
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                fillColor: ColorPalette.mainGray[8], // Background color
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: ColorPalette.mainBlue[8]!, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: ColorPalette.mainBlue[7]!, width: 2),
                ),
                hintText: hint,
                hintStyle: TextStyle(color: ColorPalette.mainBlue[8]!, fontSize: 14),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(iconPath, height: 20, width: 20, color: ColorPalette.mainBlue[8]!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
