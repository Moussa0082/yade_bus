import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/models/categorie.dart';
import 'package:yade_bus/models/events.dart';
import 'package:yade_bus/models/events_city.dart';
import 'package:yade_bus/screens/detail_divertissement.dart';
import 'package:yade_bus/services/categorie_service.dart';
import 'package:yade_bus/services/events_service.dart';
import 'package:yade_bus/widgets/shimmer_effect.dart';

class DivertissementScreen extends StatefulWidget {
  const DivertissementScreen({super.key});

  @override
  State<DivertissementScreen> createState() => _DivertissementScreenState();
}

class _DivertissementScreenState extends State<DivertissementScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> eventsList = [];
  List<dynamic> eventsCityList = [];

  bool isCatLoading = true;
  bool isEventLoading = true;
  String? selectedCategory; // Catégorie sélectionnée
  String? selectedCity; // Ville sélectionnée
  List<dynamic> cities = []; // Liste des villes disponibles pour l'événement

  final EventsService eventsService = EventsService();

  TabController? _tabController;
  List<Map<String, dynamic>> categorieList = [];

  // Méthode pour récupérer toutes les catégories
  Future<void> getAllCategorie() async {
    // Récupérez la liste des catégories de manière asynchrone
    List<dynamic> categories = await CategorieProduitService().fetchCategorie();

    // Ajouter un onglet "Tout"
    categorieList = [
      {'idCategory': 'all', 'nom': 'Tout'},
      ...categories
          .map((category) => {
                'idCategory': category.idCategory,
                'nom': category.nom,
              })
          .toList()
    ];
    setState(() {
      selectedCategory = 'all'; // Tout est sélectionné par défaut
      // Mettre à jour categorieList avec les catégories récupérées
      // categorieList = categories
      //     .map((category) =>
      //         {'idCategory': category.idCategory, 'nom': category.nom})
      //     .toList();
      // Initialiser le TabController après avoir récupéré les catégories
      _tabController = TabController(length: categorieList.length, vsync: this);
    });
  }

  // Méthode pour récupérer les événements en fonction de la catégorie
  Future<void> fetchEventsByCategory(String categoryId) async {
    // Vous pouvez remplacer cette ligne par un appel à votre service pour récupérer les événements de la catégorie

    // Logique pour récupérer tous les événements ou par catégorie
    final url = categoryId == 'all'
        ? "$apiUrl/events.php" // Remplacez cette URL par celle qui récupère tous les événements
        : "$apiUrl/events_by_categorie.php?idCategory=$categoryId"; // URL spécifique à la catégorie

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final String jsonString = utf8.decode(response.bodyBytes);
      List<dynamic> body = json.decode(jsonString);
      setState(() {
        eventsList = body;
        isEventLoading = false;
      });
    } else {
      setState(() {
        isEventLoading = false;
      });
      print(
          'Échec de la requête pour les événements par catégorie avec le code d\'état: ${response.statusCode}');
    }
  }

  // Méthode pour récupérer les événements
  Future<void> fetchEvents() async {
    // Vous pouvez remplacer cette ligne par un appel à votre service pour récupérer les événements
    final response = await http.get(Uri.parse("$apiUrl/events.php"));

    if (response.statusCode == 200) {
      final String jsonString = utf8.decode(response.bodyBytes);
      List<dynamic> body = json.decode(jsonString);
      setState(() {
        eventsList = body;
        isEventLoading = false;
      });
    } else {
      setState(() {
        isEventLoading = false;
      });
      print(
          'Échec de la requête pour les événements par catégorie avec le code d\'état: ${response.statusCode}');
    }
  }

  // Future<void> fetchCitiesByCategorie(int idCategory) async {
  //   final response = await http
  //       .get(Uri.parse("$apiUrl/events_ville_by_categorie.php?$idCategory"));

  //   if (response.statusCode == 200) {
  //     final String jsonString = utf8.decode(response.bodyBytes);
  //     print(jsonString); // Print the JSON for debugging

  //     final dynamic jsonResponse = json.decode(jsonString); // Use dynamic

  //     if (jsonResponse is List<dynamic>) {
  //       // Check if it's a list (cities found)
  //       setState(() {
  //         cities = jsonResponse
  //             .where((city) =>
  //                 city is Map<String, dynamic> && city['lieu'] != null)
  //             .map((city) => city['lieu'] as String)
  //             .toList();
  //       });
  //     } else if (jsonResponse is Map<String, dynamic> &&
  //         jsonResponse.containsKey('message')) {
  //       // Handle the "no cities found" message
  //       final String message = jsonResponse['message'] as String;
  //       print("API Message: $message"); // Log the message
  //       // You might want to display this message to the user or handle it differently
  //     } else {
  //       // Handle unexpected JSON structure
  //       print("Unexpected JSON structure: $jsonResponse");
  //       // Optionally throw an exception or display an error message
  //       throw FormatException(
  //           'Unexpected JSON structure'); // Throwing is a good practice
  //     }
  //   } else {
  //     print(
  //         'Failed to fetch cities for category with status code: ${response.statusCode}');
  //     // Handle the error, e.g., show a message to the user
  //   }
  // }

  // // Méthode pour récupérer les villes en fonction de la categorie sélectionné
  Future<void> fetchCitiesForEvent(int eventId) async {
    final response = await http.get(
        Uri.parse("$apiUrl/events_ville_by_categorie.php?idCategory=$eventId"));

    if (response.statusCode == 200 || response.statusCode == 200) {
      final String jsonString = utf8.decode(response.bodyBytes);
      List<dynamic> body = json.decode(jsonString);
      setState(() {
        cities = body;
      });
    } else {
      print(
          'Échec de la requête pour les villes par catégorie avec le code d\'état: ${response.statusCode}');
    }
  }

  Future<void> fetchEventByCities(String lieu) async {
    final response =
        await http.get(Uri.parse("$apiUrl/events_by_ville.php?lieu=$lieu"));

    if (response.statusCode == 200 || response.statusCode == 200) {
      final String jsonString = utf8.decode(response.bodyBytes);
      List<dynamic> body = json.decode(jsonString);
      setState(() {
        eventsList = body;
      });
    } else {
      print(
          'Échec de la requête pour les evenement par lieu avec le code d\'état: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    getAllCategorie();
    fetchEvents();
  }

  @override
  void dispose() {
    _tabController
        ?.dispose(); // Libérer le contrôleur lorsqu'il n'est plus nécessaire
    super.dispose();
  }

  // Liste des catégories avec les villes disponibles

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Divertissements'),
        centerTitle: true,
        bottom: categorieList.isEmpty
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: ClipRRect(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.blue, // Utilisez votre couleur ici
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withOpacity(0.6),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: const BoxDecoration(
                        color: Colors
                            .blueAccent, // Changez cette couleur selon vos besoins
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      onTap: (index) {
                        // Met à jour la catégorie sélectionnée et récupère les événements
                        setState(() {
                          selectedCategory =
                              categorieList[index]['idCategory'].toString();
                        });
                        categorieList[index]['idCategory'] != 'all'
                            ? fetchCitiesForEvent(
                                categorieList[index]['idCategory'])
                            : fetchEventsByCategory(
                                categorieList[index]['idCategory'].toString());

                        fetchEventsByCategory(
                            categorieList[index]['idCategory'].toString());
                      },
                      tabs: categorieList
                          .map((tab) => Container(child: Tab(text: tab['nom'])))
                          .toList(),
                    ),
                  ),
                ),
              ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            // Onglets pour afficher les catégories d'événements

            // SizedBox(
            //   height: 100,
            //   child: ListView.builder(
            //     itemCount: eventsList.length,
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) {
            //     final events = eventsList[index];

            //          return GestureDetector(
            //               onTap: () {
            //                 // Quand une catégorie est sélectionnée, on met à jour la sélection
            //                 setState(() {
            //                   selectedCategory = category.nom;
            //                   selectedCity =
            //                       null; // Réinitialise la ville sélectionnée
            //                   // availableCities = category
            //                   //     .availableCities; // Met à jour les villes disponibles
            //                 });
            //               },
            //               child:Tab(

            //               )
            //               //  CategoryCard(category: category),

            //             );
            //                      },

            //   ),
            // ),

            // Si une catégorie est sélectionnée, afficher les villes disponibles pour cette catégorie
            // if (selectedCategory != null) ...[
            //   SizedBox(height: 2),

            //   // DropdownButton pour sélectionner une ville en fonction de la catégorie
            //   Padding(
            //     padding: const EdgeInsets.all(10.0),
            //     child: Container(
            //       width: double
            //           .infinity, // Largeur maximale pour occuper tout l'espace disponible
            //       padding: EdgeInsets.symmetric(
            //           horizontal: 16.0), // Espacement interne
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(12), // Coins arrondis
            //         border: Border.all(
            //             color: bleu, width: 2), // Bordure bleue stylisée
            //       ),
            //       child: DropdownButton<String>(
            //         isExpanded:
            //             true, // Pour que le bouton utilise toute la largeur du conteneur
            //         hint: Text(
            //           "Choisissez une ville",
            //           style: TextStyle(
            //               fontSize: 18,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.grey), // Texte indicatif stylisé
            //         ),
            //         value: selectedCity,
            //         icon: Icon(Icons.arrow_drop_down,
            //             size: 30,
            //             color: bleu), // Icône plus grande et colorée
            //         underline:
            //             SizedBox(),
            //         onChanged: (String? newCity) {
            //           setState(() {
            //             selectedCity = newCity;
            //           });
            //         },
            //         items: eventsCityList
            //             .firstWhere(
            //                 (event) => event.libelle == selectedCategory)
            //             .eventsCityList
            //             .map<DropdownMenuItem<String>>((String city) {
            //           return DropdownMenuItem<String>(
            //             value: city,
            //             child: Text(
            //               city,
            //               style: TextStyle(
            //                   fontSize: 18,
            //                   fontWeight: FontWeight.bold,
            //                   color:
            //                       Colors.black), // Style du texte des options
            //             ),
            //           );
            //         }
            //         )
            //         // .toList(),
            //       ),
            //     ),
            //   )
            // ],
            if (selectedCategory != null && cities.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Add const here
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text(
                      "Choisissez une ville",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    value: cities.any((city) => city['lieu'] == selectedCity)
                        ? selectedCity
                        : null, // Assurez-vous que selectedCity est présent dans cities
                    icon: const Icon(Icons.arrow_drop_down,
                        size: 30, color: Colors.blue),
                    underline: const SizedBox(),
                    onChanged: (String? newCity) {
                      if (newCity != null) {
                        setState(() {
                          selectedCity = newCity;
                        });
                        fetchEventByCities(selectedCity!);
                      }
                    },
                    items: cities.map<DropdownMenuItem<String>>((dynamic city) {
                      return DropdownMenuItem<String>(
                        value: city['lieu'],
                        child: Text(
                          city['lieu'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],

            // Affichage de la sélection finale

            isEventLoading
                ? buildShimmerDivertissementCard(context)
                : buildEntertainmentGrid(),
          ],
        ),
      ),
    );
  }

  Widget buildEntertainmentGrid() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 840),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            // crossAxisCount: MediaQuery.of(context).size.width ~/ 180,
            // crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.70,
          ),
          itemCount: eventsList.length,
          itemBuilder: (context, index) {
            if (eventsList.isEmpty) {
              return Center(
                child: Text("Aucun evénement trouvé"),
              );
            }
            final entertainment = eventsList[index];
            return EntertainmentCard(events: entertainment);
          },
        ),
      ),
    );
  }
}

