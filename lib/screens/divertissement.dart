import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yade_bus/constant/constantes.dart';

class DivertissementScreen extends StatefulWidget {
  const DivertissementScreen({super.key});

  @override
  State<DivertissementScreen> createState() => _DivertissementScreenState();
}

class _DivertissementScreenState extends State<DivertissementScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Divertissements'),
//       //   centerTitle: true,
//       // ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Section de divertissement
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Divertissements',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(
//               height: 100,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: [
//                   CategoryItem(icon: Icons.sports_soccer, label: 'Football'),
//                   CategoryItem(icon: Icons.science, label: 'Science'),
//                   CategoryItem(icon: Icons.checkroom, label: 'Mode'),
//                   CategoryItem(icon: Icons.movie, label: 'Film'),
//                   CategoryItem(icon: Icons.music_note, label: 'Musique'),
//                 ],
//               ),
//             ),

//             // Section des jeux
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Plus de Jeux',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//             ),
//             GridView.count(
//               shrinkWrap: true,
//               crossAxisCount: 2,
//               physics: NeverScrollableScrollPhysics(),
//               children: [
//                 GameCard(
//                     icon: Icons.language, label: 'Quiz Langue', score: '24.7K'),
//                 GameCard(
//                     icon: Icons.explore, label: 'Quiz Examen', score: '12.5K'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CategoryItem extends StatelessWidget {
//   final IconData icon;
//   final String label;

//   CategoryItem({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: bleu,
//             child: Icon(icon, size: 30, color: Colors.white),
//           ),
//           SizedBox(height: 8),
//           Text(label),
//         ],
//       ),
//     );
//   }
// }

// class GameCard extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String score;

//   GameCard({required this.icon, required this.label, required this.score});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(10),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 5,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Icon(icon, size: 40, color: Colors.orange),
//             SizedBox(height: 10),
//             Text(
//               label,
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               score,
//               style: TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simuler un délai de chargement de 3 secondes
    Timer(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Liste des catégories avec les villes disponibles

  String? selectedCategory; // La catégorie sélectionnée
  String? selectedCity; // La ville sélectionnée
    List<String> availableCities = []; // Liste des villes dynamiques


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Divertissements'),
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section de catégories
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text(
            //     'Catégories',
            //     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            // Affichage des catégories sous forme de cartes horizontales
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categoryList
                    .map((category) => GestureDetector(
                          onTap: () {
                            // Quand une catégorie est sélectionnée, on met à jour la sélection
                            setState(() {
                              selectedCategory = category.label;
                              selectedCity =
                                  null; // Réinitialise la ville sélectionnée
                             availableCities = category.availableCities; // Met à jour les villes disponibles
                            });
                          },
                          child: CategoryCard(category: category),
                        ))
                    .toList(),
              ),
            ),

            // Si une catégorie est sélectionnée, afficher les villes disponibles pour cette catégorie
            if (selectedCategory != null) ...[
              SizedBox(height: 2),
              // Text(
              //   'Sélectionnez une ville pour $selectedCategory',
              //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              // ),
              // SizedBox(height: 5),

              // DropdownButton pour sélectionner une ville en fonction de la catégorie
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: double
                      .infinity, // Largeur maximale pour occuper tout l'espace disponible
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.0), // Espacement interne
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), // Coins arrondis
                    border: Border.all(
                        color: Colors.blue, width: 2), // Bordure bleue stylisée
                  ),
                  child: DropdownButton<String>(
                    isExpanded:
                        true, // Pour que le bouton utilise toute la largeur du conteneur
                    hint: Text(
                      "Choisissez une ville",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey), // Texte indicatif stylisé
                    ),
                    value: selectedCity,
                    icon: Icon(Icons.arrow_drop_down,
                        size: 30,
                        color: Colors.blue), // Icône plus grande et colorée
                    underline:
                        SizedBox(), // Enlever la ligne sous le DropdownButton
                    onChanged: (String? newCity) {
                      setState(() {
                        selectedCity = newCity;
                      });
                    },
                    items: categoryList
                        .firstWhere(
                            (category) => category.label == selectedCategory)
                        .availableCities
                        .map<DropdownMenuItem<String>>((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(
                          city,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors.black), // Style du texte des options
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],

            // Affichage de la sélection finale
            // if (selectedCity != null)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 20),
            //     child: Text(
            //       'Vous avez sélectionné $selectedCategory à $selectedCity',
            //       style: TextStyle(fontSize: 16, color: Colors.green),
            //     ),
            //   ),
            // Section des divertissements
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text(
            //     'Divertissements',
            //     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            //   ),
            // ),
            _isLoading ? _buildShimmerLoading() : _buildEntertainmentGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCategoryLoading() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                ),
                SizedBox(height: 8),
                Container(height: 10, width: 60, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                              height: 20, width: 100, color: Colors.grey)),
                      SizedBox(height: 8),
                      Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                              height: 15, width: 60, color: Colors.grey)),
                      SizedBox(height: 8),
                      Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                              height: 15, width: 80, color: Colors.grey)),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEntertainmentGrid() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: entertainmentList.length,
        itemBuilder: (context, index) {
          final entertainment = entertainmentList[index];
          return EntertainmentCard(entertainment: entertainment);
        },
      ),
    );
  }
}

// class Category {
//   final IconData icon;
//   final String label;

