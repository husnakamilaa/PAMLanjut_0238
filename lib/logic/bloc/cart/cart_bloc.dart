import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_villa/data/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc({required this.repository}) : super(CartInitial()) {
   
    on<FetchCartItems>((event, emit) async {
      emit(CartLoading());
      try {
        final items = await repository.getCartItems();
        emit(CartLoaded(items));
      } catch (e) {
        emit(CartError("Gagal memuat keranjang: $e"));
      }
    });

    on<AddToCartEvent>((event, emit) async {
      emit(CartLoading());
      try {
        await repository.addToCart(event.villaId);
        emit(CartActionSuccess("Villa berhasil disimpan ke keranjang"));
        add(FetchCartItems()); 
      } catch (e) {
        emit(CartError("Gagal menambahkan ke keranjang: $e"));
      }
    });

    on<DeleteCartItemEvent>((event, emit) async {
      try {
        await repository.deleteCartItem(event.id);
        emit(CartActionSuccess("Villa dihapus dari keranjang"));
        add(FetchCartItems()); 
      } catch (e) {
        emit(CartError("Gagal menghapus dari keranjang: $e"));
      }
    });
  }
}
