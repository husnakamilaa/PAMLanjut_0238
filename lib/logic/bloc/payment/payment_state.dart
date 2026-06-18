abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String snapToken;
  final String redirectUrl;
  final String bookingId;
 
  PaymentSuccess({
    required this.snapToken,
    required this.redirectUrl,
    required this.bookingId,
  });
}

class PaymentFailure extends PaymentState {
  final String message;

  PaymentFailure(this.message);
}