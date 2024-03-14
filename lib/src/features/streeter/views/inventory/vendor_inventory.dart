import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/features/streeter/controllers/vendor_inventory_controller.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helpers.dart';

class VendorInventoryScreen extends StatelessWidget {
  VendorInventoryScreen(
      {super.key, required this.vendorId, required this.vendorName});

  final String vendorId;
  final String vendorName;

  @override
  Widget build(BuildContext context) {
    final vendorInventoryController = Get.put(VendorInventoryController());

    final dark = Helpers.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inventario de $vendorName',
          style: TextStyle(fontSize: 15),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => FutureBuilder(
            key: Key(vendorInventoryController.refreshData.value.toString()),
            future: vendorInventoryController.getVendorInventory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                //RETURN PROGRESS BAR INDICATOR
                return const Center(
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.primaryColor,
                    color: Colors.black,
                  ),
                );
              }

              if (vendorInventoryController.items.isEmpty) {
                return const Column(
                  children: [
                    SizedBox(height: 30),
                    Center(
                      child: Text('No tienes items en tu inventario aún'),
                    ),
                  ],
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final items = snapshot.data as List;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListTile(
                      title: Text(items[index].itemName),
                      subtitle: Text(items[index].itemDescription),
                      trailing: Text(
                        '\$${items[index].itemPrice}',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      leading: vendorInventoryController
                              .items[index].itemPictures.isNotEmpty
                          ? Image.network(
                          vendorInventoryController.items[index].itemPictures[0])
                          : Icon(
                              Icons.image,
                              size: 40,
                              color: dark ? Colors.white : Colors.black,
                            ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(items[index].itemName),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  // TODO: IMAGE CAROUSEL


                                  Text(items[index].itemDescription),
                                  Text(
                                    'Stock: ${items[index].itemStock}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    'Precio: \$${items[index].itemPrice}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
