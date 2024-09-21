import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'items.dart'; // Assuming you have this file for the Item model

class AddItemPage extends StatefulWidget {
  final Function(Item) onAddItem; // Callback for adding an item

  AddItemPage({required this.onAddItem});

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  int _quantity = 1; // Default value for quantity
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  String? _selectedUnit;
  final List<String> _units = [
    'Grams',
    'Kilograms',
    'Milliliters',
    'Liters',
    'Dozens',
    'Packets',
    'Sheets',
  ];

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitItem() {
    if (_nameController.text.isEmpty ||
        _purchasePriceController.text.isEmpty ||
        _salePriceController.text.isEmpty ||
        _selectedUnit == null) {
      // Show an alert if fields are missing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final newItem = Item(
      name: _nameController.text,
      purchasePrice: double.parse(_purchasePriceController.text),
      salePrice: double.parse(_salePriceController.text),
      image: _selectedImage,
      unit: _selectedUnit!,
      quantity: _quantity,
      expiry: _expiryController.text,
    );

    widget.onAddItem(newItem); // Use the callback to add the item
    Navigator.pop(context); // Return to the previous screen
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) _quantity--;
    });
  }

  double _calculateProfit() {
    if (_purchasePriceController.text.isEmpty ||
        _salePriceController.text.isEmpty) {
      return 0.0;
    }

    double purchasePrice =
        double.tryParse(_purchasePriceController.text) ?? 0.0;
    double salePrice = double.tryParse(_salePriceController.text) ?? 0.0;

    return (salePrice - purchasePrice) * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Item'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _selectedImage != null
                      ? Image.file(_selectedImage!,
                          height: 100, width: 100, fit: BoxFit.cover)
                      : Icon(Icons.image, size: 100, color: Colors.grey),
                  SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.edit),
                    label: Text('Edit Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Item name input
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                ),
              ),
              SizedBox(height: 20),
              // Purchase price input
              TextFormField(
                controller: _purchasePriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Purchase Price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                ),
                onChanged: (_) =>
                    setState(() {}), // Recalculate profit on change
              ),
              SizedBox(height: 20),
              // Sale price input
              TextFormField(
                controller: _salePriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Sale Price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.price_check),
                ),
                onChanged: (_) =>
                    setState(() {}), // Recalculate profit on change
              ),
              SizedBox(height: 20),
              // Expiry date input
              TextFormField(
                controller: _expiryController,
                decoration: InputDecoration(
                  labelText: 'Expiry date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
              ),
              SizedBox(height: 20),
              // Unit selection dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Units',
                  border: OutlineInputBorder(),
                ),
                value: _selectedUnit,
                items: _units.map((String unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedUnit = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              // Quantity selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Quantity:', style: TextStyle(fontSize: 16)),
                  IconButton(
                      icon: Icon(Icons.remove), onPressed: _decrementQuantity),
                  Text('$_quantity', style: TextStyle(fontSize: 16)),
                  IconButton(
                      icon: Icon(Icons.add), onPressed: _incrementQuantity),
                ],
              ),
              SizedBox(height: 20),
              // Save button
              Center(
                child: ElevatedButton.icon(
                  onPressed: _submitItem,
                  icon: Icon(Icons.save),
                  label: Text('Save Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 147, 246, 150),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Profit/Loss display
            Text(
              'Profit/Loss: \$${_calculateProfit().toStringAsFixed(2)}',
              style: TextStyle(
                color: _calculateProfit() >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
