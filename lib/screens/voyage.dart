import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Importer le package http
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert'; // Pour la conversion JSON
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/controller/nbplace_st_up.dart';
import 'package:yade_bus/screens/detail_voyage.dart';
import 'package:yade_bus/services/orange_money_service.dart';
import 'package:yade_bus/services/payment_service.dart';
import 'package:yade_bus/services/reservation_service.dart';
import 'package:yade_bus/widgets/shimmer_effect.dart';
import 'package:yade_bus/widgets/snack_bar.dart';

class VoyageScreen extends StatefulWidget {
  final int? idDepart;
  final int? idDest;
  final String? dateDepart;

  VoyageScreen({super.key, this.idDepart, this.idDest, this.dateDepart});

  @override
  State<VoyageScreen> createState() => _VoyageScreenState();
}

class _VoyageScreenState extends State<VoyageScreen>
    with WidgetsBindingObserver {
  List<Map<String, dynamic>> voyages = [];
  bool isLoading = true; // Indicateur de chargement
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    print(
        "Id depart: ${widget.idDepart}, Id destination: ${widget.idDest}, Date depart: ${widget.dateDepart}");
    fetchVoyages(); // Récupérer les données des voyages
    // Observer les changements de status
    final StatusController controller = Get.put(StatusController());
    controller.status.listen((status) {
      if (status == true) {
        fetchVoyagesWithoutShimmer(); // Exécuter cette méthode quand status devient true
      }
    });
  }

  bool isPaymentInProgress = false;
  Timer? timer;

  void _showPaymentDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Statut du paiement'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Arrête d'observer l'état de l'application
    WidgetsBinding.instance.removeObserver(this);
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  // Détecte les changements d'état de l'application (en arrière-plan ou au premier plan)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final StatusController controller = Get.put(StatusController());
    if (state == AppLifecycleState.paused) {
      // L'utilisateur a quitté l'application (arrière-plan)
      print('Utilisateur a quitté l\'application.');
      controller.updateIsBrowserStatus(false);
      if (timer != null) {
        timer!.cancel();
      }
    } else if (state == AppLifecycleState.resumed) {
      // L'utilisateur est revenu à l'application
      print('Utilisateur est de retour dans l\'application.');
      controller.updateIsBrowserStatus(true);
      OrangeMoneyService()
          .checkPaymentStatus(controller.accessToken, controller.payToken,
              controller.orderIds, controller.amounts)
          .then((value) {
        if (value == true) {}
      });
    }
  }

  Future<void> fetchVoyages() async {
    try {
      // Construire l'URL de l'API
      final response = await http.get(Uri.parse(
          '$apiUrl/voyage.php?idDepart=${widget.idDepart}&idDest=${widget.idDest}&dateDepart=${widget.dateDepart}'));
      // Affichez la réponse pour le débogage
      print(response.body);
      if (response.statusCode == 200) {
        // Convertir la réponse JSON en une liste de maps
        final List<dynamic> data = json.decode(response.body);
        await Future.delayed(Duration(seconds: 1));

        setState(() {
          voyages = data.cast<
              Map<String, dynamic>>(); // Mettre à jour la liste des voyages
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

  Future<void> fetchVoyagesWithoutShimmer() async {
    try {
      // Construire l'URL de l'API
      final response = await http.get(Uri.parse(
          '$apiUrl/voyage.php?idDepart=${widget.idDepart}&idDest=${widget.idDest}&dateDepart=${widget.dateDepart}'));
      // Affichez la réponse pour le débogage
      print(response.body);
      if (response.statusCode == 200) {
        // Convertir la réponse JSON en une liste de maps
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          voyages = data.cast<
              Map<String, dynamic>>(); // Mettre à jour la liste des voyages
        });
      } else {
        // Gérer les erreurs
        throw Exception('Erreur lors de la récupération des voyages');
      }
    } catch (e) {
      print(e);
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
                      Get.to(
                          transition: Transition.downToUp,
                          DetailVoyageScreen(voyage: voyageData));
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
    String formatDate(String? date) {
      if (date == null || date.isEmpty) return "Non spécifiée";
      try {
        final parsedDate = DateTime.parse(date); // Format attendu: yyyy-MM-dd
        return DateFormat('dd-MM-yyyy')
            .format(parsedDate); // Formatage en jj-mm-aaaa
      } catch (e) {
        return "Format invalide";
      }
    }

    if (voyageData.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text("Aucun voyage trouve"),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec nom de la compagnie et état
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    voyageData["compagnieNom"] ?? "Compagnie inconnue",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: bleu,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        int vy = voyageData["idVoyage"] is String
                            ? int.parse(voyageData["idVoyage"])
                            : voyageData["idVoyage"];
                        int tarif = voyageData["tarif"] is String
                            ? int.parse(voyageData["tarif"])
                            : voyageData["tarif"];
                        int nbPlace = voyageData["nbPlace"] is String
                            ? int.parse(voyageData["nbPlace"])
                            : voyageData["nbPlace"];
                        debugPrint(
                            "Réservation pour ${voyageData["compagnieNom"]}");
                        _openDialog(context, vy, tarif, nbPlace);
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
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
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Départ : ${voyageData["departNom"]}"),
                      Text("Heure : ${voyageData["heure"]}"),
                      Text("Date : ${formatDate(voyageData["dateDepart"])}"),
                    ],
                  ),
                  Column(
                    // crossAxisAlignmentß: CrossAxisAlignment.start,
                    children: [
                      Text("Dest : ${voyageData["destNom"]}"),
                      Text("Heure : ${voyageData["harrivee"]}"),
                      Text("Date : ${formatDate(voyageData["dateArrivee"])}"),
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                "Nombre de places disponible : ${voyageData["nbPlace"]}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          );
        }),
      ),
    );
  }
}

