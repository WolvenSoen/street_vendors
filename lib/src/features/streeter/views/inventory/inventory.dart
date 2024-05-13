import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/features/streeter/controllers/inventory_controller.dart';
import 'package:street_vendors/src/utils/helpers/helpers.dart';

import '../../../../utils/constants/colors.dart';
import 'manage_item.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryController = Get.put(InventoryController());
    final dark = Helpers.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Inventario', style: TextStyle(fontSize: 20)),
      ),
      body: Obx(
        () => FutureBuilder(
          key: Key(inventoryController.refreshData.value.toString()),
          future: inventoryController.getInventory(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              //RETURN PROGRESS BAR INDICATOR
              return const Center(child: CircularProgressIndicator(
                backgroundColor: Colors.black,
                color: AppColors.primaryColor,
              ));
            }

            if(inventoryController.items.isEmpty) {
              return const Column(
                children: [
                  SizedBox(height: 30),
                  Center(child: Text('No tienes items en tu inventario aún'),),
                ],
              );
            }


            if(snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'),);

            final items = snapshot.data as List;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: ListTile(
                      title: Text(items[index].itemName, style: TextStyle(
                        color: items[index].isActive ? dark? Colors.white : Colors.black : Colors.blueGrey,
                      ),),
                      subtitle: Text('Stock: ${items[index].itemStock}', style: TextStyle(
                        color: items[index].itemStock < 1 ? Colors.red : dark? Colors.white : Colors.black,
                      ),),
                      trailing: Text('\$${items[index].itemPrice}0', style: TextStyle(
                        color: items[index].isActive ? dark? Colors.white : Colors.black : Colors.blueGrey, fontSize: 17
                      ),),
                      leading: inventoryController.items[index].itemPictures.isNotEmpty
                          ? Image.network(inventoryController.items[index].itemPictures[0])
                          : Icon(Icons.image, size: 40, color: dark ? Colors.white : Colors.black,),
                      onTap: (){
                        Get.to(ManageItemScreen(id: items[index].id),);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton(
          onPressed: () {
            Get.to(ManageItemScreen(id: ''),);
          },
          backgroundColor: AppColors.primaryColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
