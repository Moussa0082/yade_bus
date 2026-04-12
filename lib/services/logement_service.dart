

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yade_bus/constant/constantes.dart';

class LogementService extends ChangeNotifier  {

    List<dynamic> logementList = [];
    List<dynamic> logementImageList = [];

   // Méthode pour récupérer tous les événements
   Future<List<dynamic>> fetchAllLogement() async {
    final response = await http.get(Uri.parse("$apiUrl/list_logement.php"));
    try {
      
   
    if (response.statusCode == 200 || response.statusCode == 201) {
     final String jsonString = utf8.decode(response.bodyBytes);
     List<dynamic> body = json.decode(jsonString);
      logementList = body; // Affecter directement la liste dynamique
      print(response.body);
      return logementList;
    } else {
      print('Échec de la requête lors de la récupération des logements avec le code d\'état: ${response.statusCode}');
      return logementList = []; // Retourner une liste vide en cas d'erreur
    }
     } catch (e) {
            print('Catch Échec  de la requête lors de la récupération des logements : ${e.toString()}');

           return logementList = []; // Retourner une liste vide en cas d'erreur
 
    }

  }

   // Méthode pour récupérer les événements par catégorie
   Future<List<dynamic>> fetchAllImageByLogement(int logementId) async {
  try {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'GET',
      Uri.parse('$apiUrl/logement_img.php?logementId=$logementId'),
    );

    // request.body = json.encode({
    //   "logementId": logementId,
    // });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202 ) {
      String responseBody = await response.stream.bytesToString();
      List<dynamic> body = json.decode(responseBody);
      print("Images récupérées pour logement $logementId : $body");
      return body;
    } else {
      print('Erreur HTTP (${response.statusCode}) pour logement $logementId');
      return [];
    }
  } catch (e) {
    print('Erreur lors de la récupération des images pour logement $logementId : $e');
    return [];
  }
}


   // Méthode pour notifier les changements
    void applyChange() {
    notifyListeners();
  }
}
