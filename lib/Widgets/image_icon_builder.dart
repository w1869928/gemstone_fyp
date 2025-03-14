import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Themes/color_palette.dart';

class ImageIconBuilder extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color iconColor;
  final Color selectedColor;
  final bool isSelected;
  final bool isOriginal;

  const ImageIconBuilder({
    super.key,
    required this.image,
    this.height = 24,
    this.width = 24,
    this.backgroundColor = Colors.transparent,
    this.iconColor = ColorPalette.primaryTextColor,
    this.selectedColor = ColorPalette.primaryBlue,
    this.isSelected = false,
    this.isOriginal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: isOriginal
            ? Image.asset(
          image,
          height: height,
          width: width,
        )
            : Image.asset(
          image,
          color: isSelected ? selectedColor : iconColor,
          height: height,
          width: width,
        ),
      ),
    );
  }
}