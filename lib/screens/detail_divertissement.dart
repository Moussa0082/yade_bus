import 'package:flutter/material.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/models/events.dart';

class DetailDivertissement extends StatefulWidget {
  dynamic evenement;
  DetailDivertissement({super.key, required this.evenement});

  @override
  State<DetailDivertissement> createState() => _DetailDivertissementState();
}

class _DetailDivertissementState extends State<DetailDivertissement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Détail",
          style: TextStyle(color: blanc),
        ),
        centerTitle: true,
        backgroundColor: bleu,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios, color: blanc)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200,
                width: double.infinity, // Occupe toute la largeur
                child: Image.asset(
                  "assets/images/div-default.jpg",
                  fit: BoxFit
                      .cover, // Permet de s'assurer que l'image couvre tout en respectant le ratio
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDetailRow(
                      "Organisateur:",
                      widget.evenement['organisateur'] != null
                          ? widget.evenement['organisateur']!
                          : "inconnu"),
                  Divider(thickness: 1),
                  buildDetailRow(
                      "Ville :",
                      widget.evenement['lieu'] != null
                          ? widget.evenement['lieu']!
                          : "inconnu"),
                  Divider(thickness: 1),
                  buildDetailRow(
                      "Prix  :",
                      widget.evenement['tarif'] != null
                          ? widget.evenement['tarif']!.toString()
                          : "inconnu"),
                  Divider(thickness: 1),
                  buildDetailRow(
                      "Date Début :",
                      widget.evenement['dateDebut'] != null
                          ? widget.evenement['dateDebut']!
                          : "inconnu"),
                  Divider(thickness: 1),
                  buildDetailRow(
                      "Date Fin :",
                      widget.evenement['dateFin'] != null
                          ? widget.evenement['dateFin']!
                          : "inconnu"),
                  Divider(thickness: 1),
                  buildDetailRow(
                      "Info Tel :",
                      widget.evenement['tel'] != null
                          ? widget.evenement['tel']!
                          : "inconnu"),
                  Divider(thickness: 1),
                  buildDetailRow(
                      "Categorie :",
                      widget.evenement['category'] != null
                          ? widget.evenement['category']!
                          : "inconnu"),
                  Divider(thickness: 1),
                  buildDetailRow(
                      "Tags :",
                      widget.evenement['tags'] != null
                          ? widget.evenement['tags']!
                          : "inconnu"),
                  Divider(thickness: 1),
                  SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Action à définir pour le bouton si besoin
                          print("Action sur le bouton");
                        },
                        child: Text(
                          "Reserver",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bleu,
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour créer chaque ligne de détail
  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
