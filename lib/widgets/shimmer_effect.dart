import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Fonction pour construire le shimmer
Widget buildShimmerLocationCard() {
  return ListView.builder(
    itemCount: 6, // Affiche 6 cartes shimmer
    itemBuilder: (context, index) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        // Image de la voiture
                        width: 10,
                        height: 90,
                        color: Colors.grey[300]!,
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        // Image de la voiture
                        width: 10,
                        height: 90,
                        color: Colors.grey[300],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            // Image de la voiture
                            width: 10,
                            height: 10,
                            color: Colors.grey[300],
                          ),
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            // Image de la voiture
                            width: 10,
                            height: 90,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            // Image de la voiture 
                            width: 10,
                            height: 50,
                            color: Colors.grey[300],
                          ),
                        ), // Prix 1
                        SizedBox(width: 8),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            // Image de la voiture
                            width: 10,
                            height: 50,
                            color: Colors.grey[300],
                          ),
                        ), // Prix 2
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      // Image de la voiture
                      width: 80,
                      height: 60,
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(height: 8),
                  // btn
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      // Image de la voiture
                      width: 80,
                      height: 60,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


 
// Widget pour créer un effet shimmer rectangulaire
Widget buildShimmer({double width = double.infinity, double height = 16}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}

// Shimmer divertissement card
Widget buildShimmerDivertissementCard(BuildContext context) {
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

//Shimmer categorie loading
Widget buildShimmerCategoryLoading() {
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

//Voyage Card
Widget buildVoyageCard() {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec nom de la compagnie
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 150,
                  height: 20,
                  color: Colors.grey[300], // Couleur de fond pour le shimmer
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 80,
                  height: 20,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Informations de départ et d'arrivée
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 100,
                      height: 15,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 80,
                      height: 15,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 120,
                      height: 15,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 100,
                      height: 15,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 80,
                      height: 15,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 120,
                      height: 15,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          // Ligne bleue avec icône de voiture au centre
          Row(
            children: [
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Divider(
                    thickness: 2,
                    color: Colors.grey[300],
                    endIndent: 8,
                  ),
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 24,
                  height: 24,
                  color: Colors.grey[300],
                ),
              ),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Divider(
                    thickness: 2,
                    color: Colors.grey[300],
                    indent: 8,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Tarif et nombre de places
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 100,
              height: 20,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(height: 5),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 150,
              height: 20,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    ),
  );
}
