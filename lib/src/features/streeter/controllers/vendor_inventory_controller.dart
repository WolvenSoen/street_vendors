import 'package:get/get.dart';

import '../../../common/components/loaders/loaders.dart';
import '../../../data/repositories/inventory/inventory_repository.dart';
import '../models/item_model.dart';

class VendorInventoryController extends GetxController {
  static VendorInventoryController get instance => Get.find();

  final inventoryRepository = Get.put(InventoryRepository());

  RxList<ItemModel> items = <ItemModel>[].obs;
  RxBool refreshData = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<ItemModel>> getVendorInventory(String vendorId) async {
    try {
      final items = await inventoryRepository.fetchVendorInventory(vendorId);

      this.items.assignAll(items);

      return items;

    } catch (e) {
      Loaders.errorSnackBar(
          title: 'Oops!',
          message: e.toString()
      );
      return [];
    }
  }

}
