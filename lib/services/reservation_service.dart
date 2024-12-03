
 
 import 'dart:convert';

import 'package:flutter/material.dart';
 import 'package:http/http.dart' as http;
import 'package:yade_bus/constant/constantes.dart';

import '../widgets/snack_bar.dart';


class ReservationService extends ChangeNotifier {

   
   
  Future<http.Response> addReservation({
  required int idVoyage,
  required String telephone,
  required String passager,
  required int nbPlace,

}) async {


  var addReservation = jsonEncode({
    'idVoyage': idVoyage,
    'passager': passager,
    'telephone': telephone,
    'nbPlace': nbPlace

  });

    final response = await http.post(
      Uri.parse("$apiUrl/reservation.php"),
      headers: {'Content-Type': 'application/json'},
      body: addReservation,
    );
  try {

    print('Request Body: ${addReservation.toString()}');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print("Objet envoyé avec succès");
     
    } else {
    print('Erreur lors de l\'ajout: ${response.statusCode}  body ${response.body} ');
    }
  } catch (e) {
    print('Erreur lors de l\'ajout: $e');
  }
  return response;
}

  
    void applyChange() {
    notifyListeners();
  }

 }
