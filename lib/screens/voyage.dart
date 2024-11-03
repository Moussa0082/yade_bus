import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/screens/detail_voyage.dart';

class VoyageScreen extends StatefulWidget {
  const VoyageScreen({super.key});

  @override
  State<VoyageScreen> createState() => _VoyageScreenState();
}

class _VoyageScreenState extends State<VoyageScreen> {
  
  
         final List<Map<String, dynamic>> voyages = [
    {
      "compagnieNom": "Azul Brazilian",
      "etat": "En Route",
      "departNom": "Bamako",
      "destNom": "Segou",
      "heure": "13:44",
      "harrivee": "15:44",
      "dateDepart": "2024-10-31",
      "dateArrivee": "2024-10-31",
      "tarif": "8000",
      "nbPlace": "1",
      "typeVoyage": "axePrincipal",
      "agenceNom": "Agence de Transport",
    },
    {
      "compagnieNom": "Air Mali",
      "etat": "Landed",
      "departNom": "Mopti",
      "destNom": "Tombouctou",
      "heure": "10:00",
      "harrivee": "12:30",
      "dateDepart": "2024-11-01",
      "dateArrivee": "2024-11-01",
      "tarif": "12000",
      "nbPlace": "2",
      "typeVoyage": "axeSecondaire",
      "agenceNom": "Transport Sahara",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bleu,
        title: const Text('Liste des Voyages', style:TextStyle(color: blanc),),
               leading:  IconButton(onPressed: (){
         Get.back();
        },
        icon:const Icon(Icons.arrow_back_ios, color: blanc,),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: voyages.length,
        itemBuilder: (context, index) {
          final voyageData = voyages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
      onTap: (){
        Get.to(transition: Transition.downToUp, DetailVoyageScreen(voyage: voyageData));
      },
              child: VoyageCard(voyageData: voyageData)),
          );
        },
      ),
    );
  }
}

class VoyageCard extends StatelessWidget {
  final Map<String, dynamic> voyageData;

  const VoyageCard({required this.voyageData});

  @override
  Widget build(BuildContext context) {
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
            // Header avec nom de la compagnie et état
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  voyageData["compagnieNom"] ?? "Compagnie inconnue",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    // color: voyageData["etat"] == "En Route"
                    //     ? Colors.blue
                    //     : Colors.green,
                    color: bleu,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton.icon(
  onPressed: () {
    print("Salut");
  },
  icon: const Icon(
    Icons.event_seat, // Icône de réservation
    size: 16, // Taille de l'icône pour la compacité
    color: blanc, // Couleur de l'icône
  ),
  label: const Text(
    "Réserver",
    style: TextStyle(
      color: blanc, // Couleur du texte
      fontSize: 14, // Taille de police compacte
    ),
  ),
  style: TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Espacement interne réduit
    minimumSize: const Size(80, 30), // Taille minimale
    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Réduit l'espace du bouton
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Coins arrondis pour le style
    ),
  ),
)

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
                    Text("Départ : ${voyageData["departNom"]}"),
                    Text("Heure : ${voyageData["heure"]}"),
                    Text("Date : ${voyageData["dateDepart"]}"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Arrivée : ${voyageData["destNom"]}"),
                    Text("Heure : ${voyageData["harrivee"]}"),
                    Text("Date : ${voyageData["dateArrivee"]}"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            // Ligne bleue avec icône de voiture au centre
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 2,
                    color: Colors.blue,
                    endIndent: 8,
                  ),
                ),
                Icon(Icons.directions_car, color: Colors.blue, size: 24),
                Expanded(
                  child: Divider(
                    thickness: 2,
                    color: Colors.blue,
                    indent: 8,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Tarif et nombre de places
            Text(
              "Tarif : ${voyageData["tarif"]} FCFA",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              "Nombre de places disponible : ${voyageData["nbPlace"]}",
              style: TextStyle(fontSize: 18),
            ),
            // Divider(thickness: 1, color: Colors.grey[300]),
            // SizedBox(height: 10),
            // // Type de voyage et agence
            // Text(
            //   "Type de voyage : ${voyageData["typeVoyage"]}",
            //   style: TextStyle(fontSize: 14, color: Colors.grey),
            // ),
            // Text(
            //   "Agence : ${voyageData["agenceNom"]}",
            //   style: TextStyle(fontSize: 14, color: Colors.grey),
            // ),
          ],
        ),
      ),
    );
  }
}