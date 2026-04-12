
 
 import 'dart:convert';

import 'package:flutter/material.dart';
 import 'package:http/http.dart' as http;
import 'package:yade_bus/constant/constantes.dart';

import '../widgets/snack_bar.dart';


class ReservationService extends ChangeNotifier {

   
   
  Future<http.Response> addReservation({
  int? idVoyageRetour,
  required int  typeBillet,
  required int idVoyage,
  required String telephone,
  required String passager,
  required int nbPlace,
  String? dateRetour,
  

}) async {


  var addReservation = jsonEncode({
    'idVoyageRetour': idVoyageRetour,
    'typeBillet': typeBillet,
    'idVoyage': idVoyage,
    'passager': passager,
    'telephone': telephone,
    'nbPlace': nbPlace,
    'dateRetour': dateRetour

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


  Future<http.Response> addTicketReservation({
  required int idEvent,
  required String telephone,
  required String passager,
  required int nbPlaces,
  

}) async {


  var addReservation = jsonEncode({
 
    'idEvent': idEvent,
    'passager': passager,
    'telephone': telephone,
    'nbPlaces': nbPlaces,
  });

    final response = await http.post(
      Uri.parse("$apiUrl/tickets.php"),
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

    List<dynamic> reservationList = [];
    List<dynamic> reservationTicketList = [];
    List<dynamic> reservationImageList = [];

   // Méthode pour récupérer tous les reservations par numero de confirmations
   Future<List<dynamic>> fetchAllReservationVoyageByNumConfirmation(String telephone) async {
    final response = await http.get(Uri.parse("$apiUrl/user_voyage_reservation.php?telephone=$telephone"));
    try {
      
   
    if (response.statusCode == 200 || response.statusCode == 201) {
     final String jsonString = utf8.decode(response.bodyBytes);
     List<dynamic> body = json.decode(jsonString);
      reservationList = body; // Affecter directement la liste dynamique
      print(response.body);
      return reservationList;
    } else {
      print('Échec de la requête lors de la récupération des reservations avec le code d\'état: ${response.statusCode}');
      return reservationList = []; // Retourner une liste vide en cas d'erreur
    }
     } catch (e) {
            print('Catch Échec  de la requête lors de la récupération des reservations : ${e.toString()}');

           return reservationList = []; // Retourner une liste vide en cas d'erreur
    }

  }

  
   // Méthode pour récupérer tous les reservations par numero de confirmations
   Future<List<dynamic>> fetchAllReservationTicketByNumConfirmation(String telephone) async {
    final response = await http.get(Uri.parse("$apiUrl/user_events_reservation.php?telephone=$telephone"));
    try {
      
   
    if (response.statusCode == 200 || response.statusCode == 201) {
     final String jsonString = utf8.decode(response.bodyBytes);
     List<dynamic> body = json.decode(jsonString);
      reservationList = body; // Affecter directement la liste dynamique
      print(response.body);
      return reservationList;
    } else {
      print('Échec de la requête lors de la récupération des reservations avec le code d\'état: ${response.statusCode}');
      return reservationList = []; // Retourner une liste vide en cas d'erreur
    }
     } catch (e) {
            print('Catch Échec  de la requête lors de la récupération des reservations : ${e.toString()}');

           return reservationList = []; // Retourner une liste vide en cas d'erreur
    }

  }
   // Méthode pour annuler reservation
   Future<void> annulerReservationVoyage(String numConfirmation) async {
    final response = await http.get(Uri.parse("$apiUrl/annuler_reservation.php?numConfirmation=$numConfirmation"));
    try {
      
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Annulation effectué ave succes: ${response.statusCode}');
    } else {
      print("Échec de la requête lors de l'annulation de la reservation avec le code d\'état: ${response.statusCode}");
    }
     } catch (e) {
            print("Catch Échec  de la requête lors de l'annulation de la reservation : ${e.toString()}");
    }
  }

  
    void applyChange() {
    notifyListeners();
  }

 }
