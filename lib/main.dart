import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'additem.dart';
import 'display_items.dart';
import 'item_provider.dart'; // Import the provider
import 'seller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ItemProvider()), // Provide ItemProvider
      ],
      child: InventoryApp(),
    ),
  );
}

class InventoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemProvider =
        Provider.of<ItemProvider>(context); // Access the provider

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stores',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'FontFamilyBold',
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Display Items'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayItemsScreen(
                      items: itemProvider.items,
                      onDecrement: itemProvider.decrementQuantity,
                      onIncrement: itemProvider.incrementQuantity,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Add Item'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddItemPage(
                      // Pass the callback to add an item to the provider
                      onAddItem: (newItem) {
                        itemProvider
                            .addItem(newItem); // Add the item to the provider
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SellerScreen(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayItemsScreen(
                      items: itemProvider.items,
                      onDecrement: itemProvider.decrementQuantity,
                      onIncrement: itemProvider.incrementQuantity,
                    ),
                  ),
                );
              },
              child: Text('Display Items'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddItemPage(
                      // Pass the callback to add an item to the provider
                      onAddItem: (newItem) {
                        itemProvider
                            .addItem(newItem); // Add the item to the provider
                      },
                    ),
                  ),
                );
              },
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}
