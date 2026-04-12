import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/screens/detail_maison.dart';
import 'package:yade_bus/services/logement_service.dart';
import 'package:yade_bus/widgets/shimmer_effect.dart';

class LocationMaison extends StatefulWidget {
  LocationMaison({super.key});

  @override
  State<LocationMaison> createState() => _LocationMaisonState();
}

class _LocationMaisonState extends State<LocationMaison> {
  bool isLoading = true;
  List<Map<String, dynamic>> accommodations = [];
  List<Map<String, dynamic>> logementImgs = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final logementData = await LogementService().fetchAllLogement();
      final List<Map<String, dynamic>> loadedAccommodations =
          logementData.cast<Map<String, dynamic>>();

      List<Map<String, dynamic>> firstImages = [];

      for (var logement in loadedAccommodations) {
        final imgs =
            await LogementService().fetchAllImageByLogement(logement['id']);
        final List<Map<String, dynamic>> imageList =
            imgs.cast<Map<String, dynamic>>();

        if (imageList.isNotEmpty) {
          firstImages.add(imageList[0]);
        } else {
          firstImages.add({'img': ''});
        }
      }

      setState(() {
        accommodations = loadedAccommodations;
        logementImgs = firstImages;
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => buildContent(context, {}, {}, true),
      );
    }

