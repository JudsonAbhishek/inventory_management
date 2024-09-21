import 'package:flutter/material.dart';

import 'items.dart';

class SellerScreen extends StatefulWidget {
  final List<Item> items;
  final Function(int) onDecrement;

  SellerScreen({required this.items, required this.onDecrement});

  @override
  _SellerScreenState createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  String searchQuery = '';
  List<int> cart = []; // List to keep track of item indices in the cart

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Filter items based on search query
    List<Item> filteredItems = widget.items
        .where((item) =>
            item.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    // Calculate total cart amount
    double totalAmount = cart.fold(0, (sum, index) {
      final item = widget.items[index];
      return sum + (item.salePrice * item.quantity);
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Search items by name',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        'No items to display.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth > 600 ? 4 : 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return GestureDetector(
                          onTap: () {
                            // Handle item click if necessary
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade400,
                                            offset: const Offset(0, 3),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        backgroundImage: item.image != null
                                            ? FileImage(item.image!)
                                            : null,
                                        radius: 28,
                                        backgroundColor: Colors.grey[200],
                                        child: item.image == null
                                            ? Icon(Icons.image,
                                                size: 30, color: Colors.grey)
                                            : null,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Sale: \$${item.salePrice}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.redAccent),
                                          onPressed: () {
                                            setState(() {
                                              widget.onDecrement(index);
                                              if (cart.contains(index)) {
                                                cart.remove(index);
                                              }
                                            });
                                          },
                                        ),
                                        Text(
                                          '${item.quantity}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.add_circle_outline,
                                              color: Colors.greenAccent),
                                          onPressed: () {
                                            setState(() {
                                              cart.add(index);
                                              widget.onDecrement(
                                                  index); // Assuming this should also increment
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Quantity: ${item.unit}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Exp dt: ${item.expiry}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.blueAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cart Summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Items in cart: ${cart.length}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle the purchase process
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Purchase Summary'),
                            content: Text(
                              'You are about to purchase ${cart.length} items for a total of \$${totalAmount.toStringAsFixed(2)}.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Handle purchase confirmation here
                                  Navigator.of(context).pop();
                                  // Clear the cart after purchase
                                  setState(() {
                                    cart.clear();
                                  });
                                },
                                child: Text('Buy'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('Buy'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
