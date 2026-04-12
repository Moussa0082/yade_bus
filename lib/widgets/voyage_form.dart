import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/controller/deeplink_controller.dart';
import 'package:yade_bus/screens/login/login.dart';
import 'package:yade_bus/screens/voyage.dart';
import 'package:yade_bus/widgets/carousel.dart';

import 'slider_comp.dart';

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

  Future<void> _selectDate(BuildContext context) async {
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
      dateController.text = formattedDate;
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
    final controller = Get.put(DeepLinkController());
    if (controller.returnLink != null)
      Text('Lien de retour: ${controller.returnLink}');

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
                  "assets/images/image_r2.png"),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Card(
                  color: blanc,
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // SizedBox(
                          //   height: MediaQuery.of(context).size.width * 0.1,
                          // ),
                          // Logo
                          // Image.asset(
                          //   'assets/images/logo.png', // Remplace par le chemin correct de ton logo
                          //   height: 100,
                          // ),
                          // const SizedBox(height: 20),
                          // Image slider

                          // Stack(
                          //   alignment: Alignment.bottomCenter,
                          //   children: [
                          //     CarouselSlider(
                          //       options: CarouselOptions(
                          //         height: 90.0,
                          //         autoPlay: true,
                          //         enlargeCenterPage: true,
                          //         enableInfiniteScroll: true,
                          //         viewportFraction: 1.0, // Pour occuper toute la largeur
                          //         onPageChanged: (index, reason) {
                          //           setState(() {
                          //             _currentIndex = index;
                          //           });
                          //         },
                          //       ),
                          //       items: imageList.map((item) {
                          //         return Builder(
                          //           builder: (BuildContext context) {
                          //             return Container(
                          //               width: MediaQuery.of(context).size.width,
                          //               margin: EdgeInsets.symmetric(horizontal: 5.0),
                          //               decoration: BoxDecoration(
                          //                 borderRadius: BorderRadius.circular(10),
                          //                 image: DecorationImage(
                          //                   image: AssetImage(item),
                          //                   fit: BoxFit.cover,
                          //                 ),
                          //               ),
                          //             );
                          //           },
                          //         );
                          //       }).toList(),
                          //     ),

                          //     // Indicateur de page (dots)
                          //     Positioned(
                          //       bottom: 10.0,
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: imageList.asMap().entries.map((entry) {
                          //           return GestureDetector(
                          //             onTap: () => CarouselSlider(
                          //               options: CarouselOptions(
                          //                 initialPage: entry.key,
                          //               ),
                          //               items:
                          //                   imageList.map((item) => Container()).toList(),
                          //             ),
                          //             child: Container(
                          //               width: _currentIndex == entry.key ? 12.0 : 8.0,
                          //               height: _currentIndex == entry.key ? 12.0 : 8.0,
                          //               margin: const EdgeInsets.symmetric(
                          //                 vertical: 8.0,
                          //                 horizontal: 4.0,
                          //               ),
                          //               decoration: BoxDecoration(
                          //                 shape: BoxShape.circle,
                          //                 color: (Theme.of(context).brightness ==
                          //                             Brightness.dark
                          //                         ? Colors.white
                          //                         : bleu)
                          //                     .withOpacity(
                          //                         _currentIndex == entry.key ? 0.9 : 0.4),
                          //               ),
                          //             ),
                          //           );
                          //         }).toList(),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          const SizedBox(height: 16),

                          // Titre
                          const Text(
                            'Trouvez votre voyage ici',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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

                          // Champ de texte pour la date de départ avec icône
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: dateController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.calendar_today,
                                      color: Colors.blueGrey[400]),
                                  hintText: "Sélectionner une date",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                //     validator: (val) {
                                // if (val == null || val.isEmpty) {
                                //   return "Veuillez choisir une date";
                                // } else {
                                //   return null;
                                // }
                                // }
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Bouton de recherche
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Action à effectuer lors de l'appui sur le bouton
                                  if (formkey.currentState!.validate()) {
                                    // Get.to(
                                    //     VoyageScreen(
                                    //       idDepart: id,
                                    //       idDest: idD,
                                    //       dateDepart: dateController.text,
                                    //     ),
                                    //     transition:
                                    //         Transition.rightToLeftWithFade);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  // padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: Colors
                                      .red, // Couleur rouge comme sur l'image
                                ),
                                child: const Text(
                                  'RECHERCHER UN BILLET',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // Center(
                          //     child: Text(
                          //   "Nos partenaires",
                          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          // )),
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          // AgencySlider(),
                          // Stack(
                          //   alignment: Alignment.bottomCenter,
                          //   children: [
                          //     Column(
                          //       mainAxisSize:
                          //           MainAxisSize.min, // Ajuste la taille du Column
                          //       children: [
                          //         CarouselSlider(
                          //           options: CarouselOptions(
                          //             height: 90.0,
                          //             autoPlay: true,
                          //             enlargeCenterPage: true,
                          //             enableInfiniteScroll: true,
                          //             viewportFraction: 1.0,
                          //             onPageChanged: (index, reason) {
                          //               setState(() {
                          //                 _currentIndex = index;
                          //               });
                          //             },
                          //           ),
                          //           items: imageList.map((item) {
                          //             return Builder(
                          //               builder: (BuildContext context) {
                          //                 return Container(
                          //                   width: MediaQuery.of(context).size.width,
                          //                   margin: EdgeInsets.symmetric(horizontal: 5.0),
                          //                   decoration: BoxDecoration(
                          //                     borderRadius: BorderRadius.circular(10),
                          //                     image: DecorationImage(
                          //                       image: AssetImage(item['image']!),
                          //                       fit: BoxFit.cover,
                          //                     ),
                          //                   ),
                          //                 );
                          //               },
                          //             );
                          //           }).toList(),
                          //         ),

                          //         // Indicateur de page (dots)
                          //         Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: imageList.asMap().entries.map((entry) {
                          //             return GestureDetector(
                          //               onTap: () => CarouselSlider(
                          //                 options: CarouselOptions(
                          //                   initialPage: entry.key,
                          //                 ),
                          //                 items: imageList
                          //                     .map((item) => Container())
                          //                     .toList(),
                          //               ),
                          //               child: Container(
                          //                 width: _currentIndex == entry.key ? 12.0 : 8.0,
                          //                 height: _currentIndex == entry.key ? 12.0 : 8.0,
                          //                 margin: const EdgeInsets.symmetric(
                          //                     vertical: 1.0, horizontal: 4.0),
                          //                 decoration: BoxDecoration(
                          //                   shape: BoxShape.circle,
                          //                   color: (Theme.of(context).brightness ==
                          //                               Brightness.dark
                          //                           ? Colors.white
                          //                           : Colors.blue)
                          //                       .withOpacity(_currentIndex == entry.key
                          //                           ? 0.9
                          //                           : 0.4),
                          //                 ),
                          //               ),
                          //             );
                          //           }).toList(),
                          //         ),
                          //       ],
                          //     ),

                          //     // Affichage du nom de l'image en bas du slider
                          //     Align(
                          //       alignment: Alignment.bottomCenter,
                          //       child: Container(
                          //         padding: EdgeInsets.symmetric(
                          //             vertical: 15.0, horizontal: 16.0),
                          //         child: Text(
                          //           imageList[_currentIndex]['name']!,
                          //           style: TextStyle(
                          //             color: Colors.blue,
                          //             fontSize: 16.0,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // )

                          // Carousel(),
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
