import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Importer le package http
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:uni_links3/uni_links.dart';
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
import 'package:yade_bus/widgets/voyage_card.dart';

import '../widgets/custom_btn.dart';

class VoyageScreen extends StatefulWidget {
  final int? idDepart;
  final int? idDest;
  final int? idVoyageRetour;
  final int? type;
  final String? dateDepart;
  final String? dateRetour;
  final String nomDepart;
  final String nomDest;

  VoyageScreen({
    super.key,
    this.idDepart,
    this.idDest,
    this.idVoyageRetour,
    this.type,
    this.dateDepart,
    this.dateRetour,
    required this.nomDepart,
    required this.nomDest,
  });

  @override
  State<VoyageScreen> createState() => _VoyageScreenState();
}

class _VoyageScreenState extends State<VoyageScreen>
    with WidgetsBindingObserver {
  bool _isPaymentChecked = false;
  bool? _paymentSuccess;
  List<Map<String, dynamic>> voyages = [];
  List<Map<String, dynamic>> allers = [];
  List<Map<String, dynamic>> retours = [];
  bool isLoading = true; // Indicateur de chargement
  String selectedType = 'Aller'; // Choix entre Aller / Retour
  List<String> voyageTypes = ['Aller', 'Retour'];

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
  String? selectedDepartCity; // Variable pour stocker la ville sélectionnée

  StreamSubscription? _sub;
  Map<String, dynamic>? selectedAller;
  Map<String, dynamic>? selectedRetour;

  @override
  void dispose() {
    _sub?.cancel();
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
      OrangeMoneyService()
          .checkPaymentStatus(controller.accessToken, controller.payToken,
              controller.orderIds, controller.amounts)
          .then((value) {
        controller.updateIsBrowserStatus(true);
        if (value == true) {
          controller.sendReservationStatut(true);
        } else {
          print("Non reussi");
        }
        // initUniLinks();
        setState(() {
          _paymentSuccess = value;
          _isPaymentChecked = true;
        });

        if (_paymentSuccess == true) {
          // Paiement réussi
          SnackBar snackBar = SnackBar(content: Text("Paiement réussi !"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          // Paiement échoué ou non terminé
          SnackBar snackBar = SnackBar(content: Text("Paiement non réussi."));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }
  }

  // Future<void> fetchVoyages() async {
  //   try {
  //     // Construire l'URL de l'API
  //     final response = await http.get(Uri.parse(
  //         '$apiUrl/voyage.php?idDepart=${widget.idDepart}&idDest=${widget.idDest}&dateDepart=${widget.dateDepart}&dateRetour=${widget.dateRetour}'));
  //     // Affichez la réponse pour le débogage
  //     print(response.body);
  //     if (response.statusCode == 200) {
  //       // Convertir la réponse JSON en une liste de maps
  //       final List<dynamic> data = json.decode(response.body);
  //       await Future.delayed(Duration(seconds: 1));

  //       setState(() {
  //         voyages = data.cast<
  //             Map<String, dynamic>>(); // Mettre à jour la liste des voyages
  //         isLoading = false; // Fin du chargement
  //       });
  //     } else {
  //       // Gérer les erreurs
  //       throw Exception('Erreur lors de la récupération des voyages');
  //     }
  //   } catch (e) {
  //     print(e);
  //     setState(() {
  //       isLoading = false; // Fin du chargement même en cas d'erreur
  //     });
  //   }
  // }
  Future<void> fetchVoyages() async {
    try {
      final response = await http.get(Uri.parse(
          '$apiUrl/voyage.php?idDepart=${widget.idDepart}&idDest=${widget.idDest}&dateDepart=${widget.dateDepart}&dateRetour=${widget.dateRetour}'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          allers = List<Map<String, dynamic>>.from(data['aller'] ?? []);
          retours = List<Map<String, dynamic>>.from(data['retour'] ?? []);
          isLoading = false;
        });
      } else {
        throw Exception('Erreur lors de la récupération des voyages');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchVoyagesWithoutShimmer() async {
    try {
      final response = await http.get(Uri.parse(
          '$apiUrl/voyage.php?idDepart=${widget.idDepart}&idDest=${widget.idDest}&dateDepart=${widget.dateDepart}&dateRetour=${widget.dateRetour}'));
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        allers = List<Map<String, dynamic>>.from(data['aller'] ?? []);
        retours = List<Map<String, dynamic>>.from(data['retour'] ?? []);

        setState(() {
          voyages = selectedType == 'Aller' ? allers : retours;
        });
      } else {
        throw Exception('Erreur lors de la récupération des voyages');
      }
    } catch (e) {
      print(e);
    }
  }

  String selectedCompany = "Tous"; // Filtre par compagnie
  List<String> companies = [
    "Tous",
    "Rimbo",
    "Diarra",
    "Sonef"
  ]; // Liste des compagnies (ajoutez d'autres compagnies ici)

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredAllers = allers.where((v) {
      return selectedCompany == "Tous" || v["compagnieNom"] == selectedCompany;
    }).toList();

    List<Map<String, dynamic>> filteredRetours = retours.where((v) {
      return selectedCompany == "Tous" || v["compagnieNom"] == selectedCompany;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bleuFoncer,
        title: const Text('Liste des Voyages', style: TextStyle(color: blanc)),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios, color: blanc),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              // const Text("Choisis une compagnie!",
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: DropdownButton<String>(
              //     value: selectedCompany,
              //     onChanged: (value) {
              //       setState(() {
              //         selectedCompany = value!;
              //       });
              //     },
              //     items: companies.map((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(value),
              //       );
              //     }).toList(),
              //     isExpanded: true,
              //   ),
              // ),
              Expanded(
                child: isLoading
                    ? ListView.builder(
                        itemCount: 6,
                        itemBuilder: (_, index) => buildVoyageCard(),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(10),
                        children: [
                          if (filteredAllers.isNotEmpty) ...[
                            Text(
                                "Voyages Aller ${widget.nomDepart} - ${widget.nomDest} ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            ...filteredAllers.map((v) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (selectedAller == v) {
                                          selectedAller =
                                              null; // désélectionner si déjà sélectionné
                                        } else {
                                          selectedAller = v;
                                        }
                                      });
                                    },
                                    child: VoyageCard(
                                      voyageData: v,
                                      isSelected: selectedAller == v,
                                    ),
                                  ),
                                )),
                          ],
                          if (filteredRetours.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Text(
                                "Voyages Retour  ${widget.nomDest} - ${widget.nomDepart}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            ...filteredRetours.map((v) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (selectedRetour == v) {
                                          selectedRetour = null;
                                        } else {
                                          selectedRetour = v;
                                        }
                                      });
                                    },
                                    child: VoyageCard(
                                      voyageData: v,
                                      isSelected: selectedRetour == v,
                                    ),
                                  ),
                                )),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: selectedAller != null || selectedRetour != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: btnLarge("Reserver", bleu, blanc, () {
                // Naviguer ou traiter la réservation ici
                int vy = selectedAller!["idVoyage"] is String
                    ? int.parse(selectedAller!["idVoyage"])
                    : selectedAller!["idVoyage"];
                int vr = selectedRetour!["idVoyage"] is String
                    ? int.parse(selectedRetour!["idVoyage"])
                    : selectedRetour!["idVoyage"];
                int tarif = selectedAller!["tarif"] is String
                    ? int.parse(selectedAller!["tarif"])
                    : selectedAller!["tarif"];
                int nbPlace = selectedAller!["nbPlace"] is String
                    ? int.parse(selectedAller!["nbPlace"])
                    : selectedAller!["nbPlace"];
                debugPrint(
                    "Réservation pour ${selectedAller!["compagnieNom"]}");
                _openDialog(
                    widget.type!,
                    context,
                    vy,
                    idVoyageRetour: vr,
                    tarif,
                    nbPlace);
              }),
            )
          : null,
    );
  }

  Widget buildVoyageCard() {
    return Card(
      child: ListTile(
        title: Text("Chargement..."),
        subtitle: Text("Chargement..."),
      ),
    );
  }

  Future<void> _openDialog(
      int type, BuildContext context, int idVoyage, int tarif, int nbPlace,
      {int? idVoyageRetour}) async {
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

    StreamSubscription? _sub;
    Future<void> _sendReservation(
        int type, BuildContext context, int idVoyage, int nbPlace,
        {int? idVoyageRetour}) async {
      final StatusController controller = Get.put(StatusController());
      // Vérifiez si les paramètres requis ne sont pas vides
      ReservationService()
          .addReservation(
              idVoyageRetour: idVoyageRetour,
              typeBillet: type,
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
      // print("Données envoyées: ${{
      //   "idVoyage": idVoyage.toString(),
      //   "passager": "${_prenomController.text} ${_nomController.text}",
      //   "telephone": _numeroController.text,
      //   "nbPlace": nbPlace.toString(),
      // }}");
    }

    // void initUniLinks() {
    //   // Commence à écouter les liens entrants
    //   _sub = linkStream.listen((String? link) {
    //     if (link != null) {
    //       if (link.contains("https://yadebus.com")) {
    //         // Si l'utilisateur revient via l'URL de retour (paiement réussi)
    //         _sendReservation(context, idVoyage, nbPlace);
    //       } else if (link.contains("https://yadebus.com/webpaydev/cancel")) {
    //         // Si l'utilisateur a annulé le paiement
    //         Snack.error(titre: "Alerte", message: "Paiement echouer");
    //       }
    //     }
    //   }, onError: (err) {
    //     // Gérer les erreurs
    //     debugPrint("Erreur log $err");
    //   });
    // }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
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
                          widget.type == 1 ? frais = frais * 2 : frais;
                          print(frais.toString());
                          print(widget.type.toString());
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
                              .then((value) => {})
                              .then((value) {
                            print(
                                'isUserInBrowser: ${controller.isUserInBrowser.value}');
                          });
                          // controller.updateIsBrowserStatus(true);
                          // Début de la vérification de l'utilisateur dans le navigateur
                          if (controller.isUserInBrowser.value == true) {
                            print(
                                'L\'utilisateur est toujours dans le navigateurrrrrrr.');
                          } else {
                            // Arrêtez les vérifications lorsque l'utilisateur quitte le navigateur
                            // await _sendReservation(context, idVoyage, nbPlace);
                            print(
                                'L\'utilisateur a quitté le navigateurrtttttttt.');
                            controller.sendResev == true
                                ? await _sendReservation(
                                    widget.type!,
                                    idVoyageRetour: widget.idVoyageRetour!,
                                    context,
                                    idVoyage,
                                    nbPlace)
                                : null;

                            // initUniLinks();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bleu,
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
        );
      },
    );
  }
}
