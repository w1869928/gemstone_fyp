import 'package:flutter/material.dart';

import '../Themes/color_palette.dart';
import 'image_icon_builder.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final double borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;
  final String fontFamily;
  final String? icon;
  final FontWeight fontWeight;
  final double fontSize;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 48.0,
    this.width = double.infinity,
    this.borderRadius = 4.0,
    this.backgroundColor = ColorPalette.primaryBlue,
    this.borderColor = Colors.transparent,
    this.foregroundColor = Colors.white,
    this.fontFamily = 'Outfit',
    this.icon,
    this.fontWeight = FontWeight.w600,
    this.fontSize = 13,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor,
          )),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: ColorPalette.mainBlue[300],
          highlightColor: ColorPalette.mainBlue[200],
          child: isLoading
              ? Center(
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: foregroundColor,
                      strokeWidth: 3,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null)
                      ImageIconBuilder(
                        isOriginal: true,
                        image: icon!,
                      ),
                    if (icon != null) const SizedBox(width: 8),
                    Text(
                      text,
                      style: TextStyle(
                        color: foregroundColor,
                        fontFamily: fontFamily,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
