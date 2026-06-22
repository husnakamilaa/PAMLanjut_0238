import 'package:booking_villa/data/models/cart.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartModel> cartItems;
  CartLoaded(this.cartItems);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}

class CartActionSuccess extends CartState {
  final String message;
  CartActionSuccess(this.message);
}