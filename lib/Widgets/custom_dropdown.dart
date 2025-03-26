import 'package:flutter/material.dart';
import '../Themes/color_palette.dart';
import 'image_icon_builder.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> items;
  final String? selectedValue;
  final Function(String?) onChanged;
  final String iconPath;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.iconPath  = 'assets/icons/gem-outline.png'
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedValue,
            onChanged: onChanged,
            icon: Icon(
              Icons.arrow_drop_down_circle,
              color: ColorPalette.mainBlue[8]!,
            ),
            dropdownColor: ColorPalette.mainGray[6]!,
            style: TextStyle(
              color: ColorPalette.mainBlue[8]!,
              fontWeight: FontWeight.bold,
            ),
            items: items.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option, style: TextStyle(color: ColorPalette.mainBlue[8]!, fontWeight: FontWeight.bold)),
              );
            }).toList(),
            decoration: InputDecoration(
              fillColor: ColorPalette.mainGray[8],
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
              label: Text(hint, style: TextStyle(color: ColorPalette.mainBlue[8]!, fontWeight: FontWeight.bold, fontSize: 14)),
              prefixIcon: ImageIconBuilder(
                image: iconPath,
                iconColor: ColorPalette.mainBlue[8]!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
