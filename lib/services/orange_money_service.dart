import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart'; // Pour générer un UUID unique
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:yade_bus/controller/nbplace_st_up.dart';
import 'package:yade_bus/widgets/snack_bar.dart';

class OrangeMoneyService extends ChangeNotifier {
  String? accessToken;
  String? payToken;
  String? orderIds;
  double? amounts;
  final StatusController controller = Get.put(StatusController());

  // Méthode pour obtenir le token
  Future<String?> getToken() async {
    var headers = {
      'Authorization':
          'Basic cXNJSlIxalVYUFZaVDhEZXZudGxDVjdncEpYUFQzMDY6YXNVeldGcUZqN3pZa0VjZQ==',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json'
    };

    var request = http.Request(
        'POST', Uri.parse('https://api.orange.com/oauth/v3/token'));
    request.bodyFields = {'grant_type': 'client_credentials'};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = json.decode(await response.stream.bytesToString());
      accessToken = responseData['access_token'];
      payToken = responseData['pay_token'];
      return accessToken;
    } else {
      print(
          'Erreur lors de la récupération du token: ${response.reasonPhrase}');
      return null;
    }
  }

  // Méthode pour générer un orderId unique
  String generateOrderId() {
    var uuid = const Uuid();
    return uuid.v4(); // Génère un UUID unique pour chaque paiement
  }

  Future<String> server_token() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final jsonString =
        await rootBundle.loadString('assets/service_account.json');
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(json.decode(jsonString)),
        scopes);
    final accessserverkey = client.credentials.accessToken.data;
    print("Key server $accessserverkey");
    return accessserverkey;
  }

  // Méthode pour effectuer une demande de paiement
  Future<void> makePayment({
    required String merchantKey,
    required double amount,
    required String returnUrl,
    required String cancelUrl,
    required String notifUrl,
    required String reference,
    String currency = 'XOF',
    String lang = 'fr',
    String productionDate = '',
  }) async {
    // server_token();
    // Vérification que le token a bien été récupéré
    if (accessToken == null) {
      print('Token non disponible, récupération en cours...');
      await getToken();
    }
    controller.amounts = amount;
    amounts = amount;
    controller.accessToken = accessToken;

    if (accessToken != null) {
      var headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      // Générer un orderId unique kjskjkef
      orderIds = generateOrderId();
      controller.orderIds = orderIds;

      var request = http.Request(
          'POST',
          Uri.parse(
              'https://api.orange.com/orange-money-webpay/ml/v1/webpayment'));
      request.body = json.encode({
        "merchant_key": merchantKey,
        "currency": currency,
        "order_id": orderIds,
        "amount": amount,
        "return_url": returnUrl,
        "cancel_url": cancelUrl,
        "notif_url": notifUrl,
        "lang": lang,
        "productionDate": productionDate,
        "reference": reference,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(await response.stream.bytesToString());
        print('Paiement réussi: ${responseData['message']}');

        // Ouvrir l'URL de paiement
        String paymentUrl = responseData['payment_url'];
        controller.payToken = responseData['pay_token'];

        if (await canLaunchUrl(Uri.parse(paymentUrl))) {
          await launchUrl(
              Uri.parse(paymentUrl)); // Ouvre l'URL dans le navigateur
        } else {
          Snack.error(
              titre: "Erreur",
              message: "Une erreur s'est produite veuillez reessayer");
          print('Impossible d\'ouvrir l\'URL de paiement');
        }
      } else {
        print('Erreur lors du paiement: ${response.reasonPhrase}');
      }
    } else {
      print('Impossible d\'obtenir le token');
    }
  }

  // Méthode pour envoyer une notification push
  Future<void> sendPushNotification(
      String token, String title, String body) async {
    try {
      var url = Uri.parse(
          'https://fcm.googleapis.com/v1/projects/yade-app/messages:send');

      // Créez les données de la requête
      // Obtenez le jeton OAuth 2.0

      var notificationData = {
        "message": {
          'data': {
            'via': 'FlutterFire Cloud Messaging!!!',
            'type': 'chat',
          },
          "token": token,
          "notification": {"body": body, "title": title}
        },
      };
      String accesTok = await server_token();

      // Créez les headers pour l'API FCM
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accesTok',
      };

      // Envoyez la requête POST à l'API FCM
      var response = await http.post(
        url,
        headers: headers,
        body: json.encode(notificationData),
      );
      print("header ${headers.toString()}");
      print("body ${notificationData.toString()}");

      // Vérifiez si la notification a été envoyée avec succès
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Notification push envoyée avec succès.');
      } else {
        print(
            'Erreur lors de l\'envoi de la notification push : ${response.statusCode}');
        print(
            'Erreur lors de l\'envoi de la notification push body : ${response.body}');
      }
    } catch (e) {
      print('Exception lors de l\'envoi de la notification push : $e');
    }
  }

  Future<bool?> checkPaymentStatus(String? accessTokens, String? payTokens,
      String? orderIdss, double? amountss) async {
    var headers = {
      'Authorization': 'Bearer $accessTokens',
      'Content-Type': 'application/json',
    };
    String statut;
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://api.orange.com/orange-money-webpay/ml/v1/transactionstatus'));
    request.body = json.encode({
      "amount": amountss,
      "pay_token": payTokens,
      "order_id": orderIdss,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    final _messaging = FirebaseMessaging.instance;
    final token = await _messaging.getToken();
    // print('Header: ${request.headers}');
    // print('Body: ${request.body}');
    bool _notificationSent = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseData = json.decode(await response.stream.bytesToString());
      print('Paiement etat r back end message: ${responseData['message']}');
      print('Paiement etat r back end statut: ${responseData['status']}');

      statut = responseData['status'];
      if (statut.endsWith("SUCCESS") || statut.endsWith("SUCCES")) {
        // Paiement réussi, envoyer une notification push
        await sendPushNotification(token!, "Paiement réussi",
            "Votre paiement a été effectué avec succès.");

        return true;
      } else if (statut.endsWith("INITIATED")) {
        print('Paiement initie back end message: ${responseData['message']}');
        print('Paiement initie back end statut: ${responseData['status']}');
        return false;
      } else if (statut.endsWith("FAILED")) {
        print(
            'Paiement non reussi back end message: ${responseData['message']}');
        print('Paiement non reussi back end statut: ${responseData['status']}');
        await sendPushNotification(token!, "Paiement échoué",
            "Votre paiement n'a pas pu être traité.");
        return false;
      } else {
        print(
            'Paiement non reussi back end message: ${responseData['message']}');
        print('Paiement non reussi back end statut: ${responseData['status']}');

        await sendPushNotification(token!, "Paiement échoué",
            "Votre paiement n'a pas pu être traité.");

        print('Impossible de verifier le statut du paiement');
        return false;
      }
    } else {
      Snack.error(
          titre: "Erreur",
          message: "Une erreur s'est produite veuillez reessayer");
      // print(
      //     'Erreur lors de la verification du status du paiement: ${response.reasonPhrase}');
      // await sendPushNotification(
      //     token!, "Paiement échoué", "Votre paiement n'a pas pu être traité.");
      return false;
    }
  }
}
