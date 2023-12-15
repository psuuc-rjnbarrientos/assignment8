import 'package:barrientos_assignment8/database/dbhelper.dart';

class Product {
  final String name;
  final String description;
  final double price;
  final double discountedPrice;
  final double quantity;
  final String manufacturer;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.discountedPrice,
    required this.quantity,
    required this.manufacturer,
  });

  Map<String, dynamic> toMap() {
    return {
      Dbhelper.colName: name,
      Dbhelper.colDescription: description,
      Dbhelper.colPrice: price,
      Dbhelper.dPrice: discountedPrice,
      Dbhelper.colQuantity: quantity,
      Dbhelper.colManufacturer: manufacturer,
    };
  }
}
