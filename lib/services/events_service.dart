

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:yade_bus/constant/constantes.dart';
// import 'package:yade_bus/models/events_city.dart';

// import '../models/events.dart';


// class EventsService extends ChangeNotifier  {

//     List<Evenement> eventsList = [];
//     List<EventsVilles> eventsCityList = [];


//    Future<List<Evenement>> fetchAllEvents() async {
//     final response = await http.get(Uri.parse("$apiUrl/events.php"));

//     if (response.statusCode == 200 || response.statusCode == 201) {
//      final String jsonString = utf8.decode(response.bodyBytes);
//               List<dynamic> body = json.decode(jsonString);
//       eventsList =
//           body.map((item) => Evenement.fromMap(item)).toList();
//       print(response.body);
//       return eventsList;
//     } else {
      
//       print('Échec de la requête lors de la recuperation des evenement avec le code d\'état: ${response.statusCode}');
//       return eventsList = [];
//     }
//   }

//    Future<List<Evenement>> fetchAllEventsByCategorie(String idCategory) async {
//     final response = await http.get(Uri.parse("$apiUrl/events_by_categorie.php?$idCategory"));

//     if (response.statusCode == 200 || response.statusCode == 201) {
//      final String jsonString = utf8.decode(response.bodyBytes);
//               List<dynamic> body = json.decode(jsonString);
//       eventsList =
//           body.map((item) => Evenement.fromMap(item)).toList();
//       print(response.body);
//       return eventsList;
//     } else {
      
//       print('Échec de la requête lors de la recuperation des evenement par categorie avec le code d\'état: ${response.statusCode}');
//       return eventsList = [];
//     }
//   }

//    Future<List<dynamic>> fetchAllCityByEvents(String idEvent) async {
//     final response = await http.get(Uri.parse("$apiUrl/events_ville.php?$idEvent"));

//     if (response.statusCode == 200 || response.statusCode == 201) {
//      final String jsonString = utf8.decode(response.bodyBytes);
//               List<dynamic> body = json.decode(jsonString);
//       eventsCityList =
//           body.map((item) => EventsVilles.fromMap(item)).toList();
//       print(response.body);
//       return eventsCityList;
//     } else {
      
//       print('Échec de la requête lors de la recuperation des ville par evenement avec le code d\'état: ${response.statusCode}');
//       return eventsCityList = [];
//     }
//   }

//     void applyChange() {
//     notifyListeners();
//   }
  

// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yade_bus/constant/constantes.dart';

class EventsService extends ChangeNotifier  {

    List<dynamic> eventsList = [];
    List<dynamic> eventsCityList = [];

   // Méthode pour récupérer tous les événements
   Future<List<dynamic>> fetchAllEvents() async {
    final response = await http.get(Uri.parse("$apiUrl/events.php"));

    if (response.statusCode == 200 || response.statusCode == 201) {
     final String jsonString = utf8.decode(response.bodyBytes);
     List<dynamic> body = json.decode(jsonString);
      eventsList = body; // Affecter directement la liste dynamique
      print(response.body);
      return eventsList;
    } else {
      print('Échec de la requête lors de la récupération des événements avec le code d\'état: ${response.statusCode}');
      return eventsList = []; // Retourner une liste vide en cas d'erreur
    }
  }

   // Méthode pour récupérer les événements par catégorie
   Future<List<dynamic>> fetchAllEventsByCategorie(String idCategory) async {
    final response = await http.get(Uri.parse("$apiUrl/events_by_categorie.php?$idCategory"));

    if (response.statusCode == 200 || response.statusCode == 201) {
     final String jsonString = utf8.decode(response.bodyBytes);
     List<dynamic> body = json.decode(jsonString);
      eventsList = body; // Affecter directement la liste dynamique
      print(response.body);
      return eventsList;
    } else {
      print('Échec de la requête lors de la récupération des événements par catégorie avec le code d\'état: ${response.statusCode}');
      return eventsList = []; // Retourner une liste vide en cas d'erreur
    }
  }

   // Méthode pour récupérer les villes associées à un événement
   Future<List<dynamic>> fetchAllEventsbyCity(String lieu) async {
    final response = await http.get(Uri.parse("$apiUrl/events_by_ville.php?$lieu"));

    if (response.statusCode == 200 || response.statusCode == 201) {
     final String jsonString = utf8.decode(response.bodyBytes);
     List<dynamic> body = json.decode(jsonString);
      eventsCityList = body; // Affecter directement la liste dynamique
      print(response.body);
      return eventsCityList;
    } else {
      print('Échec de la requête lors de la récupération des   événement  par ville avec le code d\'état: ${response.statusCode}');
      return eventsCityList = []; // Retourner une liste vide en cas d'erreur
    }
  }

//   Future<List<dynamic>> fetchAllCityByCategory(int idCategory) async {
//   final response = await http.get(Uri.parse("$apiUrl/events_by_ville.php?$idCategory"));

//   if (response.statusCode == 200 || response.statusCode == 201) {
//     final String jsonString = utf8.decode(response.bodyBytes);
//     List<dynamic> body = json.decode(jsonString); // La réponse est une liste
//     print(response.body);

//     // Vérifier si la réponse est une liste et l'affecter à eventsCityList
//       eventsCityList = body; // Affecter directement la liste dynamique
    
//     return eventsCityList;
//   } else {
//     print('Échec de la requête lors de la récupération des villes par événement avec le code d\'état: ${response.statusCode}');
//     return [];
//   }
// }
Future<List<dynamic>> fetchAllCityByCategory(int idCategory) async {
  final response = await http.get(Uri.parse("$apiUrl/events_ville_by_categorie.php?$idCategory"));

  if (response.statusCode == 200 || response.statusCode == 201) {
    final String jsonString = utf8.decode(response.bodyBytes);
    dynamic body = json.decode(jsonString); // La réponse peut être un Map ou une List

    print(response.body);
        // Si la réponse est simplement une Map sans clé 'data', essayez de traiter la liste de manière différente
        eventsCityList = body; // Par défaut, envelopper la Map dans une liste

    return eventsCityList;
  } else {
    print('Échec de la requête lors de la récupération des villes par événement avec le code d\'état: ${response.statusCode}');
    return [];
  }
}



   // Méthode pour notifier les changements
    void applyChange() {
    notifyListeners();
  }
}
