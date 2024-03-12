import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/features/streeter/controllers/inventory_controller.dart';

import '../../../../utils/constants/colors.dart';
import 'manage_item.dart';

class InventoryScreen extends StatelessWidget {
  InventoryScreen({super.key});

  InventoryController inventoryController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            Center(child: Text('Mi Inventario')),
            SizedBox(height: 30),
            // LIST OF VENDOR'S ITEMS
            for(int i = 0; i < inventoryController.items.length; i++)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Obx(() {

                  if(inventoryController.loading.value)
                    return Center(child: CircularProgressIndicator());

                  if(inventoryController.items.isEmpty)
                    return Center(child: Text('No tienes items en tu inventario'),);

                  return ListTile(
                    title: Text(inventoryController.items[i].itemName),
                    subtitle: Text(inventoryController.items[i].itemDescription),
                    trailing: Text(inventoryController.items[i].itemPrice.toString()),
                    leading: inventoryController.items[i].itemPictures.isNotEmpty
                        ? Image.network(inventoryController.items[i].itemPictures[0])
                        : Icon(Icons.image),
                    onTap: (){
                      Get.to(ManageItemScreen(id: inventoryController.items[i].id),);
                    },
                  );
                }),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(ManageItemScreen(id: ''),);
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
