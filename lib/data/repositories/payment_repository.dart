import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/payment_response.dart';

class PaymentRepository {
  final _client = Supabase.instance.client; 

  Future<PaymentResponse> createPayment({
    required String villaId,
    required String userId,
    required String tglCheckin,
    required String tglCheckout,
    required int amount,
    required String customerName,
    required String customerEmail,
  }) async {
    final res = await _client.functions.invoke(
      "create-transaction",
      body: {
        "villa_id": villaId,
        "user_id": userId,
        "tgl_checkin": tglCheckin,
        "tgl_checkout": tglCheckout,
        "gross_amount": amount,
        "customer_name": customerName,
        "customer_email": customerEmail,
      },
    );

    if (res.data == null) {
      throw Exception("Empty response from payment server");
    }

    final raw = res.data;
  
    final Map<String, dynamic> data = raw is String
        ? jsonDecode(raw)
        : Map<String, dynamic>.from(raw);

    return PaymentResponse.fromJson(data);
  } 
}