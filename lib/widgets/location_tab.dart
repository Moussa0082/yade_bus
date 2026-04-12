import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/widgets/location_maison.dart';
import 'package:yade_bus/widgets/location_voiture.dart';

class LocationTab extends StatefulWidget {
  const LocationTab({super.key});

  @override
  State<LocationTab> createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Maison',
      'icon': Icons.home,
      // 'page': HomePage(),
      'page': LocationMaison(),
    },
    {
      'title': 'Voiture',
      'icon': Icons.directions_car,
      'page': LocationScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: blanc, // Remplacez par votre constante de couleur
            ),
          ),
          centerTitle: true,
          backgroundColor:
              bleuFoncer, // Remplacez par votre constante de couleur
          title: const Text(
            'Location',
            style: TextStyle(color: blanc, fontWeight: FontWeight.bold),
          ),
          bottom:
              // PreferredSize(
              //   preferredSize: const Size.fromHeight(60), // Ajustez la hauteur
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(vertical: 4.0),
              //     decoration: BoxDecoration(color: blanc),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: [
              //         Container(
              //           decoration: BoxDecoration(
              //             color: _selectedIndex == 0
              //                 ? bleuFoncer // Remplacez par votre constante de couleur
              //                 : bleu,
              //             borderRadius:
              //                 BorderRadius.circular(10), // Ajoute des bords arrondis
              //           ),
              //           padding: EdgeInsets.symmetric(
              //               horizontal: 10, vertical: 8), // Ajoute du padding interne
              //           margin: EdgeInsets.symmetric(
              //               horizontal: 10,
              //               vertical: 4), // Ajoute des marges externes
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment
              //                 .spaceAround, // Répartit les éléments uniformément
              //             children: [
              //               InkWell(
              //                 onTap: () {
              //                   setState(() {
              //                     _selectedIndex = 0;
              //                   });
              //                 },
              //                 child: Row(
              //                   // Utilise une Column pour une meilleure organisation
              //                   mainAxisSize: MainAxisSize.min,
              //                   children: [
              //                     Icon(
              //                       _pages[0]['icon'],
              //                       color: _selectedIndex == 0
              //                             ? blanc
              //                             : Colors.grey[
              //                                 400],
              //                       size: 28, // Augmente la taille de l'icône
              //                     ),
              //                     SizedBox(
              //                         height:
              //                             8), // Ajoute un espacement entre l'icône et le texte
              //                     Text(
              //                       _pages[0]['title'],
              //                       style: TextStyle(
              //                         color: _selectedIndex == 0
              //                             ? blanc
              //                             : Colors.grey[
              //                                 400], // Ajuste la couleur du texte
              //                         fontSize: 16, // Ajuste la taille de la police
              //                         fontWeight:
              //                             FontWeight.w600, // Ajoute un peu de gras
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               // Ajoutez d'autres InkWell/Column pour les autres pages ici
              //               // ...
              //             ],
              //           ),
              //         ),
              //         Container(
              //           decoration: BoxDecoration(
              //             color: _selectedIndex == 1
              //                 ? bleuFoncer // Remplacez par votre constante de couleur
              //                 : bleu,
              //             borderRadius:
              //                 BorderRadius.circular(10), // Ajoute des bords arrondis
              //           ),
              //           padding: EdgeInsets.symmetric(
              //               horizontal: 10, vertical: 8), // Ajoute du padding interne
              //           margin: EdgeInsets.symmetric(
              //               horizontal: 10,
              //               vertical: 4), // Ajoute des marges externes
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment
              //                 .spaceAround, // Répartit les éléments uniformément
              //             children: [
              //               InkWell(
              //                 onTap: () {
              //                   setState(() {
              //                     _selectedIndex = 1;
              //                   });
              //                 },
              //                 child: Row(
              //                   // Utilise une Column pour une meilleure organisation
              //                   mainAxisSize: MainAxisSize.min,
              //                   children: [
              //                     Icon(
              //                       _pages[1]['icon'],
              //                       color: _selectedIndex == 1
              //                 ? blanc // Remplacez par votre constante de couleur
              //                 : Colors.grey[200],
              //                       size: 28, // Augmente la taille de l'icône
              //                     ),
              //                     SizedBox(
              //                         height:
              //                             8), // Ajoute un espacement entre l'icône et le texte
              //                     Text(
              //                       _pages[1]['title'],
              //                       style: TextStyle(
              //                         color: _selectedIndex == 1
              //                 ? blanc // Remplacez par votre constante de couleur
              //                 : Colors.grey[200], // Ajuste la couleur du texte
              //                         fontSize: 16, // Ajuste la taille de la police
              //                         fontWeight:
              //                             FontWeight.w600, // Ajoute un peu de gras
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),

              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              PreferredSize(
            preferredSize: const Size.fromHeight(35),
            child: Container(
              color: blanc,
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8),
              child: Row(
                children: List.generate(_pages.length, (index) {
                  final isSelected = _selectedIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2.0),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? bleuFoncer : bleu,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 15),
                                Icon(
                                  _pages[index]['icon'],
                                  color: isSelected ? blanc : Colors.grey[300],
                                  size: 26,
                                ),
                                SizedBox(width: 15),
                                Text(
                                  _pages[index]['title'],
                                  style: TextStyle(
                                    color:
                                        isSelected ? blanc : Colors.grey[300],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          )),
      body: Column(
        children: [
          // Page correspondante
          Expanded(
            child: _pages[_selectedIndex]['page'],
          ),
        ],
      ),
    );
  }
}
