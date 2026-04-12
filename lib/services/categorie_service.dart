

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/models/categorie.dart';


class CategorieProduitService extends ChangeNotifier  {

    List<CategoriesEvent> categorieList = [];
    List<dynamic> categorieVoitureList = [];

     
   Future<List<CategoriesEvent>> fetchCategorie() async {
    final response = await http.get(Uri.parse("$apiUrl/categorie_events.php"));

    if (response.statusCode == 200 || response.statusCode == 201) {
     final String jsonString = utf8.decode(response.bodyBytes);
              List<dynamic> body = json.decode(jsonString);
      categorieList =
          body.map((item) => CategoriesEvent.fromMap(item)).toList();
      print(response.body);
      return categorieList;
    } else {
      
      print('Échec de la requête lors de la recuperation des categories avec le code d\'état: ${response.statusCode}');
      return categorieList = [];
    }
  }

   Future<List<dynamic>> fetchCategoriVoiture() async {
    final response = await http.get(Uri.parse("$apiUrl/categorie_voiture.php"));

    if (response.statusCode == 200 || response.statusCode == 201) {
     final String jsonString = utf8.decode(response.bodyBytes);
              List<dynamic> body = json.decode(jsonString);
      categorieVoitureList = body;
      print(response.body);
      return categorieVoitureList;
    } else {       
      print('Échec de la requête lors de la recuperation des categories de voiture avec le code d\'état: ${response.statusCode}');
      return categorieVoitureList = [];
    } 
  }

   



    void applyChange() {
    notifyListeners();
  }
  

}