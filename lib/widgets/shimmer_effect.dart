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