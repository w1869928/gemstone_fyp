import 'package:flutter/material.dart';
import 'package:gemstone_fyp/Entity/gemstone_entity.dart';
import 'package:gemstone_fyp/Themes/color_palette.dart';
import 'package:gemstone_fyp/Widgets/custom_text.dart';

class GemstoneCard extends StatelessWidget {
  final GemstoneEntity entity;
  final VoidCallback onDelete;
  const GemstoneCard({
    super.key, required this.entity, required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
      padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
      decoration: BoxDecoration(
        color: ColorPalette.mainGray[7],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(label: 'Type', value: entity.type, fontSize: 14),
                  CustomText(label: 'Carat', value: entity.carat.toString(), fontSize: 14),
                  CustomText(label: 'Clarity', value: entity.clarity, fontSize: 14),
                  CustomText(label: 'Cut', value: entity.cut, fontSize: 14),
                  CustomText(label: 'Hardness', value: entity.hardness.toString(), fontSize: 14),

                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(label: 'Price', value: entity.price.toStringAsFixed(2), fontSize: 14),
                  CustomText(label: 'Treatment', value: entity.treatment, fontSize: 14),
                  CustomText(label: 'Color', value: entity.color, fontSize: 14),
                  CustomText(label: 'Created At', value: entity.date, fontSize: 14)

                ],
              ),
            ),
          ),
          IconButton(onPressed: onDelete, icon: Icon(Icons.delete, color: Colors.red,))
        ],
      ),
    );
  }

}