// class Category {
//   final String label;
//   final IconData icon;
//   final List<String>
//       availableCities; // Ajout des villes disponibles pour chaque catégorie

//   Category(
//       {required this.label, required this.icon, required this.availableCities});
// }

// class CategoryCard extends StatelessWidget {
//   final CategoriesEvent category;

//   CategoryCard({required this.category});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: bleu,
//             child: Icon(category.icon, size: 30, color: Colors.white),
//           ),
//           SizedBox(height: 6),
//           Text(category.label),
//         ],
//       ),
//     );
//   }
// }

class EntertainmentCard extends StatelessWidget {
  final dynamic events;

  EntertainmentCard({required this.events});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
            transition: Transition.downToUp,
            DetailDivertissement(
              evenement: events,
            ));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Stack(
                children: [
                  // Image avec un indicateur de chargement

                  Image.network(
                    events['img'] != null
                        ? events['img']!
                        : "https://media.ouest-france.fr/v1/pictures/af0f64d99cd99e117d44088f38ec0f3c-concert-de-paris-2023-classique-programme-tv?width=1260&height=708&sign=c8bec0a8aea3914c14fe23795d9da42df8cdbe1847d68b2c859494a128bed7fa&client_id=bpservices",
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("assets/images/div-default.jpg");
                    },
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Container(
                          height: 120,
                          width: double.infinity,
                          color: Colors.grey.withOpacity(0.3),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    events['nom']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    'Lieu : ${events['lieu']}',
                    style: TextStyle(color: bleuFoncer),
                  ),
                  SizedBox(height: 5),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    'Prix : ${events['tarif']}',
                    style: TextStyle(color: bleuFoncer),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
