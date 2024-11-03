import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yade_bus/screens/voyage.dart';


 class VoyageForm extends StatefulWidget {
  const VoyageForm({super.key});

  @override
  State<VoyageForm> createState() => _VoyageFormState();
}

class _VoyageFormState extends State<VoyageForm> {



    TextEditingController dateController = TextEditingController();
          final GlobalKey<FormState> formkey = GlobalKey<FormState>();
   
    String? idDepart;
    String? idDest;
     bool isLoading = true;
     int? id;

  @override
  void initState() {
    super.initState();
    fetchZoneDepart();
  }

    List<Map<String, dynamic>> departList = []; // Liste pour stocker les niveaux avec leurs détails
    List<Map<String, dynamic>> destinationList = []; // Liste pour stocker les niveaux avec leurs détails

 Future<void> fetchZoneDepart() async {
  try {
    final response = await http.get(Uri.parse('http://192.168.63.1/php/yade_back_end/zone_depart.php'));
    if (response.statusCode == 200) {
      List<dynamic> levelsJson = json.decode(response.body);
      departList = levelsJson.cast<Map<String, dynamic>>(); // Convertir en liste de maps
    } else {
      print("Erreur de statut de réponse: ${response.statusCode}");
    }
  } catch (e) {
    // print("Erreur lors du chargement des zones de départ: $e");
    print("Error fetching data: $e");

  }
}

     Future<void> fetchZoneDestination(id) async {
  try {
    final response = await http.get(Uri.parse("http://192.168.63.1/php/yade_back_end/zone_destination.php?idDepart=$idDepart"));
    if (response.statusCode == 200) {
      List<dynamic> levelsJson = json.decode(response.body);
      destinationList = levelsJson.cast<Map<String, dynamic>>(); // Convertir en liste de maps
    } else {
      print("Erreur de statut de réponse: ${response.statusCode}");
    }
  } catch (e) {
    print("Erreur lors du chargement des zones de destination: $e");
  }
  }

  // Future<void> fetchLevels() async {
  //   try {
  //     final response = await http.get(Uri.parse('http://192.168.63.1/php/yade_back_end/zone_depart.php'));
  //     if (response.statusCode == 200) {
  //       List<dynamic> levels = json.decode(response.body);
  //       departList = List<String>.from(levels);
  //     }
  //   } catch (e) {
  //     print("Erreur lors du chargement des zone de départ: $e");
  //   }
  // }
    String? selectedDeparture; // Stocke la valeur sélectionnée



