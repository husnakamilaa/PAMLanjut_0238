class PaymentResponse {
  final String snapToken;
  final String redirectUrl;
  final String bookingId;
 
  PaymentResponse({
    required this.snapToken,
    required this.redirectUrl,
    required this.bookingId,
  });
 
  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      snapToken: json['snap_token'],
      redirectUrl: json['redirect_url'],
      bookingId: json['booking_id'],
    );
  }
}