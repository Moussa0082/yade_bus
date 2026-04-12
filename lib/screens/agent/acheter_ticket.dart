import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yade_bus/controller/deeplink_controller.dart';
import 'package:yade_bus/screens/agent/agent_voyage_reserv.dart';

import '../../constant/constantes.dart';
import '../voyage.dart';

class AcheterTicketPage extends StatefulWidget {
  @override
  _AcheterTicketPageState createState() => _AcheterTicketPageState();
}

class _AcheterTicketPageState extends State<AcheterTicketPage> {
 TextEditingController dateAllerController = TextEditingController();
  TextEditingController dateRetourController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? idDepart;
  String? nomDepart;
  String? nomDest;
  String? idDest;
  bool isLoading = true;
  int? id;
  int? idD;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  String? detectedCountryCode;
  String? _currentAddress;
  String? voyageType = 'allerSimple'; // Valeur par défaut
  DateTime? retourDate;

  // Méthode pour sélectionner une date
  Future<void> _selectDateRetour(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != retourDate) {
      setState(() {
        retourDate = picked;
        dateRetourController.text =
            "${retourDate!.toLocal()}".split(' ')[0]; // Formater la date
      });
    }
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.isoCountryCode}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
        detectedCountryCode = place.isoCountryCode!;

        print(_currentAddress);
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    fetchZoneDepart();
  }

  List<Map<String, dynamic>> departList =
      []; // Liste pour stocker les niveaux avec leurs détails
  List<Map<String, dynamic>> destinationList =
      []; // Liste pour stocker les niveaux avec leurs détails

  Future<void> fetchZoneDepart() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/zone_depart.php'));
      if (response.statusCode == 200) {
        List<dynamic> levelsJson = json.decode(response.body);
        departList = levelsJson
            .cast<Map<String, dynamic>>(); // Convertir en liste de maps
        print('Data: ${response.body}');
      } else {
        print("Erreur de statut de réponse: ${response.statusCode}");
      }
      print('Data: ${response.body}');
    } catch (e) {
      // print("Erreur lors du chargement des zones de départ: $e");
      print("Error fetching data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchZoneDestination(id) async {
    try {
      final response = await http
          .get(Uri.parse("$apiUrl/zone_destination.php?idDepart=$id"));
      if (response.statusCode == 200) {
        List<dynamic> levelsJson = json.decode(response.body);
        destinationList = levelsJson
            .cast<Map<String, dynamic>>(); // Convertir en liste de maps
        return destinationList; // Return the updated destinationList
      } else {
        print("Erreur de statut de réponse: ${response.statusCode}");
        return []; // Return an empty list in case of error
      }
    } catch (e) {
      print("Erreur lors du chargement des zones de destination: $e");
      return []; // Return an empty list in case of exception
    }
  }

  // Future<void> fetchLevels() async {
  //   try {
  //     final response = await http.get(Uri.parse('http://api.yadebus.com/zone_depart.php'));
  //     if (response.statusCode == 200) {
  //       List<dynamic> levels = json.decode(response.body);
  //       departList = List<String>.from(levels);
  //     }
  //   } catch (e) {
  //     print("Erreur lors du chargement des zone de départ: $e");
  //   }
  // }
  String? selectedDeparture; // Stocke la valeur sélectionnée

  Future<void> _selectDateAller(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate, // Date initiale
      firstDate: currentDate, // Date minimale (date du jour)
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

    if (picked != currentDate && picked != null) {
      // Si une date a été sélectionnée, formater le mois et le jour avec deux chiffres
      String formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

      // Afficher la date formatée dans le TextFormField
      dateAllerController.text = formattedDate;
    }
  }

  final List<Map<String, String>> imageList = [
    {'image': 'assets/images/colis-im.jpeg', 'name': 'Colis'},
    {'image': 'assets/images/div-default.jpg', 'name': 'Divertissement'},
    {'image': 'assets/images/rservation.jpg', 'name': 'Réservation'},
    {'image': 'assets/images/gr-p.png', 'name': 'Groupes'},
    {'image': 'assets/images/voyage-vol.jpeg', 'name': 'Voyage/Vol'},
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(DeepLinkController());
    // if (controller.returnLink != null)
    //   Text('Lien de retour: ${controller.returnLink}');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                  height: 200,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  "assets/images/image_r3.png"),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Card(
                  color: Colors.white,
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16),
                          const Text(
                            'Trouvez votre voyage ici',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          // Choix du type de voyage (Aller simple ou Aller retour)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'allerSimple',
                                      groupValue: voyageType,
                                      onChanged: (String? value) {
                                        setState(() {
                                          voyageType = value;
                                        });
                                      },
                                    ),
                                    const Text('Aller simple'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'allerRetour',
                                      groupValue: voyageType,
                                      onChanged: (String? value) {
                                        setState(() {
                                          voyageType = value;
                                        });
                                      },
                                    ),
                                    const Text('Aller retour'),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // isLoading
                                // ? const Center(child: CircularProgressIndicator())
                                // :
                                Autocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return departList.map((element) =>
                                          element['libelle'] as String);
                                    }

                                    // Filtrer les résultats en fonction de l'entrée de l'utilisateur
                                    final filteredList = departList.where(
                                        (element) =>
                                            element['libelle'] != null &&
                                            element['libelle']
                                                .toLowerCase()
                                                .contains(textEditingValue.text
                                                    .toLowerCase()));

                                    // Vérifier si aucun résultat ne correspond et retourner un message personnalisé
                                    if (filteredList.isEmpty) {
                                      return ["Aucun lieu de départ trouvé"];
                                    }

                                    // Transformer les résultats en Iterable<String> pour l'affichage
                                    return filteredList
                                        .map((element) => element['libelle']);
                                  },
                                  fieldViewBuilder: (context, controller,
                                      focusNode, onFieldSubmitted) {
                                    return TextFormField(
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return "Veuillez choisir une ville de départ";
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: controller,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.location_on,
                                            color: Colors.blueGrey[400]),
                                        hintText: "Sélectionner un départ",
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    );
                                  },
                                  optionsViewBuilder:
                                      (context, onSelected, options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9, // Limiter la largeur
                                          constraints: BoxConstraints(
                                            maxHeight:
                                                200, // Limiter la hauteur
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                              final option =
                                                  options.elementAt(index);
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
                                    final selectedElement =
                                        departList.firstWhere(
                                      (element) =>
                                          element['libelle'] == selection,
                                      orElse: () => <String,
                                          dynamic>{}, // Return an empty map instead of null
                                    );

                                    if (selectedElement.isNotEmpty) {
                                      idDepart =
                                          selectedElement['idLevel'].toString();
                                      setState(() {
                                        nomDepart = selection;
                                        id = int.tryParse(
                                            idDepart!); // Assign `id` by parsing `idDepart`
                                        destinationList =
                                            []; // Effacer la liste actuelle des destinations avant de charger de nouvelles données
                                      });
                                      print(
                                          'Vous avez sélectionné: $selection, idLevel associé: $idDepart');
                                      // Fetch new destinations based on the selected `idDepart`
                                      fetchZoneDestination(id!)
                                          .then((newDestinations) {
                                        setState(() {
                                          destinationList =
                                              newDestinations; // Mettez à jour la liste des destinations
                                          print("new liste" +
                                              destinationList.toString());
                                        });
                                      });
                                    } else {
                                      print(
                                          'Aucun idLevel trouvé pour le libelle sélectionné.');
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
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                // isLoading
                                // ? const Center(child: CircularProgressIndicator())
                                // :
                                Autocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      // Retourne tous les libellés si aucun texte n'est saisi
                                      return destinationList.map((element) =>
                                          element['libelle'] as String);
                                    }

                                    // Filtrer les résultats en fonction de l'entrée de l'utilisateur
                                    final filteredList = destinationList.where(
                                        (element) =>
                                            element['libelle'] != null &&
                                            element['libelle']
                                                .toLowerCase()
                                                .contains(textEditingValue.text
                                                    .toLowerCase()));

                                    // Vérifier si aucun résultat ne correspond et retourner un message personnalisé
                                    if (filteredList.isEmpty) {
                                      return [
                                        "Aucun lieu de destination trouvé"
                                      ];
                                    }

                                    // Transformer les résultats en Iterable<String> pour l'affichage
                                    return filteredList
                                        .map((element) => element['libelle']);
                                  },
                                  fieldViewBuilder: (context, controller,
                                      focusNode, onFieldSubmitted) {
                                    return TextFormField(
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return "Veuillez choisir une ville de destination";
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: controller,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.location_city,
                                            color: Colors.blueGrey[400]),
                                        hintText: "Sélectionner un destination",
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    );
                                  },
                                  optionsViewBuilder:
                                      (context, onSelected, options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9, // Limiter la largeur
                                          constraints: BoxConstraints(
                                            maxHeight:
                                                200, // Limiter la hauteur
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                              final option =
                                                  options.elementAt(index);
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
                                    final selectedElement =
                                        destinationList.firstWhere(
                                      (element) =>
                                          element['libelle'] == selection,
                                      orElse: () => <String,
                                          dynamic>{}, // Return an empty map instead of null
                                    );

                                    if (selectedElement.isNotEmpty) {
                                      setState(() {
                                        nomDest = selection;
                                      });
                                      idDest =
                                          selectedElement['idLevel'].toString();
                                      idD = int.tryParse(
                                          idDest!); // Assign `id` by parsing `idDepart`
                                      print(
                                          'Vous avez sélectionné: $selection, idLevel associé: $idDest');
                                    } else {
                                      print(
                                          'Aucun idLevel trouvé pour le libelle sélectionné.');
                                    }

                                    print('Vous avez sélectionné: $selection');
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Champ de texte pour la date de départ
                          GestureDetector(
                            onTap: () => _selectDateAller(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: dateAllerController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.calendar_today,
                                      color: Colors.blueGrey[400]),
                                  hintText: "Sélectionner une date de départ",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Afficher la date de retour si "Aller retour" est sélectionné
                          if (voyageType == 'allerRetour')
                            GestureDetector(
                              onTap: () => _selectDateRetour(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: dateRetourController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.calendar_today,
                                        color: Colors.blueGrey[400]),
                                    hintText: "Sélectionner une date de retour",
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 5),

                          // Bouton de recherche
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Action à effectuer lors de l'appui sur le bouton
                                  if (formkey.currentState!.validate()) {
                                    Get.to(
                                        VoyageScreen(
                                            // Passer les données au screen de destination
                                            idDepart: id,
                                          idDest: idD,
                                          dateDepart: dateAllerController.text,
                                          dateRetour: dateRetourController.text,
                                          nomDepart: nomDepart!,
                                          nomDest: nomDest!,
                                          idVoyageRetour: idD,
                                          type: voyageType == 'allerSimple' ? 0 : 1,
                                            ),
                                        transition:
                                            Transition.rightToLeftWithFade);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text(
                                  'RECHERCHER UN BILLET',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}