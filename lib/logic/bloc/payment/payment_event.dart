abstract class PaymentEvent {}

class CreatePayment extends PaymentEvent {
  final String villaId;
  final String userId;
  final String tglCheckin;
  final String tglCheckout;
  final int amount;
  final String customerName;
  final String customerEmail;
 
  CreatePayment({
    required this.villaId,
    required this.userId,
    required this.tglCheckin,
    required this.tglCheckout,
    required this.amount,
    required this.customerName,
    required this.customerEmail,
  });
}