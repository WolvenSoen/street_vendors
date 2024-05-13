import 'package:flutter/material.dart';

import '../../../../utils/helpers/helpers.dart';

class ItemDetailsScreen extends StatelessWidget {
  const ItemDetailsScreen({super.key, required this.id, required this.vendorName, required this.itemName, required this.itemDescription, required this.itemStock, required this.itemPrice, required this.itemPictures});

  final String id;
  final String vendorName;
  final String itemName;
  final String itemDescription;
  final int itemStock;
  final double itemPrice;
  final List<String> itemPictures;

  @override
  Widget build(BuildContext context) {

    final dark = Helpers.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // IF THERES ONLY ONE PICTURE, DISPLAY IT AS A SINGLE IMAGE
            if (itemPictures.length == 1)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(itemPictures[0], fit: BoxFit.cover),
                        ),
                      );
                    },
                  );
                },
                child: Image.network(itemPictures[0], width: double.infinity, height: 200, fit: BoxFit.cover),
              ),
            if (itemPictures.length > 1)
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: itemPictures.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.network(itemPictures[index], fit: BoxFit.cover),
                                  ),
                                );
                              },
                            );
                          },
                          child: Image.network(itemPictures[index], width: 200, height: 200, fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                itemName,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '\$${itemPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '$itemStock disponible(s)',
              style: TextStyle(
                fontSize: 13,
                color: itemStock <3 ? Colors.red : dark? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                itemDescription,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ]
        )
      )
    );
  }
}
