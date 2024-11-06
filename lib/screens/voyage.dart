import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Importer le package http
import 'package:shimmer/shimmer.dart';
import 'dart:convert'; // Pour la conversion JSON
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/screens/detail_voyage.dart';
import 'package:yade_bus/widgets/shimmer_effect.dart';

class VoyageScreen extends StatefulWidget {
  final int? idDepart;
  final int? idDest;
  final String? dateDepart;

  VoyageScreen({super.key, this.idDepart, this.idDest, this.dateDepart});

  @override
  State<VoyageScreen> createState() => _VoyageScreenState();
}

class _VoyageScreenState extends State<VoyageScreen> {
  List<Map<String, dynamic>> voyages = [];
  bool isLoading = true; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    print("Id depart: ${widget.idDepart}, Id destination: ${widget.idDest}, Date depart: ${widget.dateDepart}");
    fetchVoyages(); // Récupérer les données des voyages
  }

 Future<void> fetchVoyages() async {
  try {
    // Construire l'URL de l'API
    final response = await http.get(Uri.parse(
        'http://192.168.63.1/php/yade_back_end/voyage.php?idDepart=${widget.idDepart}&idDest=${widget.idDest}&dateDepart=${widget.dateDepart}'));
      // Affichez la réponse pour le débogage
    print(response.body);
    if (response.statusCode == 200) {
      // Convertir la réponse JSON en une liste de maps
      final List<dynamic> data = json.decode(response.body);
     await Future.delayed(Duration(seconds: 1));

      
      setState(() {
        voyages = data.cast<Map<String, dynamic>>(); // Mettre à jour la liste des voyages
        isLoading = false; // Fin du chargement
      });
    } else {
      // Gérer les erreurs
      throw Exception('Erreur lors de la récupération des voyages');
    }
  } catch (e) {
    print(e);
    setState(() {
      isLoading = false; // Fin du chargement même en cas d'erreur
    });
  }
}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bleu,
        title: const Text('Liste des Voyages', style: TextStyle(color: blanc)),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios, color: blanc),
        ),
      ),
      body: isLoading
          ? ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: 5, // Nombre d'éléments shimmer
              itemBuilder: (context, index) {
                return buildVoyageCard();
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: voyages.length,
              itemBuilder: (context, index) {
                final voyageData = voyages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(transition: Transition.downToUp, DetailVoyageScreen(voyage: voyageData));
                    },
                    child: VoyageCard(voyageData: voyageData),
                  ),
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
                    color: bleu,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      print("Réservation pour ${voyageData["compagnieNom"]}");
                      _openDialog(context);
                    },
                    icon: const Icon(
                      Icons.event_seat,
                      size: 16,
                      color: blanc,
                    ),
                    label: const Text(
                      "Réserver",
                      style: TextStyle(
                        color: blanc,
                        fontSize: 14,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      minimumSize: const Size(80, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
          ],
        ),
      ),
    );
  }
}

  Future<void> _openDialog(BuildContext context) async {
        final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _numeroController = TextEditingController();
  final _adresseController = TextEditingController();
  final _nbPlaceController = TextEditingController();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Close button at the top-right corner
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  
                  // Title of the form
                   Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Reservation",
                          maxLines:1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  
                  // Numéro de fiche
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Prénom ",
                      style: TextStyle(color: (Colors.black), fontSize: 18),
                    ),
                  ),
                  TextFormField(
                    controller: _prenomController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      hintText: "Entrez votre prénom",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    
                  ),
                  const SizedBox(height: 10),
          
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Nom *",
                      style: TextStyle(color: (Colors.black), fontSize: 18),
                    ),
                  ),
                  TextFormField(
                    controller: _nomController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      hintText: "Entrez votre nom",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    
                  ),
                  const SizedBox(height: 10),
          
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Numéro *",
                      style: TextStyle(color: (Colors.black), fontSize: 18),
                    ),
                  ),
                  TextFormField(
                    controller: _numeroController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      hintText: "Entrez votre numéro de telephone",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veuillez entrer votre numéro de telephone";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
          
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Nombre de place *",
                      style: TextStyle(color: (Colors.black), fontSize: 18),
                    ),
                  ),
                  TextFormField(
                    controller: _nbPlaceController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      hintText: "Entrez le nombre de place",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  
                  ),
                  const SizedBox(height: 10),
          
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Adresse *",
                      style: TextStyle(color: (Colors.black), fontSize: 18),
                    ),
                  ),
                  TextFormField(
                    controller: _adresseController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      hintText: "Entrez votre adresse",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    
                  ),
                  const SizedBox(height: 10),
          
      
                  
                        Center(
        child: ElevatedButton(
                          onPressed: () async  {
                          if(_formKey.currentState!.validate()){
                            Get.back();
                          }

                        },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: vert, // Orange color code
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minimumSize: const Size(310, 45),
                          ),
                          child: Text(
                           "Reserver",
                            style:const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
      )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}





 