final _formKey = GlobalKey<FormState>();
final _nomController = TextEditingController();
final _prenomController = TextEditingController();
final _numeroController = TextEditingController();
final _adresseController = TextEditingController();
final _nbPlaceController = TextEditingController();

Future<void> _openDialog(
    BuildContext context, int idVoyage, int tarif, int nbPlace) async {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _numeroController = TextEditingController();
  // final _adresseController = TextEditingController();
  final _nbPlaceController = TextEditingController();

  // OrangeMoneyService().makePayment(merchantKey: "e9afd305",
  // orderId: "cmd_1", amount: 200000,
  //  returnUrl: "https://yadebus.com", cancelUrl: "https://yadebus.com/webpaydev/cancel",
  //   notifUrl: "https://yadebus.com/webpaydev/notif", reference: "ref-xyz.456");

  Future<void> _sendReservation(
      BuildContext context, int idVoyage, int nbPlace) async {
    final StatusController controller = Get.put(StatusController());

    // Vérifiez si les paramètres requis ne sont pas vides
    ReservationService()
        .addReservation(
            idVoyage: idVoyage,
            telephone: _numeroController.text,
            passager: "${_prenomController.text} ${_nomController.text}",
            nbPlace: int.parse(_nbPlaceController.text))
        .then((response) {
      Get.back(); // Ferme le dialogue si succès
      if (response.statusCode == 200) {
        controller.updateStatus(true);
        Snack.success(
          titre: "Succès",
          message: "Réservation effectuée avec succès !",
        );
      } else {
        // Affiche un message d'erreur sans fermer le dialogue
        Snack.error(
          titre: "Erreur",
          message: "Une erreur est survenue veuillez réessayer plus tard",
        );
      }
    }).catchError((error) {
      // Gère les exceptions (par exemple, problème de connexion)
      Snack.error(
        titre: "Erreur",
        message: " Une erreur est survenue veuillez réessayer plus tard ",
      );
    });

    // try {
    print("Données envoyées: ${{
      "idVoyage": idVoyage.toString(),
      "passager": "${_prenomController.text} ${_nomController.text}",
      "telephone": _numeroController.text,
      "nbPlace": nbPlace.toString(),
    }}");

    //   if (response.statusCode == 200) {
    //     print("body" + response.body);
    //     AwesomeDialog(
    //       context: context,
    //       dialogType: DialogType.success,
    //       animType: AnimType.scale,
    //       title: 'Succès',
    //       desc: 'Réservation réussie!',
    //       btnOkOnPress: () {
    //         controller.updateStatus(true);
    //         Get.back();
    //       },
    //     ).show();
    //   } else {
    //     throw Exception("Erreur de réservation");
    //   }
    // } catch (e) {
    //   AwesomeDialog(
    //     context: context,
    //     dialogType: DialogType.error,
    //     animType: AnimType.scale,
    //     title: 'Erreur',
    //     desc: 'Une erreur est survenue. Veuillez réessayer.',
    //     btnOkOnPress: () {
    //       Get.back();
    //     },
    //   ).show();
    // }
  }

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
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Reservation",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  // Champs du formulaire...
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Prénom",
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  TextFormField(
                    controller: _prenomController,
                    decoration: InputDecoration(
                      hintText: "Entrez votre prénom",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) =>
                        value!.isEmpty ? "Entrez votre prénom" : null,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Nom *",
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  TextFormField(
                    controller: _nomController,
                    decoration: InputDecoration(
                      hintText: "Entrez votre nom",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) =>
                        value!.isEmpty ? "Entrez votre nom" : null,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Numéro *",
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),

                  TextFormField(
                    controller: _numeroController,
                    decoration: InputDecoration(
                      hintText: "Entrez votre numéro de téléphone",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType:
                        TextInputType.number, // Permet le clavier numérique
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Autorise uniquement les chiffres
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le numéro est requis';
                      } else if (value.length < 8) {
                        return 'Minimum 8 chiffres requis';
                      } else if (value.length > 11) {
                        return 'Maximum 11 chiffres autorisés';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Nombre de places *",
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  TextFormField(
                    controller: _nbPlaceController,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Autorise uniquement les chiffres
                    ],
                    decoration: InputDecoration(
                      hintText: "Nombre de places",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? "Entrez le nombre de places" : null,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          double frais =
                              tarif * double.parse(_nbPlaceController.text);
                          final StatusController controller =
                              Get.put(StatusController());
                          OrangeMoneyService()
                              .makePayment(
                                  merchantKey: "e9afd305",
                                  amount: frais,
                                  returnUrl: "https://yadebus.com",
                                  cancelUrl:
                                      "https://yadebus.com/webpaydev/cancel",
                                  notifUrl:
                                      "https://yadebus.com/webpaydev/notif",
                                  reference: "ref-xyz.456")
                              .then((value) => {});
                          // Début de la vérification de l'utilisateur dans le navigateur
                          if (controller.isUserInBrowser.value == true) {
                            print(
                                'L\'utilisateur est toujours dans le navigateur.');
                          } else {
                            // Arrêtez les vérifications lorsque l'utilisateur quitte le navigateur
                            // await _sendReservation(context, idVoyage, nbPlace);
                            print('L\'utilisateur a quitté le navigateur.');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: rouge,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        minimumSize: const Size(310, 45),
                      ),
                      child: const Text(
                        "Réserver",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

// Future<void> _sendReservation(BuildContext context, int idVoyage, int nbPlace) async {
//       final StatusController controller = Get.put(StatusController());
//         // Vérifiez si les paramètres requis ne sont pas vides
//   if (_prenomController.text.isEmpty || _nomController.text.isEmpty || _numeroController.text.isEmpty) {
//     AwesomeDialog(
//       context: context,
//       dialogType: DialogType.error,
//       animType: AnimType.scale,
//       title: 'Erreur',
//       desc: 'Tous les champs doivent être remplis.',
//       btnOkOnPress: () {},
//     ).show();
//     return;
//   }

//   try {
//     final response = await http.post(
//       Uri.parse('$apiUrl/reservation.php'),
//      body: {
//   "idVoyage": idVoyage.toString(),
//   "passager": "${_prenomController.text} ${_nomController.text}",
//   "telephone": _numeroController.text,
//   "nbPlace": nbPlace.toString(),
// },

//     );
//  print("idVoyage: ${idVoyage.toString()}, passager: ${_prenomController.text} ${_nomController.text}, telephone: ${_numeroController.text}, nbPlace: ${nbPlace.toString()}");

//     if (response.statusCode == 200) {
//       print("body" + response.body);
//       AwesomeDialog(
//         context: context,
//         dialogType: DialogType.success,
//         animType: AnimType.scale,
//         title: 'Succès',
//         desc: 'Réservation réussie!',
//         btnOkOnPress: () {
//            controller.updateStatus(true);
//           Get.back();
//         },
//       ).show();
//     } else {
//       throw Exception("Erreur de réservation");
//     }
//   } catch (e) {
//     AwesomeDialog(
//       context: context,
//       dialogType: DialogType.error,
//       animType: AnimType.scale,
//       title: 'Erreur',
//       desc: 'Une erreur est survenue. Veuillez réessayer.',
//       btnOkOnPress: () {
//          Get.back();
//       },
//     ).show();
//   }
// }
