import 'package:flutter/material.dart';

import 'items.dart';

class DisplayItemsScreen extends StatefulWidget {
  final List<Item> items;
  final Function(int) onDecrement;
  final Function(int) onIncrement;

  DisplayItemsScreen({
    required this.items,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  State<DisplayItemsScreen> createState() => _DisplayItemsScreenState();
}

class _DisplayItemsScreenState extends State<DisplayItemsScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<Item> filteredItems = widget.items
        .where((item) =>
            item.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    double totalIncome = filteredItems.fold(
        0,
        (sum, item) =>
            sum + (item.salePrice - item.purchasePrice) * item.quantity);

    int itemCount = filteredItems.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Display Items'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        'No items to display.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final income = (item.salePrice - item.purchasePrice) *
                            item.quantity;

                        return GestureDetector(
                          onTap: () {},
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                            ? Icon(Icons.image, size: 30)
                                            : null,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
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
                                    SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.redAccent),
                                          onPressed: () {
                                            setState(() {
                                              widget.onDecrement(index);
                                            });
                                          },
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${item.quantity}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.add_circle_outline,
                                              color: Colors.greenAccent),
                                          onPressed: () {
                                            setState(() {
                                              widget.onIncrement(index);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
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
                                    Text(
                                      'Income: \$${income.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Overall Profit: \$${totalIncome.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Number of Items: $itemCount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
