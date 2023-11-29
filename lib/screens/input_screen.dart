import 'package:flutter/material.dart';

import '../service/storage_service.dart';
import '../model/product.dart';

class PageInput extends StatefulWidget {
  @override
  _PageInputState createState() => _PageInputState();
}

class _PageInputState extends State<PageInput> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  void _submitData(BuildContext context) {
    final name = nameController.text;
    final description = descriptionController.text;
    final imageUrl = imageUrlController.text;
    final category = categoryController.text;

    if (name.isEmpty ||
        description.isEmpty ||
        imageUrl.isEmpty ||
        category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Semua field harus diisi!'),
        ),
      );
      return;
    }

    final newProduct = Product(
      id: DateTime.now().toString(),
      name: name,
      description: description,
      imageUrl: imageUrl,
      category: category,
    );

    List<Product> products = [];
    print(products);
    StorageService.getProducts().then((existingProducts) {
      products = existingProducts;
      products.add(newProduct);

      StorageService.saveProducts(products);

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: 'Link Gambar'),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Kategori'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _submitData(context),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
