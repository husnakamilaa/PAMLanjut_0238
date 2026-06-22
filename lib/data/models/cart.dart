import 'package:booking_villa/data/models/villa.dart';

class CartModel {
  final String? id; 
  final String userId;
  final int villaId;
  final VillaModel? villa; 

  CartModel({
    this.id,
    required this.userId,
    required this.villaId,
    this.villa,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id']?.toString(),
      userId: json['user_id'] ?? '',
      villaId: json['villa_id'] ?? 0,

      villa: json['villa'] != null ? VillaModel.fromJson(json['villa']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'villa_id': villaId,
    };
  }
}