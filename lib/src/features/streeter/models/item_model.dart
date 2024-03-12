import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String itemName;
  final List<String> itemPictures;
  final String itemDescription;
  final double itemPrice;
  final int itemStock;
  final bool isActive;


  ItemModel({
    required this.id,
    required this.itemName,
    required this.itemPictures,
    required this.itemDescription,
    required this.itemPrice,
    required this.itemStock,
    required this.isActive,
  });



  static ItemModel empty() => ItemModel(
    id: '',
    itemName: '',
    itemPictures: [],
    itemDescription: '',
    itemPrice: 0.0,
    itemStock: 0,
    isActive: false,
  );

  // CONVERT TO JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'itemName': itemName,
    'itemPictures': itemPictures,
    'itemDescription': itemDescription,
    'itemPrice': itemPrice,
    'itemStock': itemStock,
    'isActive': isActive,
  };

  // CONVERT FROM JSON TO MODEL
  factory ItemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    if(document.data() != null){
      final data = document.data()!;
      return ItemModel(
        id: document.id,
        itemName: data['itemName'] ?? '',
        itemPictures: List<String>.from(data['itemPictures'] ?? []),
        itemDescription: data['itemDescription'] ?? '',
        itemPrice: data['itemPrice'] ?? 0.0,
        itemStock: data['itemStock'] ?? 0,
        isActive: data['isActive'] ?? false,
      );
    }
    return ItemModel.empty();
  }
}