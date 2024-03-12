import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/features/streeter/controllers/inventory_controller.dart';
import 'package:street_vendors/src/utils/validators/validators.dart';

class ManageItemScreen extends StatelessWidget {
  ManageItemScreen({super.key, required this.id});

  String id = "";

  final controller = Get.put(InventoryController());

  @override
  Widget build(BuildContext context) {
    String title = "Creando";

    if (id != "") {
      title = "Modificando";

      // GET ITEM TO MODIFY
      for (var element in controller.items) {
        if (element.id == id) {
          controller.itemId.value = element.id;
          controller.itemName.text = element.itemName;
          controller.itemDescription.text = element.itemDescription;
          controller.itemStock.text = element.itemStock.toString();
          controller.itemPrice.text = element.itemPrice.toString();
          controller.isActive.value = element.isActive;
          controller.itemPictures.value = element.itemPictures;
        }
      }
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
        title: Text(''),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(child: Text('$title un item')),
            if (id != "")
              Center(
                  child: Text('ID: $id', style: const TextStyle(fontSize: 20))),
            const SizedBox(height: 30),

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
                            child:
                                Image.network(controller.itemPictures[index],
                                    width: 200, height: 200, fit: BoxFit.cover),
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
                          id == '' ? controller.saveItem() : controller.updateItem();
                        },
                        child: const Text('Guardar'),
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
