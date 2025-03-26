import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gemstone_fyp/Themes/color_palette.dart';

import 'image_icon_builder.dart';

class SelectCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String icon;
  final bool isBordered;

  const SelectCard({
    required this.title,
    required this.onTap,
    this.icon = '',
    this.isBordered = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          decoration: BoxDecoration(
            color: ColorPalette.mainBlue[8],
            borderRadius:BorderRadius.circular(8),
            border:isBordered ? Border.all(color: ColorPalette.mainBlue[7]!)
                : null
          ),
          child: InkWell(
            onTap: onTap,
            splashColor: ColorPalette.mainBlue[7],
            highlightColor: ColorPalette.mainBlue[7],
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Row(
                  children: [
                    if (icon.isNotEmpty)
                      Container(
                        width: isBordered ? 42 : 48,
                        height: isBordered ? 42 : 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            color: isBordered
                                ? ColorPalette.mainBlue[7]!
                                : const Color(0xFFE9E9E9),
                          ),
                        ),
                        child: Center(
                          child: ImageIconBuilder(
                            image: icon,
                            isSelected: true,
                            selectedColor: ColorPalette.mainBlue[7]!,
                          ),
                        ),
                      ),
                    if (icon.isNotEmpty)
                      const SizedBox(
                        width: 16,
                      ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ColorPalette.mainBlue[7]
                      ),
                    ),
                  ],
                ),
                ImageIconBuilder(
                  image: 'assets/icons/arrow_right_filled.png',
                  isSelected: true,
                  selectedColor: ColorPalette.mainBlue[7]!,
                ),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
