import 'dart:io';

class Item {
  String name;
  double purchasePrice;
  double salePrice;
  File? image;
  String unit;
  int quantity;
  String expiry; // Expiry date for the item

  Item({
    required this.name,
    required this.purchasePrice,
    required this.salePrice,
    this.image,
    required this.unit,
    required this.quantity,
    required this.expiry, // Expiry date as a named parameter
  });
}