  Future<void> _selectDate(BuildContext context) async {
  DateTime currentDate = DateTime.now();
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: currentDate, // Date initiale
    firstDate: currentDate,   // Date minimale (date du jour)
    lastDate: DateTime(2100), // Date maximale, vous pouvez la changer
    helpText: 'Sélectionner une date ', // Texte d'aide
    cancelText: 'Annuler',
    confirmText: 'OK',
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light(), // Ajustez le thème si nécessaire
        child: child!,
      );
    },
  );

  if (picked != null && picked != currentDate) {
    // Si une date a été sélectionnée, formater le mois et le jour avec deux chiffres
    String formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

    // Afficher la date formatée dans le TextFormField
    dateController.text = formattedDate;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png', // Remplace par le chemin correct de ton logo
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  
                  // Titre
                  const Text(
                    'Trouvez votre voyage ici',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  
                  // Champ de texte pour le départ avec icône
                  
           SingleChildScrollView(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 // isLoading
                 // ? const Center(child: CircularProgressIndicator())
                 // :
  Autocomplete<String>(
  optionsBuilder: (TextEditingValue textEditingValue) {
    if (textEditingValue.text.isEmpty) {
      return const Iterable<String>.empty();
    }

    // Filtrer les résultats en fonction de l'entrée de l'utilisateur
    final filteredList = departList.where((element) =>
        element['libelle'] != null &&
        element['libelle'].toLowerCase().contains(textEditingValue.text.toLowerCase()));

    // Vérifier si aucun résultat ne correspond et retourner un message personnalisé
    if (filteredList.isEmpty) {
      return ["Aucun lieu de départ trouvé"];
    }

    // Transformer les résultats en Iterable<String> pour l'affichage
    return filteredList.map((element) => element['libelle']);
  },
  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.location_on, color: Colors.blueGrey[400]),
        hintText: "Sélectionner un départ",
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  },
  optionsViewBuilder: (context, onSelected, options) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // Limiter la largeur
          constraints: BoxConstraints(
            maxHeight: 200, // Limiter la hauteur
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
              ),
            ],
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options.elementAt(index);
              return ListTile(
                title: Text(option),
                onTap: () => onSelected(option),
              );
            },
          ),
        ),
      ),
    );
  },
  onSelected: (String selection) {
     // Recherche de l'idLevel associé au libelle sélectionné
        final selectedElement = departList.firstWhere(
      (element) => element['libelle'] == selection,
      orElse: () => <String, dynamic>{}, // Return an empty map instead of null
    );

    if (selectedElement.isNotEmpty) {
      idDepart = selectedElement['idLevel'].toString();
      id = int.tryParse(idDepart!); // Assign `id` by parsing `idDepart`
      print('Vous avez sélectionné: $selection, idLevel associé: $idDepart');
      fetchZoneDestination(id!);
    } else {
      print('Aucun idLevel trouvé pour le libelle sélectionné.');
    }
   
    print('Vous avez sélectionné: $selection');
  },
),



               ],
             ),
           ),
      
                  const SizedBox(height: 20),
                  
                  // Champ de texte pour la destination avec icône
                              SingleChildScrollView(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 // isLoading
                 // ? const Center(child: CircularProgressIndicator())
                 // :
  Autocomplete<String>(
  optionsBuilder: (TextEditingValue textEditingValue) {
    if (textEditingValue.text.isEmpty) {
      return const Iterable<String>.empty();
    }

    // Filtrer les résultats en fonction de l'entrée de l'utilisateur
    final filteredList = destinationList.where((element) =>
        element['libelle'] != null &&
        element['libelle'].toLowerCase().contains(textEditingValue.text.toLowerCase()));

    // Vérifier si aucun résultat ne correspond et retourner un message personnalisé
    if (filteredList.isEmpty) {
      return ["Aucun lieu de destination trouvé"];
    }

    // Transformer les résultats en Iterable<String> pour l'affichage
    return filteredList.map((element) => element['libelle']);
  },
  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.location_city, color: Colors.blueGrey[400]),
        hintText: "Sélectionner un destination",
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  },
  optionsViewBuilder: (context, onSelected, options) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // Limiter la largeur
          constraints: BoxConstraints(
            maxHeight: 200, // Limiter la hauteur
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
              ),
            ],
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options.elementAt(index);
              return ListTile(
                title: Text(option),
                onTap: () => onSelected(option),
              );
            },
          ),
        ),
      ),
    );
  },
  onSelected: (String selection) {
     // Recherche de l'idLevel associé au libelle sélectionné
        final selectedElement = destinationList.firstWhere(
      (element) => element['libelle'] == selection,
      orElse: () => <String, dynamic>{}, // Return an empty map instead of null
    );

    if (selectedElement.isNotEmpty) {
      idDest = selectedElement['idLevel'].toString();
      id = int.tryParse(idDest!); // Assign `id` by parsing `idDepart`
      print('Vous avez sélectionné: $selection, idLevel associé: $idDest');
    } else {
      print('Aucun idLevel trouvé pour le libelle sélectionné.');
    }
   
    print('Vous avez sélectionné: $selection');
  },
),



               ],
             ),
           ),
                  const SizedBox(height: 20),
                  
                  // Champ de texte pour la date de départ avec icône
                 GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today,
                                color: Colors.blueGrey[400]),
                            hintText:  "Sélectionner une date",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veuillez choisir une date";
                      } else {
                        return null;
                      }
                      }
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  
                  // Bouton de recherche
                  ElevatedButton(
                    onPressed: () {
                      // Action à effectuer lors de l'appui sur le bouton
                      if(formkey.currentState!.validate()){
                        Get.to( const VoyageScreen(), transition: Transition.rightToLeftWithFade);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.red, // Couleur rouge comme sur l'image
                    ),
                    child: const Text(
                      'RECHERCHER UN BILLET',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
