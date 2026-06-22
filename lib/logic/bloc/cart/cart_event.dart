import 'package:booking_villa/data/models/cart.dart';

abstract class CartEvent {}

class FetchCartItems extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final int villaId; 
  AddToCartEvent(this.villaId);
}

class DeleteCartItemEvent extends CartEvent {
  final String id;
  DeleteCartItemEvent(this.id);
}