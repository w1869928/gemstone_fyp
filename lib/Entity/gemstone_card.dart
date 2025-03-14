import 'package:flutter/material.dart';
import 'package:gemstone_fyp/Entity/gemstone_entity.dart';
import 'package:gemstone_fyp/Themes/color_palette.dart';

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
                  _buildDetailText('Type', entity.type),
                  _buildDetailText('Carat', entity.carat.toString()),
                  _buildDetailText('Clarity', entity.clarity),
                  _buildDetailText('Cut', entity.cut),
                  _buildDetailText('Hardness', entity.hardness.toString()),
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
                  _buildDetailText('Price', entity.price.toStringAsFixed(2)),
                  _buildDetailText('Treatment', entity.treatment),
                  _buildDetailText('Color', entity.color),
                  _buildDetailText('Created At', entity.date),
                ],
              ),
            ),
          ),
          IconButton(onPressed: onDelete, icon: Icon(Icons.delete, color: Colors.red,))
        ],
      ),
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
