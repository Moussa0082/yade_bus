
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService extends ChangeNotifier {
  final String baseUrl = 'https://api.orange.com';
  final String token = 'Basic cXNJSlIxalVYUFZaVDhEZXZudGxDVjdncEpYUFQzMDY6YXNVeldGcUZqN3pZa0VjZQ==';

  Future<Map<String, dynamic>> initiatePayment(String amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'merchant_key': 'e9afd305',
        'amount': amount,
        'return_url': 'https://yadebus.com',
        // 'cancel_url': 'https://yadebus.com/webpaydev/cancel',
        // 'notif_url': 'https://yadebus.com/webpaydev/notif',
      }),
    );
     final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
    throw Exception(responseData['message']);
  }    
  }

   void applyChange() {
    notifyListeners();
  }
  
}
