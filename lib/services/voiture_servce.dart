

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yade_bus/constant/constantes.dart';

class VoitureService extends ChangeNotifier  {

    List<dynamic> voyageList = [];
    List<dynamic> vehiculeImageList = [];

   // Méthode pour récupérer tous les vehicules
   Future<List<dynamic>> fetchAllvehicule() async {
    final response = await http.get(Uri.parse("$apiUrl/list_vehicule.php"));
    try {
      
   
    if (response.statusCode == 200 || response.statusCode == 201) {
     final String jsonString = utf8.decode(response.bodyBytes);
     List<dynamic> body = json.decode(jsonString);
      voyageList = body; // Affecter directement la liste dynamique
      print(response.body);
      return voyageList;
    } else {
      print('Échec de la requête lors de la récupération des logements avec le code d\'état: ${response.statusCode}');
      return voyageList = []; // Retourner une liste vide en cas d'erreur
    }
     } catch (e) {
            print('Catch Échec  de la requête lors de la récupération des logements : ${e.toString()}');

           return voyageList = []; // Retourner une liste vide en cas d'erreur
 
    }

  }

   // Méthode pour récupérer les image par vehicules
   Future<List<dynamic>> fetchAllImageByVehicule(int carId) async {
  try {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'GET',
      Uri.parse('$apiUrl/vehicule_img.php?carId=$carId'),
    );

    // request.body = json.encode({
    //   "carId": carId,
    // });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202 ) {
      String responseBody = await response.stream.bytesToString();
      List<dynamic> body = json.decode(responseBody);
      print("Images récupérées pour vehicule $carId : $body");
      return body;
    } else {
      print('Erreur HTTP (${response.statusCode}) pour vehicule $carId');
      return [];
    }
  } catch (e) {
    print('Erreur lors de la récupération des images pour vehicule $carId : $e');
    return [];
  }
}


   Future<List<dynamic>> fetchAllVehiculeByType(String taille) async {
  try {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'GET',
      Uri.parse('$apiUrl/list_vehicule_par_cat.php?taille=$taille'),
    );

    // request.body = json.encode({
    //   "carId": carId,
    // });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202 ) {
      String responseBody = await response.stream.bytesToString();
      List<dynamic> body = json.decode(responseBody);
      print("Voyage récupérées par taille $taille : $body");
      return body;
    } else {
      print('Erreur HTTP (${response.statusCode}) pour vehicule $taille');
      return [];
    }
  } catch (e) {
    print('Erreur lors de la récupération des  vehicule pour la tailler $taille : $e');
    return [];
  }
}


   // Méthode pour notifier les changements
    void applyChange() {
    notifyListeners();
  }
}
