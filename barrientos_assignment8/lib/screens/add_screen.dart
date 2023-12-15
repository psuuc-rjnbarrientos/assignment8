import 'dart:async';
import 'package:barrientos_assignment8/database/dbhelper.dart';
import 'package:barrientos_assignment8/models/products.dart';
import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountedPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController manufacturerController = TextEditingController();

  Future<bool?> _showConfirmationDialog() {
    Completer<bool?> completer = Completer<bool?>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to add this product?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    ).then((value) => completer.complete(value));

    return completer.future;
  }

  void addItem() async {
    bool? shouldAdd = await _showConfirmationDialog();

    if (shouldAdd == true) {
      var db = await Dbhelper.OpenDB();
      var product = Product(
        name: nameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        discountedPrice: double.parse(discountedPriceController.text),
        quantity: double.parse(quantityController.text),
        manufacturer: manufacturerController.text,
      );
      Dbhelper.insertProduct(product);

      nameController.clear();
      descriptionController.clear();
      priceController.clear();
      discountedPriceController.clear();
      quantityController.clear();
      manufacturerController.clear();

      print('INSERTED');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: discountedPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Discounted Price'),
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              TextField(
                controller: manufacturerController,
                decoration: InputDecoration(labelText: 'Manufacturer'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: addItem,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