//   Category({required this.icon, required this.label});
// }
class Category {
  final String label;
  final IconData icon;
  final List<String>
      availableCities; // Ajout des villes disponibles pour chaque catégorie

  Category(
      {required this.label, required this.icon, required this.availableCities});
}

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: bleu,
            child: Icon(category.icon, size: 30, color: Colors.white),
          ),
          SizedBox(height: 6),
          Text(category.label),
        ],
      ),
    );
  }
}

class Entertainment {
  final String title;
  final String location;
  final String price;
  final String imageUrl;

  Entertainment({
    required this.title,
    required this.location,
    required this.price,
    required this.imageUrl,
  });
}

class EntertainmentCard extends StatelessWidget {
  final Entertainment entertainment;

  EntertainmentCard({required this.entertainment});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  entertainment.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Builder pour l'indicateur de chargement
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      // L'image est entièrement chargée
                      return child;
                    } else {
                      // Affiche l'indicateur de chargement pendant que l'image charge
                      return Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey.withOpacity(
                            0.3), // Fond gris léger pendant le chargement
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue), // Bleu pour l'indicateur
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null, // Progrès du chargement
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
                  entertainment.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  'Lieu : ${entertainment.location}',
                  style: TextStyle(color: bleuFoncer),
                ),
                SizedBox(height: 5),
                Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  'Prix : ${entertainment.price}',
                  style: TextStyle(color: bleuFoncer),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Liste de catégories
final List<Category> categoryList = [
  Category(
    icon: Icons.sports_soccer,
    label: 'Football',
    availableCities: [
      'Bamako',
      'Barcelone',
      'Munich'
    ], // Villes disponibles pour Foot
  ),
  Category(
    icon: Icons.science,
    label: 'Science',
    availableCities: [
      'Kayes',
      'Barcelone',
      'Munich'
    ], // Villes disponibles pour Foot
  ),
  Category(
    icon: Icons.checkroom,
    label: 'Mode',
    availableCities: [
      'Ghana',
      'Barcelone',
      'Munich'
    ], // Villes disponibles pour Foot
  ),
  Category(
    icon: Icons.movie,
    label: 'Film',
    availableCities: [
      'Senegal',
      'Barcelone',
      'Munich'
    ], // Villes disponibles pour Foot
  ),
  Category(
    icon: Icons.music_note,
    label: 'Musique',
    availableCities: [
      'Mali',
      'Barcelone',
      'Munich'
    ], // Villes disponibles pour Foot
  ),
];

// Données fictives d'exemple
final List<Entertainment> entertainmentList = [
  Entertainment(
    title: 'Concert Rock',
    location: 'Paris',
    price: '50 F',
    imageUrl:
        'https://media.ouest-france.fr/v1/pictures/af0f64d99cd99e117d44088f38ec0f3c-concert-de-paris-2023-classique-programme-tv?width=1260&height=708&sign=c8bec0a8aea3914c14fe23795d9da42df8cdbe1847d68b2c859494a128bed7fa&client_id=bpservices',
  ),
  Entertainment(
    title: 'Théâtre Drame',
    location: 'Lyon',
    price: '35 F',
    imageUrl:
        'https://media.ouest-france.fr/v1/pictures/af0f64d99cd99e117d44088f38ec0f3c-concert-de-paris-2023-classique-programme-tv?width=1260&height=708&sign=c8bec0a8aea3914c14fe23795d9da42df8cdbe1847d68b2c859494a128bed7fa&client_id=bpservices',
  ),
  Entertainment(
    title: 'Match de Football',
    location: 'Marseille',
    price: '70 F',
    imageUrl:
        'https://media.ouest-france.fr/v1/pictures/af0f64d99cd99e117d44088f38ec0f3c-concert-de-paris-2023-classique-programme-tv?width=1260&height=708&sign=c8bec0a8aea3914c14fe23795d9da42df8cdbe1847d68b2c859494a128bed7fa&client_id=bpservices',
  ),
  Entertainment(
    title: 'Exposition d\'Art',
    location: 'Bordeaux',
    price: '20 F',
    imageUrl:
        'https://media.ouest-france.fr/v1/pictures/af0f64d99cd99e117d44088f38ec0f3c-concert-de-paris-2023-classique-programme-tv?width=1260&height=708&sign=c8bec0a8aea3914c14fe23795d9da42df8cdbe1847d68b2c859494a128bed7fa&client_id=bpservices',
  ),
  Entertainment(
    title: 'Spectacle de Danse',
    location: 'Toulouse',
    price: '45 F',
    imageUrl:
        'https://media.ouest-france.fr/v1/pictures/af0f64d99cd99e117d44088f38ec0f3c-concert-de-paris-2023-classique-programme-tv?width=1260&height=708&sign=c8bec0a8aea3914c14fe23795d9da42df8cdbe1847d68b2c859494a128bed7fa&client_id=bpservices',
  ),
  Entertainment(
    title: 'Festival de Cinémaaaaaaaa',
    location: 'Niceeeeeeeeeeeeeeeeeeeeeeesssssssssss',
    price: '60 F',
    imageUrl:
        'https://media.ouest-france.fr/v1/pictures/af0f64d99cd99e117d44088f38ec0f3c-concert-de-paris-2023-classique-programme-tv?width=1260&height=708&sign=c8bec0a8aea3914c14fe23795d9da42df8cdbe1847d68b2c859494a128bed7fa&client_id=bpservices',
  ),
];
