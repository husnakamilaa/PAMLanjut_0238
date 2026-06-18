import 'package:booking_villa/data/repositories/payment_repository.dart';
import 'package:booking_villa/logic/bloc/payment/payment_event.dart';
import 'package:booking_villa/logic/bloc/payment/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository repository;

  PaymentBloc(this.repository) : super(PaymentInitial()) {
    on<CreatePayment>(_onCreatePayment);
  }

  Future<void> _onCreatePayment(
    CreatePayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
 
    try {
      final result = await repository.createPayment(
        villaId: event.villaId,
        userId: event.userId,
        tglCheckin: event.tglCheckin,
        tglCheckout: event.tglCheckout,
        amount: event.amount,
        customerName: event.customerName,
        customerEmail: event.customerEmail,
      );
 
      emit(PaymentSuccess(
        snapToken: result.snapToken,
        redirectUrl: result.redirectUrl,
        bookingId: result.bookingId,
      ));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }
}