import 'package:barrientos_assignment8/database/dbhelper.dart';
import 'package:barrientos_assignment8/models/products.dart';
import 'package:barrientos_assignment8/screens/add_screen.dart';
import 'package:flutter/material.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  Future<bool?> _showEditConfirmationDialog() async {
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to edit this product?"),
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
              child: Text("Edit"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditScreen(Product product) async {
    bool? shouldEdit = await _showEditConfirmationDialog();

    if (shouldEdit == true) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EditScreen(product: product)),
      ).then((_) {
        setState(() {
          // Refresh the UI after editing
        });
      });
    }
  }

  void _showDeleteConfirmationDialog(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Product"),
          content: Text("Are you sure you want to delete ${product.name}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await Dbhelper.deleteProduct(product);
                setState(() {
                  // Refresh the UI after deleting
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Management'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Add()),
              );
              setState(() {});
            },
            icon: Icon(Icons.add_sharp),
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: Dbhelper.fetchRaw(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var products = snapshot.data ?? [];
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = Product(
                  name: products[index][Dbhelper.colName],
                  description: products[index][Dbhelper.colDescription],
                  price: double.parse(
                    products[index][Dbhelper.colPrice].toString(),
                  ),
                  discountedPrice: double.parse(
                    products[index][Dbhelper.dPrice].toString(),
                  ),
                  quantity: double.parse(
                    products[index][Dbhelper.colQuantity].toString(),
                  ),
                  manufacturer: products[index][Dbhelper.colManufacturer],
                );

                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Php: \$${product.price.toString()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _navigateToEditScreen(product);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(product);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class EditScreen extends StatefulWidget {
  final Product product;

  EditScreen({required this.product});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountedPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController manufacturerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the current product details
    nameController.text = widget.product.name;
    descriptionController.text = widget.product.description;
    priceController.text = widget.product.price.toString();
    discountedPriceController.text = widget.product.discountedPrice.toString();
    quantityController.text = widget.product.quantity.toString();
    manufacturerController.text = widget.product.manufacturer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
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
                onPressed: () {
                  // Save the edited product details
                  Product editedProduct = Product(
                    name: nameController.text,
                    description: descriptionController.text,
                    price: double.parse(priceController.text),
                    discountedPrice:
                        double.parse(discountedPriceController.text),
                    quantity: double.parse(quantityController.text),
                    manufacturer: manufacturerController.text,
                  );

                  // Update the product in the database
                  Dbhelper.updateProduct(widget.product, editedProduct);

                  Navigator.pop(context); // Close the edit screen
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
