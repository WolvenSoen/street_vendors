import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/features/streeter/controllers/inventory_controller.dart';
import 'package:street_vendors/src/utils/validators/validators.dart';

class ManageItemScreen extends StatelessWidget {
  ManageItemScreen({super.key, required this.id});

  String id = "";

  @override
  Widget build(BuildContext context) {
    final controller = InventoryController.instance;

    String title = "Creando";

    if (id != "") {
      title = "Modificando";

      // GET ITEM TO MODIFY
      final item = controller.items.firstWhere((element) => element.id == id);

      controller.itemId.value = item.id;
      controller.itemName.text = item.itemName;
      controller.itemDescription.text = item.itemDescription;
      controller.itemStock.text = item.itemStock.toString();
      controller.itemPrice.text = item.itemPrice.toString();
      controller.isActive.value = item.isActive;
      controller.itemPictures.value = item.itemPictures.obs;
    } else {
      controller.itemId.value = "";
      controller.itemName.text = "";
      controller.itemDescription.text = "";
      controller.itemStock.text = "";
      controller.itemPrice.text = "";
      controller.isActive.value = false;
      controller.itemPictures.value = [];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$title producto | servicio",
          style: const TextStyle(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // IMAGES SECTION
            const SizedBox(height: 20),
            Obx(
              () => controller.itemPictures.isEmpty
                  ? const Text('No has agregado imágenes')
                  : SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.itemPictures.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Image.network(controller.itemPictures[index],
                                    width: 200, height: 200, fit: BoxFit.cover),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      controller.removePicture(index);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),

            // BUTTON TO ADD MORE IMAGES
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: IconButton(
                icon: const Icon(Icons.add_a_photo),
                onPressed: () {
                  controller.addPicture();
                },
              ),
            ),

            // FORM
            Form(
                key: controller.manageItemFormKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        validator: (value) => Validators.validateEmptyField(
                            value, 'Nombre del artículo | servicio'),
                        controller: controller.itemName,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del artículo | servicio',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        validator: (value) => Validators.validateEmptyField(
                            value, 'Descripción del artículo | servicio'),
                        controller: controller.itemDescription,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          labelText: 'Descripción del artículo | servicio',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        validator: (value) =>
                            Validators.validateEmptyField(value, 'Stock'),
                        controller: controller.itemStock,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Stock',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        validator: (value) =>
                            Validators.validateEmptyField(value, 'Precio'),
                        controller: controller.itemPrice,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Precio',
                        ),
                      ),
                    ),

                    // CHECKBOX TO INDICATE IF THE ITEM IS ACTIVE
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          const Text('Activo'),
                          Obx(
                            () => Checkbox(
                              value: controller.isActive.value,
                              onChanged: (value) =>
                                  controller.isActive.value = value!,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SUBMIT BUTTON
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          id == ''
                              ? controller.saveItem()
                              : controller.updateItem();
                        },
                        child: const Text('Guardar'),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),

                    // DELETE BUTTON
                    if (id != "")
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: OutlinedButton(
                          onPressed: () {
                            /*controller.deleteItem();*/

                            // SHOW DIALOG TO CONFIRM
                            Get.defaultDialog(
                              title: 'Eliminar',
                              middleText:
                                  '¿Estás seguro que deseas eliminar este item?',
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.deleteItem();
                                  },
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            );

                          },
                          child: const Text('Eliminar'),
                        ),
                      ),

                  ],
                ))
          ],
        ),
      ),
    );
  }
}