    if (accommodations.isEmpty) {
      return const Center(child: Text("Aucun logement trouvé"));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: accommodations.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(DetailMaison(
                details: accommodations[index],
                imageUrls: [logementImgs[index]],
              ));
            },
            child: buildContent(
              context,
              accommodations[index],
              logementImgs.length > index ? logementImgs[index] : {'img': ''},
              false,
            ),
          );
        },
      ),
    );
  }

  Widget buildContent(
    BuildContext context,
    Map<String, dynamic> accommodation,
    Map<String, dynamic> images,
    bool isLoading,
  ) {
    String imageUrls =
        (images['img'] != null && images['img'] is String) ? images['img'] : '';

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              isLoading
                  ? buildShimmer(width: double.infinity, height: 200)
                  : imageUrls.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrls,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 150,
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_outlined,
                              size: 40, color: Colors.grey),
                        ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isLoading
                    ? buildShimmer(width: 70, height: 20)
                    : Text(
                        accommodation['nom'] ?? '',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    isLoading
                        ? buildShimmer(width: 16, height: 16)
                        : const Icon(Icons.location_on,
                            size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    isLoading
                        ? buildShimmer(width: 90, height: 20)
                        : Text(accommodation['adresse'] ?? ''),
                  ],
                ),
                const SizedBox(height: 8),
                isLoading
                    ? buildShimmer(width: 70, height: 20)
                    : Text(
                        "Type: ${accommodation['typeLogement'] ?? ''}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        isLoading
                            ? buildShimmer(width: 16, height: 16)
                            : const Icon(Icons.bed,
                                size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        isLoading
                            ? buildShimmer(width: 30, height: 16)
                            : Text(accommodation['bed_type'] ?? ''),
                      ],
                    ),
                    Row(
                      children: [
                        isLoading
                            ? buildShimmer(width: 16, height: 16)
                            : const Icon(Icons.bathtub,
                                size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        isLoading
                            ? buildShimmer(width: 16, height: 16)
                            : Text(accommodation['bathroom'] ?? ''),
                      ],
                    ),
                    Row(
                      children: [
                        isLoading
                            ? buildShimmer(width: 40, height: 16)
                            : const Icon(Icons.people,
                                size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        isLoading
                            ? buildShimmer(width: 30, height: 16)
                            : Text("${accommodation['nb_pers'] ?? 0} pers"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//   bool isLoading = true;
//   List<Map<String, dynamic>> accommodations = [];
//   List<Map<String, dynamic>> logementImgs = [];
//   List<Map<String, dynamic>> logementImgsAll = [];

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   Future<void> loadData() async {
//   try {
//     final logementData = await LogementService().fetchAllLogement();
//     final List<Map<String, dynamic>> loadedAccommodations =
//         logementData.cast<Map<String, dynamic>>();

//     List<Map<String, dynamic>> firstImages = [];

//     for (var logement in loadedAccommodations) {
//       final imgs = await LogementService()
//           .fetchAllImageByLogement(logement['id']);
//       final List<Map<String, dynamic>> imageList =
//           imgs.cast<Map<String, dynamic>>();

//       // Prendre la première image s’il y en a, sinon une valeur vide
//       if (imageList.isNotEmpty) {
//         firstImages.add(imageList[0]);
//       } else {
//         firstImages.add({'img': ''});
//       }
//     }

//     setState(() {
//       accommodations = loadedAccommodations;
//       logementImgs = firstImages;
//       isLoading = false;
//     });
//   } catch (e) {
//     print("Erreur : $e");
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ListView.builder(
//               itemCount: accommodations.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                     onTap: () {
//                       Get.to(DetailMaison(
//                         details: accommodations[index],
//                       ));
//                     },
//                     child: buildContent(context, accommodations[index],
//                         logementImgs[index]));
//               },
//             ),
//     );
//   }

//  Widget buildContent(
//   BuildContext context,
//   final Map<String, dynamic> accommodation,
//   final Map<String, dynamic> images,
// ) {
//   String imageUrls = (images['img'] != null && images['img'] is String)
//       ? images['img']
//       : '';

//     return Card(
//       color: blanc,
//       margin: const EdgeInsets.all(3.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             alignment: Alignment.topRight,
//             children: [
//               isLoading
//                   ? buildShimmer(width: double.infinity, height: 200)
//                   : imageUrls.isNotEmpty
//                       ? CachedNetworkImage(
//                           imageUrl: imageUrls,
//                           placeholder: (context, url) =>
//                               const Center(child: CircularProgressIndicator()),
//                           errorWidget: (context, url, error) =>
//                               const Icon(Icons.error),
//                           width: double.infinity,
//                           height: 200,
//                           fit: BoxFit.cover,
//                         )
//                       : Container(
//                           height: 200,
//                           color: Colors.grey[300],
//                           alignment: Alignment.center,
//                           child: const Icon(Icons.image_outlined,
//                               size: 40, color: Colors.grey),
//                         ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 isLoading
//                     ? buildShimmer(width: 70, height: 20)
//                     : Text(
//                         accommodation['nom'],
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     isLoading
//                         ? buildShimmer(width: 16, height: 16)
//                         : const Icon(Icons.location_on,
//                             size: 16, color: Colors.grey),
//                     const SizedBox(width: 4),
//                     isLoading
//                         ? buildShimmer(width: 90, height: 20)
//                         : Text(accommodation['adresse']),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 isLoading
//                     ? buildShimmer(width: 70, height: 20)
//                     : Text(
//                         "Type: ${accommodation['typeLogement']}",
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Row(
//                       children: [
//                         isLoading
//                             ? buildShimmer(width: 16, height: 16)
//                             : const Icon(Icons.bed,
//                                 size: 16, color: Colors.grey),
//                         const SizedBox(width: 4),
//                         isLoading
//                             ? buildShimmer(width: 30, height: 16)
//                             : Text(accommodation['bed_type']),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         isLoading
//                             ? buildShimmer(width: 16, height: 16)
//                             : const Icon(Icons.bathtub,
//                                 size: 16, color: Colors.grey),
//                         const SizedBox(width: 4),
//                         isLoading
//                             ? buildShimmer(width: 16, height: 16)
//                             : Text(accommodation['bathroom']),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         isLoading
//                             ? buildShimmer(width: 40, height: 16)
//                             : const Icon(Icons.people,
//                                 size: 16, color: Colors.grey),
//                         const SizedBox(width: 4),
//                         isLoading
//                             ? buildShimmer(width: 30, height: 16)
//                             : Text("${accommodation['nb_pers']} pers"),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// List<Map<String, dynamic>> accommodations = [
//   {
//     'name': 'Sukoco Hotel',
//     'location': 'Yogyakarta, Indonesia',
//     'price': '\$142/month',
//     'rating': 4.6,
//     'imageUrl': [
//       'https://www.kayak.fr/rimg/himg/b3/10/90/ice-178163-120191068-424668.jpg?width=1366&height=768&crop=true', // Remplacez par l'URL de l'image
//       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQL5XipWAYUqaJR6cYukOxsnIXIvspj-rNbDg&s', // Remplacez par l'URL de l'image
//     ],
//     'bedrooms': 4,
//     'bathrooms': 2,
//     'sqft': '1012 sqft',
//   },
//   {
//     'name': 'Permata Apartment',
//     'location': 'Yogyakarta, Indonesia',
//     'price': '\$246/month',
//     'rating': 4.6,
//     'imageUrl': [
//       'https://www.kayak.fr/rimg/himg/b3/10/90/ice-178163-120191068-424668.jpg?width=1366&height=768&crop=true', // Remplacez par l'URL de l'image
//       'https://www.turenne.com/media/cache/jadro_resize/rc/p35z1T8e1709124243/jadroRoot/medias/5cc700adbfa0b/5cc7027f17b8d/chambre-triple-pre-mium.jpg', // Remplacez par l'URL de l'image
//     ],
//     'bedrooms': 6,
//     'bathrooms': 3,
//     'sqft': '1248 sqft',
//   },
// ];
