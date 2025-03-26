import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String label;
  final String value;
  final double fontSize;
  final String? fontFamily;
  final Color color = Colors.black;
  const CustomText({
    super.key,
    required this.label,
    required this.value,
    required this.fontSize,
    this.fontFamily
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: fontSize, color: color, fontFamily: fontFamily),
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: fontFamily),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
