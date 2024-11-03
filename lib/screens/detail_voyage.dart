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
         leading:  IconButton(onPressed: (){
         Get.back();
        },
        icon:const Icon(Icons.arrow_back_ios, color: blanc,),
        ),
        centerTitle: true,
        backgroundColor: bleu,
        title: const Text('Détails du Voyage', style: TextStyle(color: blanc),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.voyage['compagnieNom'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Divider(),
            buildDetailRow('Départ:', widget.voyage['departNom']),
            buildDetailRow('Destination:', widget.voyage['destNom']),
            buildDetailRow('Date de départ:', widget.voyage['dateDepart']),
            buildDetailRow('Date d\'arrivée:', widget.voyage['dateArrivee']),
            buildDetailRow('Heure:', widget.voyage['heure']),
            buildDetailRow('Tarif:', '${widget.voyage['tarif']} XOF'),
            SizedBox(height: 10),
            buildDetailRow('Places disponibles:', '${widget.voyage['nbPlace']}'),
            Spacer(), // Prend tout l'espace disponible entre le contenu et le bouton
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logique pour réserver
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Réservation effectuée pour le voyage!')),
                  );
                },
                child: Text('Réserver'),
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
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Text(value, style: TextStyle(fontSize: 17),),
          ],
        ),
        Divider(),
      ],
    );
  }
}
