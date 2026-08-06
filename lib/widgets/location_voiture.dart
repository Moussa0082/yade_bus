import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:yade_bus/constant/constantes.dart';

import '../screens/detail_voiture.dart';
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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String selectedFilter = 'Tous';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Category filter bar
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              height: 36,
              child: isLoadingCat
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (_, __) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          margin:
                              const EdgeInsets.only(right: 8),
                          width: 70,
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
                      itemBuilder: (_, index) {
                        final taille = categorie[index]['taille'];
                        final selected = selectedFilter == taille;
                        return GestureDetector(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                              selectedFilter = taille;
                            });
                            if (taille == 'Tous') {
                              await loadData();
                            } else {
                              try {
                                final result = await VoitureService()
                                    .fetchAllVehiculeByType(taille);
                                final filtered = result
                                    .cast<Map<String, dynamic>>();
                                List<Map<String, dynamic>> imgs = [];
                                List<Map<String, dynamic>> allImgs = [];
                                for (var car in filtered) {
                                  final il = await VoitureService()
                                      .fetchAllImageByVehicule(car['id']);
                                  final imageList =
                                      il.cast<Map<String, dynamic>>();
                                  imgs.add(imageList.isNotEmpty
                                      ? imageList[0]
                                      : {'img': ''});
                                  allImgs.add({
                                    for (int i = 0;
                                        i < imageList.length;
                                        i++)
                                      'img$i': imageList[i]['img']
                                  });
                                }
                                if (mounted) {
                                  setState(() {
                                    accommodations = filtered;
                                    carImgs = imgs;
                                    carsImg = allImgs;
                                  });
                                }
                              } catch (e) {
                                print('Erreur filtrage: $e');
                              }
                            }
                            if (mounted) {
                              setState(() => isLoading = false);
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF2967FF)
                                  : const Color(0xFFF5F7FA),
                              borderRadius:
                                  BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF2967FF)
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Text(
                              taille,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF6B7280),
                                fontSize: 13,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // Car list
          Expanded(
            child: isLoading
                ? ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 6,
                    itemBuilder: (_, __) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  )
                : accommodations.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucun véhicule disponible',
                          style: TextStyle(
                              color: Color(0xFF9CA3AF), fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: accommodations.length,
                        itemBuilder: (context, index) {
                          final car = accommodations[index];
                          final imgUrl = carImgs[index]['img'];
                          return GestureDetector(
                            onTap: () => Get.to(CarDetailScreen(
                              details: accommodations[index],
                              imagesUrl: carsImg[index],
                            )),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(bottom: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withValues(alpha: 0.06),
                                    blurRadius: 14,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Car image
                                  ClipRRect(
                                    borderRadius:
                                        const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                    child: imgUrl != null &&
                                            imgUrl.isNotEmpty
                                        ? Image.network(
                                            imgUrl,
                                            width: 130,
                                            height: 110,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                _imgPlaceholder(),
                                            loadingBuilder: (_, child,
                                                progress) {
                                              if (progress == null) {
                                                return child;
                                              }
                                              return _imgPlaceholder();
                                            },
                                          )
                                        : _imgPlaceholder(),
                                  ),

                                  // Car info
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            car['marque'] ?? '',
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight:
                                                  FontWeight.bold,
                                              color: Color(0xFF1A1A2E),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              _specChip(
                                                  Icons.event_seat_rounded,
                                                  '${car['seat']} places'),
                                              const SizedBox(width: 8),
                                              _specChip(
                                                  Icons.settings_rounded,
                                                  car['transmission'] ??
                                                      ''),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Text(
                                                '${car['priceday']} / jour',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  color:
                                                      Color(0xFF2967FF),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                      0xFF2967FF),
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(8),
                                                ),
                                                child: const Text(
                                                  'Louer',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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

  Widget _imgPlaceholder() {
    return Container(
      width: 130,
      height: 110,
      color: const Color(0xFFF5F7FA),
      alignment: Alignment.center,
      child: const Icon(Icons.directions_car_rounded,
          size: 40, color: Color(0xFFD1D5DB)),
    );
  }

  Widget _specChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 13, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
              fontSize: 11, color: Color(0xFF6B7280)),
        ),
      ],
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color:
              isSelected ? const Color(0xFF2967FF) : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2967FF)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color:
                isSelected ? Colors.white : const Color(0xFF6B7280),
            fontSize: 13,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
