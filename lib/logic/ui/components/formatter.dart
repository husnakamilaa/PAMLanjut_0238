import 'package:flutter/services.dart';

class PriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isNotEmpty) {
      digitsOnly = int.parse(digitsOnly).toString(); // hapus leading zero
    }
    return newValue.copyWith(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  final int maxDigits;
  PhoneInputFormatter({this.maxDigits = 13});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      digitsOnly = '08';
    } else if (!digitsOnly.startsWith('0')) {
      digitsOnly = '08$digitsOnly';
    }

    if (digitsOnly.length > maxDigits) {
      digitsOnly = digitsOnly.substring(0, maxDigits);
    }

    return newValue.copyWith(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

class AppValidators {
  static String? required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label wajib diisi';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email wajib diisi';
    final gmailRegex = RegExp(r'^[\w.+-]+@gmail\.com$', caseSensitive: false);
    if (!gmailRegex.hasMatch(value.trim())) {
      return 'Email harus berformat @gmail.com';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) return 'Password minimal 6 karakter';
    return null;
  }
}