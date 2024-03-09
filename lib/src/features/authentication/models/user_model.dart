import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_vendors/src/utils/formatters/formatters.dart';

class UserModel {
  final String id;
  String fullName;
  String firstName;
  String lastName;
  bool isVendor;
  final String email;
  String phoneNumber;
  String profilePicture;

  UserModel({
    required this.id,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isVendor,
    required this.phoneNumber,
    required this.profilePicture,
  });

  String get formatedPhoneNumber => Formatters.formatPhoneNumber(phoneNumber);

  static UserModel empty() => UserModel(
    id: '',
    fullName: '',
    firstName: '',
    lastName: '',
    email: '',
    isVendor: false,
    phoneNumber: '',
    profilePicture: '',
  );

  // CONVERT TO JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'firstName': firstName,
    'lastName': lastName,
    'isVendor': isVendor,
    'email': email,
    'phoneNumber': phoneNumber,
    'profilePicture': profilePicture,
  };

  // CONVERT FROM JSON TO MODEL
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    if(document.data() != null){
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        fullName: data['fullName'] ?? '',
        isVendor: data['isVendor'] ?? false,
        email: data['email'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        profilePicture: data['profilePicture'] ?? '',
      );
    }
    return UserModel.empty();
  }
}