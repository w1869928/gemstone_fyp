import 'dart:ffi';

class GemstoneEntity {
  String id;
  String type;
  int hardness;
  String color;
  String cut;
  String clarity;
  String treatment;
  double carat;
  String user;
  String date;
  double price;

  GemstoneEntity({
    required this.id,
    required this.type,
    required this.hardness,
    required this.color,
    required this.cut,
    required this.clarity,
    required this.treatment,
    required this.carat,
    required this.user,
    required this.date,
    required this.price
  });
}