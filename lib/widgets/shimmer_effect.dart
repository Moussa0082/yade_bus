import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Fonction pour construire le shimmer
  Widget buildShimmerLocationCard() {
   return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: 6, // Affiche 6 cartes shimmer
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Simule l'image de la voiture
                Expanded(
                  child: 
                 Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 120,
                    width: double.infinity,
                    color: Colors.white,
                            
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Simule le titre (nom de la voiture)
                Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 16,
                    width: double.infinity,
                        color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
        
                // Simule l'icône de la marque et le nom de la marque
                Row(
                  children: [
                    Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 16,
                        width: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: 
                     Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 16,
                        color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
        
                // Simule l'icône du prix et le prix
                Row(
                  children: [
                   Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 16,
                        width: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child:
                       Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 16,
                        color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
        
                // Simule l'icône de disponibilité et le statut
                Row(
                  children: [
                    Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 16,
                        width: 16,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child:
                       Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 16,
                          color: Colors.grey[300],
                        ),
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
                    const SizedBox(height: 5,),
                    Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 80,
                        height: 15,
                        color: Colors.grey[300],
                      ),
                    ),
                                        const SizedBox(height: 5,),

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
                                        const SizedBox(height: 5,),

                    Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 80,
                        height: 15,
                        color: Colors.grey[300],
                      ),
                    ),
                                        const SizedBox(height: 5,),

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
                  child: 
                  Shimmer.fromColors(
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
                  child: 
                  Shimmer.fromColors(
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