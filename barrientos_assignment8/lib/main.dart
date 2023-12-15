import 'package:barrientos_assignment8/screens/product_list_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ProductManagement());
}

class ProductManagement extends StatelessWidget {
  const ProductManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: ProductListScreen(),
    );
  }
}
