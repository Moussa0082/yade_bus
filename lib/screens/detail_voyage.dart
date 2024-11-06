import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yade_bus/constant/constantes.dart';

class DetailVoyageScreen extends StatefulWidget {
  final Map<String, dynamic> voyage;

  DetailVoyageScreen({super.key, required this.voyage});

  @override
  State<DetailVoyageScreen> createState() => _DetailVoyageScreenState();
}

class _DetailVoyageScreenState extends State<DetailVoyageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios, color: blanc),
        ),
        centerTitle: true,
        backgroundColor: bleu,
        title: const Text(
          'Détails du Voyage',
          style: TextStyle(color: blanc),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.voyage['compagnieNom'],
              style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
           const Divider(),
            buildDetailRow('Départ:', widget.voyage['departNom']),
            buildDetailRow('Destination:', widget.voyage['destNom']),
            buildDetailRow('Rendez-vous:', widget.voyage['rdv']),
            buildDetailRow('Agence:', widget.voyage['agenceNom']),
            buildDetailRow('Date de départ:', widget.voyage['dateDepart']),
            buildDetailRow('Date d\'arrivée:', widget.voyage['dateArrivee']),
            buildDetailRow('Heure:', widget.voyage['heure']),
            buildDetailRow('Tarif:', '${widget.voyage['tarif']} F'),
           const SizedBox(height: 10),
            buildDetailRow('Places disponibles:', '${widget.voyage['nbPlace']}'),
          const  Spacer(), // Prend tout l'espace disponible entre le contenu et le bouton
            Center(
              child: SizedBox(
                width: double.infinity, // Prendre toute la largeur
                child: ElevatedButton(
                  onPressed: () {
                    // Logique pour réserver
                    ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Réservation effectuée pour le voyage!', style: TextStyle(color: blanc),)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bleu, // Couleur de fond bleu
                    padding: const EdgeInsets.symmetric(vertical: 15), // Padding vertical pour agrandir le bouton
                  ),
                  child:const Text('Réserver', style: TextStyle(fontSize: 18, color: blanc)), // Taille de texte
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                textAlign: TextAlign.left,
                label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            Expanded(
              child: Text(
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                value,
                style: const TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
       const Divider(),
      ],
    );
  }
}
