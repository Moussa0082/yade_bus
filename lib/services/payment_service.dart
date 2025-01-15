import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yade_bus/widgets/snack_bar.dart';

class PaymentService {
  Future<Map<String, dynamic>> processPayment({
    required int amount,
    required String order_id,
    required String productionDate,
  }) async {
    // var paymentData = jsonEncode({
    //   "merchant_key": "e9afd305",
    //   "currency": "XOF",
    //   "order_id": orderId,
    //   "amount": amount,
    //   "productionDate": productionDate,
    //   "return_url": "https://yadebus.com",
    //   "cancel_url": "ttps://yadebus.com/webpaydev/cancel",
    //   "notif_url": "https://yadebus.com/webpaydev/notif",
    //   "lang": "fr",
    //   "reference": "ref-xyz.456"
    // });
    // Token déjà encodé en base64, donc pas besoin de le réencoder
    String token =
        'Basic cXNJSlIxalVYUFZaVDhEZXZudGxDVjdncEpYUFQzMDY6YXNVeldGcUZqN3pZa0VjZQ==';
   String base64Token = base64Encode(utf8.encode(token));

    // Définir l'URL complète de l'API (inclure http:// ou https://)
    var url = Uri.parse("https://api.orange.com/orange-money-webpay/ml/v1");

    // Création des données de paiement (paymentData)
    var paymentData = jsonEncode({
      'merchant_key': 'e8b7be44',
      'currency': 'XAF',
      'order_id': order_id,
      'amount': amount,
      'productionDate': productionDate,
      "return_url": "https://yadebus.com",
      "cancel_url": "ttps://yadebus.com/webpaydev/cancel",
      "notif_url": "https://yadebus.com/webpaydev/notif",
      'lang': 'fr',
      'reference': 'ref-xyz.456'
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': token, 
          'Content-Type': 'application/json',
        },
        body: paymentData,
      );

      print('Request Body: ${paymentData.toString()}');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        // Traitez la réponse 201 - paiement initié avec succès
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 201) {
          print(
              "Paiement réussi, URL de paiement: ${responseData['payment_url']}");
        Snack.success(titre: 'Succes', message: '${response.body}');

          return {
            "status": "success",
            "pay_token": responseData['pay_token'],
            "payment_url": responseData['payment_url'],
            "notif_token": responseData['notif_token']
          };
        }
      } else {
        print('Erreur lors du paiement: ${response.body}');
        Snack.error(titre: 'Erreur', message: '${response.body}');
        return {"status": "failed", "message": "Erreur lors du paiement"};
      }
    } catch (e) {
      print('Erreur lors de la requête: $e');
      return {"status": "failed", "message": "Erreur de connexion"};
    }

    return {"status": "failed", "message": "Erreur inconnue"};
  }
}
