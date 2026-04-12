import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/widgets/custom_btn.dart';
import 'package:yade_bus/widgets/shimmer_effect.dart';
import 'package:yade_bus/widgets/voiture_card.dart';

import '../screens/detail_voiture.dart';
import '../screens/voiture_reservation.dart';
import '../services/voiture_servce.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool isLoading = true;
  bool isLoadingCat = true;
  int selectedCategoryIndex = -1; // Pour suivre la catégorie sélectionnée

  List<Map<String, dynamic>> accommodations = [];
  List<Map<String, dynamic>> carImgs = [];
  List<dynamic> categorie = [];
  List<Map<String, dynamic>> carsImg =
      []; // chaque élément sera un Map<String, dynamic> représentant les images d'une voiture

  @override
  void initState() {
    super.initState();
    fetchCategorie();
    loadData();
  }

  Future<void> fetchCategorie() async {
    final response = await http.get(Uri.parse("$apiUrl/categorie_voiture.php"));
    if (response.statusCode == 200) {
      final String jsonString = utf8.decode(response.bodyBytes);
      List<dynamic> body = json.decode(jsonString);

      // Ajout du filtre "Tous"
      body.insert(0, {'taille': 'Tous'});

      setState(() {
        categorie = body;
        selectedFilter = 'Tous';
        isLoadingCat = false;
      });
    } else {
      setState(() {
        isLoadingCat = false;
      });
      print('Erreur de chargement des catégories: ${response.statusCode}');
    }
  }

  Future<void> loadData() async {
    try {
      final cardData = await VoitureService().fetchAllvehicule();
      final List<Map<String, dynamic>> cars =
          cardData.cast<Map<String, dynamic>>();

      List<Map<String, dynamic>> firstImages = [];

      for (var car in cars) {
        final imgs = await VoitureService().fetchAllImageByVehicule(car['id']);
        final List<Map<String, dynamic>> imageList =
            imgs.cast<Map<String, dynamic>>();

        // On stocke la première image (optionnel si utilisé)
        if (imageList.isNotEmpty) {
          firstImages.add(imageList[0]);
        } else {
          firstImages.add({'img': ''});
        }

        // ⚠️ Ici, on convertit imageList en Map<String, dynamic>
        Map<String, dynamic> imagesMap = {
          for (int i = 0; i < imageList.length; i++)
            'img$i': imageList[i]['img']
        };

        carsImg.add(imagesMap);
      }

      setState(() {
        accommodations = cars;
        carImgs = firstImages;
        isLoading = false;
      });
    } catch (e) {
      print("Erreur : $e");
      if (mounted)
        setState(() {
          isLoading = false;
        });
    }
  }

  String selectedFilter = 'Tous';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          // Filtres pour la taille des voitures
          SizedBox(
            height: 40,
            child: isLoadingCat
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (context, index) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categorie.length,
                    itemBuilder: (context, index) {
                      final taille = categorie[index]['taille'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: FilterButton(
                          text: taille,
                          isSelected: selectedFilter == taille,
                          onTap: () async {
  setState(() {
    isLoading = true;
    selectedFilter = taille;
  });

  if (taille == 'Tous') {
    await loadData(); // recharge toutes les voitures
  } else {
    try {
      final result = await VoitureService().fetchAllVehiculeByType(taille);
      final List<Map<String, dynamic>> filteredCars =
          result.cast<Map<String, dynamic>>();

      List<Map<String, dynamic>> firstImages = [];
      List<Map<String, dynamic>> newCarsImg = [];

      for (var car in filteredCars) {
        final imgs = await VoitureService().fetchAllImageByVehicule(car['id']);
        final List<Map<String, dynamic>> imageList =
            imgs.cast<Map<String, dynamic>>();

        if (imageList.isNotEmpty) {
          firstImages.add(imageList[0]);
        } else {
          firstImages.add({'img': ''});
        }

        Map<String, dynamic> imagesMap = {
          for (int i = 0; i < imageList.length; i++)
            'img$i': imageList[i]['img']
        };
        newCarsImg.add(imagesMap);
      }

      setState(() {
        accommodations = filteredCars;
        carImgs = firstImages;
        carsImg = newCarsImg;
      });
    } catch (e) {
      print("Erreur lors du filtrage: $e");
    }
  }

  if (mounted) {
    setState(() {
      isLoading = false;
    });
  }
},

                          // onTap: () async {
                          //   setState(() {
                          //     isLoading = true;
                          //   });
                          //   if (selectedFilter != 'Tous') {
                          //     // Cache les voitures qui ne correspondent pas
                          //     final result = await VoitureService()
                          //         .fetchAllVehiculeByType(selectedFilter)
                          //         .then((val) {
                          //       setState(() {
                          //         isLoading = false;
                          //       });
                          //     });
                          //     if (mounted)
                          //       setState(() {
                          //         selectedFilter = taille;
                          //         accommodations =
                          //             result.cast<Map<String, dynamic>>();
                          //       });
                          //   }
                          // },
                        ),
                      );
                    },
                  ),
          ),

          Expanded(
            child: isLoading
                ? ListView.builder(
                    itemCount: 8, // nombre de cartes de chargement fictives
                    itemBuilder: (context, index) {
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  width: 120,
                                  height: 100,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        height: 16,
                                        width: double.infinity,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        height: 14,
                                        width: 100,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        height: 14,
                                        width: 120,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        height: 14,
                                        width: 80,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: accommodations.length,
                    itemBuilder: (context, index) {
                      final car = accommodations[index];

                      // Afficher uniquement les voitures correspondant au filtre
                      // if (selectedFilter != 'Tous' &&
                      //     car['category'] != selectedFilter) {
                      //   return SizedBox
                      //       .shrink(); // Cache les voitures qui ne correspondent pas
                      // }

                      return GestureDetector(
                        onTap: () {
                          Get.to(CarDetailScreen(
                            details: accommodations[index],
                            imagesUrl: carsImg[index],
                          ));
                        },
                        child: Card(
                          color: blanc,
                          elevation: 1,
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    carImgs[index]['img'] != null
                                        ? Image.network(
                                            carImgs[index]['img'],
                                            width: 120,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                height: 100,
                                                width: 120,
                                                color: Colors.grey[300],
                                                alignment: Alignment.center,
                                                child: const Icon(
                                                    Icons.image_outlined,
                                                    size: 40,
                                                    color: Colors.grey),
                                              );
                                            },
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(Colors.blue),
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            (loadingProgress
                                                                    .expectedTotalBytes ??
                                                                1)
                                                        : null,
                                                  ),
                                                );
                                              }
                                            },
                                          )
                                        : Container(
                                            height: 200,
                                            color: Colors.grey[300],
                                            alignment: Alignment.center,
                                            child: const Icon(
                                                Icons.image_outlined,
                                                size: 40,
                                                color: Colors.grey),
                                          ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          car['marque']!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.event_seat, size: 16),
                                            SizedBox(width: 8),
                                            Text(car['seat']!.toString()),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.settings, size: 16),
                                            SizedBox(width: 8),
                                            Text(car['transmission']!),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.speed, size: 16),
                                            SizedBox(width: 8),
                                            Text(
                                              car['Mileage']!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                // Text(
                                //   'Modibo Keita International Airport',
                                //   style: TextStyle(color: Colors.blue),
                                // ),
                                // SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Prix par jours : ${car['priceday']}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Column(
                                    //   crossAxisAlignment: CrossAxisAlignment.end,
                                    //   children: [
                                    //     Text(
                                    //       'Note ${car['rating']}',
                                    //       style: TextStyle(
                                    //           color: Colors.green,
                                    //           fontWeight: FontWeight.bold),
                                    //     ),
                                    //     Text('${car['reviews']}'),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? bleu : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
