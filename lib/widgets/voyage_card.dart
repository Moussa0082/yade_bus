import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:uni_links3/uni_links.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/services/orange_money_service.dart';
import 'package:yade_bus/services/reservation_service.dart';
import 'package:yade_bus/widgets/snack_bar.dart';

import '../controller/nbplace_st_up.dart';

// class VoyageCard extends StatefulWidget {
//   final Map<String, dynamic> voyageData;

//   VoyageCard({required this.voyageData});
//   @override
//   State<VoyageCard> createState() => _VoyageCardState();
// }

// class _VoyageCardState extends State<VoyageCard> {
//   StreamSubscription? _sub;

//   @override
//   void dispose() {
//     _sub?.cancel();
//     // Arrête d'observer l'état de l'application

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String formatDate(String? date) {
//       if (date == null || date.isEmpty) return "Non spécifiée";
//       try {
//         final parsedDate = DateTime.parse(date); // Format attendu: yyyy-MM-dd
//         return DateFormat('dd-MM-yyyy')
//             .format(parsedDate); // Formatage en jj-mm-aaaa
//       } catch (e) {
//         return "Format invalide";
//       }
//     }

//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: LayoutBuilder(builder: (context, snapshot) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header avec nom de la compagnie et état
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     widget.voyageData["compagnieNom"] != null &&
//                             widget.voyageData["compagnieNom"].isNotEmpty
//                         ? widget.voyageData["compagnieNom"]
//                         : "Compagnie inconnue",
//                     style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black),
//                   ),
// Container(
//   padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//   decoration: BoxDecoration(
//     color: bleu,
//     borderRadius: BorderRadius.circular(20),
//   ),
//   child: TextButton.icon(
//     onPressed: () {
//       int vy = widget.voyageData["idVoyage"] is String
//           ? int.parse(widget.voyageData["idVoyage"])
//           : widget.voyageData["idVoyage"];
//       int tarif = widget.voyageData["tarif"] is String
//           ? int.parse(widget.voyageData["tarif"])
//           : widget.voyageData["tarif"];
//       int nbPlace = widget.voyageData["nbPlace"] is String
//           ? int.parse(widget.voyageData["nbPlace"])
//           : widget.voyageData["nbPlace"];
//       debugPrint(
//           "Réservation pour ${widget.voyageData["compagnieNom"]}");
//       _openDialog(context, vy, tarif, nbPlace);
//     },
//     icon: const Icon(
//       Icons.event_seat,
//       size: 16,
//       color: blanc,
//     ),
//     label: const Text(
//       "Réserver",
//       style: TextStyle(
//         color: blanc,
//         fontSize: 14,
//       ),
//     ),
//     style: TextButton.styleFrom(
//       padding: const EdgeInsets.symmetric(
//           horizontal: 8, vertical: 6),
//       minimumSize: const Size(80, 30),
//       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//     ),
//   ),
// ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               // Informations de départ et d'arrivée
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     // crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Départ : ${widget.voyageData["departNom"]}"),
//                       Text("Heure : ${widget.voyageData["heure"]}"),
//                       Text(
//                           "Date : ${formatDate(widget.voyageData["dateDepart"])}"),
//                     ],
//                   ),
//                   Column(
//                     // crossAxisAlignmentß: CrossAxisAlignment.start,
//                     children: [
//                       Text("Dest : ${widget.voyageData["destNom"]}"),
//                       Text("Heure : ${widget.voyageData["harrivee"]}"),
//                       Text(
//                           "Date : ${formatDate(widget.voyageData["dateArrivee"])}"),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               // Ligne bleue avec icône de voiture au centre
//               Row(
//                 children: [
//                   Expanded(
//                     child: Divider(
//                       thickness: 2,
//                       color: Colors.blue,
//                       endIndent: 8,
//                     ),
//                   ),
//                   Icon(Icons.directions_car, color: Colors.blue, size: 24),
//                   Expanded(
//                     child: Divider(
//                       thickness: 2,
//                       color: Colors.blue,
//                       indent: 8,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               // Tarif et nombre de places
//               Text(
//                 "Tarif : ${widget.voyageData["tarif"]} FCFA",
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 "Nombre de places disponible : ${widget.voyageData["nbPlace"]}",
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }
class VoyageCard extends StatelessWidget {
  final Map<String, dynamic> voyageData;
  final bool isSelected;

  VoyageCard({
    required this.voyageData,
    this.isSelected = false,
  });

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "Non spécifiée";
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return "Format invalide";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue.shade100 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    voyageData["compagnieNom"] ?? "Compagnie inconnue",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                // Expanded(
                //   child: Container(
                //     padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                //     decoration: BoxDecoration(
                //       color: bleu,
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     child: TextButton.icon(
                //       onPressed: () {
                //         int vy = voyageData["idVoyage"] is String
                //             ? int.parse(voyageData["idVoyage"])
                //             : voyageData["idVoyage"];
                //         int tarif = voyageData["tarif"] is String
                //             ? int.parse(voyageData["tarif"])
                //             : voyageData["tarif"];
                //         int nbPlace = voyageData["nbPlace"] is String
                //             ? int.parse(voyageData["nbPlace"])
                //             : voyageData["nbPlace"];
                //         debugPrint(
                //             "Réservation pour ${voyageData["compagnieNom"]}");
                //         _openDialog(context, vy, tarif, nbPlace);
                //       },
                //       icon: const Icon(
                //         Icons.event_seat,
                //         size: 16,
                //         color: blanc,
                //       ),
                //       label: const Text(
                //         "Réserver",
                //         style: TextStyle(
                //           color: blanc,
                //           fontSize: 14,
                //         ),
                //       ),
                //       style: TextButton.styleFrom(
                //         padding: const EdgeInsets.symmetric(
                //             horizontal: 8, vertical: 6),
                //         minimumSize: const Size(80, 30),
                //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Départ - Arrivée",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              "${voyageData["dateDepart"] ?? "Départ inconnue"} - ${voyageData["dateArrivee"] ?? "Arrivée inconnue"}",
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${voyageData["heure"] ?? "Départ inconnue"} - ${voyageData["harrivee"] ?? "Arrivée inconnue"}",
                ),
                Text(_calculateDuration(
                    voyageData["heure"], voyageData["harrivee"])),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${voyageData["nbPlace"] ?? 0} places restantes"),
                Text(" ${voyageData["tarif"] ?? "inconnu"} F"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.wifi, size: 16),
                    SizedBox(width: 4),
                    Icon(Icons.tv, size: 16),
                    SizedBox(width: 4),
                    Icon(Icons.airline_seat_recline_normal, size: 16),
                  ],
                ),
                Text("Climatisé"),
                // Text(" ${voyageData["tarif"] ?? "N/A"}"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _calculateDuration(String? departure, String? arrival) {
    if (departure == null || arrival == null) return "Durée inconnue";

    try {
      final departureTime = DateFormat('H:mm').parse(departure);
      final arrivalTime = DateFormat('H:mm').parse(arrival);
      final duration = arrivalTime.difference(departureTime);

      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return "${hours}h ${minutes}m";
    } catch (e) {
      return "Durée invalide";
    }
  }
}


// Future<void> _openDialog(
//     BuildContext context, int idVoyage, int tarif, int nbPlace) async {
//   final _formKey = GlobalKey<FormState>();
//   final _nomController = TextEditingController();
//   final _prenomController = TextEditingController();
//   final _numeroController = TextEditingController();
//   // final _adresseController = TextEditingController();
//   final _nbPlaceController = TextEditingController();

//   // OrangeMoneyService().makePayment(merchantKey: "e9afd305",
//   // orderId: "cmd_1", amount: 200000,
//   //  returnUrl: "https://yadebus.com", cancelUrl: "https://yadebus.com/webpaydev/cancel",
//   //   notifUrl: "https://yadebus.com/webpaydev/notif", reference: "ref-xyz.456");

//   StreamSubscription? _sub;
//   Future<void> _sendReservation(
//       BuildContext context, int idVoyage, int nbPlace) async {
//     final StatusController controller = Get.put(StatusController());
//     // Vérifiez si les paramètres requis ne sont pas vides
//     ReservationService()
//         .addReservation(
//             idVoyage: idVoyage,
//             telephone: _numeroController.text,
//             passager: "${_prenomController.text} ${_nomController.text}",
//             nbPlace: int.parse(_nbPlaceController.text))
//         .then((response) {
//       Get.back(); // Ferme le dialogue si succès
//       if (response.statusCode == 200) {
//         controller.updateStatus(true);
//         Snack.success(
//           titre: "Succès",
//           message: "Réservation effectuée avec succès !",
//         );
//       } else {
//         // Affiche un message d'erreur sans fermer le dialogue
//         Snack.error(
//           titre: "Erreur",
//           message: "Une erreur est survenue veuillez réessayer plus tard",
//         );
//       }
//     }).catchError((error) {
//       // Gère les exceptions (par exemple, problème de connexion)
//       Snack.error(
//         titre: "Erreur",
//         message: " Une erreur est survenue veuillez réessayer plus tard ",
//       );
//     });

//     // try {
//     print("Données envoyées: ${{
//       "idVoyage": idVoyage.toString(),
//       "passager": "${_prenomController.text} ${_nomController.text}",
//       "telephone": _numeroController.text,
//       "nbPlace": nbPlace.toString(),
//     }}");
//   }

//   // void initUniLinks() {
//   //   // Commence à écouter les liens entrants
//   //   _sub = linkStream.listen((String? link) {
//   //     if (link != null) {
//   //       if (link.contains("https://yadebus.com")) {
//   //         // Si l'utilisateur revient via l'URL de retour (paiement réussi)
//   //         _sendReservation(context, idVoyage, nbPlace);
//   //       } else if (link.contains("https://yadebus.com/webpaydev/cancel")) {
//   //         // Si l'utilisateur a annulé le paiement
//   //         Snack.error(titre: "Alerte", message: "Paiement echouer");
//   //       }
//   //     }
//   //   }, onError: (err) {
//   //     // Gérer les erreurs
//   //     debugPrint("Erreur log $err");
//   //   });
//   // }

//   showModalBottomSheet(
//     isScrollControlled: true,
//     context: context,
//     builder: (BuildContext context) {
//       return SafeArea(
//         child: Form(
//           key: _formKey,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10, right: 10),
//                   child: Align(
//                     alignment: Alignment.topRight,
//                     child: IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 20),
//                     child: Text(
//                       "Reservation",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Champs du formulaire...
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10),
//                   child: Text("Prénom",
//                       style: TextStyle(color: Colors.black, fontSize: 18)),
//                 ),
//                 TextFormField(
//                   controller: _prenomController,
//                   decoration: InputDecoration(
//                     hintText: "Entrez votre prénom",
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                   ),
//                   keyboardType: TextInputType.text,
//                   validator: (value) =>
//                       value!.isEmpty ? "Entrez votre prénom" : null,
//                 ),
//                 const SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10),
//                   child: Text("Nom *",
//                       style: TextStyle(color: Colors.black, fontSize: 18)),
//                 ),
//                 TextFormField(
//                   controller: _nomController,
//                   decoration: InputDecoration(
//                     hintText: "Entrez votre nom",
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                   ),
//                   keyboardType: TextInputType.text,
//                   validator: (value) =>
//                       value!.isEmpty ? "Entrez votre nom" : null,
//                 ),
//                 const SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10),
//                   child: Text("Numéro *",
//                       style: TextStyle(color: Colors.black, fontSize: 18)),
//                 ),

//                 TextFormField(
//                   controller: _numeroController,
//                   decoration: InputDecoration(
//                     hintText: "Entrez votre numéro de téléphone",
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                   ),
//                   keyboardType:
//                       TextInputType.number, // Permet le clavier numérique
//                   inputFormatters: [
//                     FilteringTextInputFormatter
//                         .digitsOnly, // Autorise uniquement les chiffres
//                   ],
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Le numéro est requis';
//                     } else if (value.length < 8) {
//                       return 'Minimum 8 chiffres requis';
//                     } else if (value.length > 11) {
//                       return 'Maximum 11 chiffres autorisés';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10),
//                   child: Text("Nombre de places *",
//                       style: TextStyle(color: Colors.black, fontSize: 18)),
//                 ),
//                 TextFormField(
//                   controller: _nbPlaceController,
//                   inputFormatters: [
//                     FilteringTextInputFormatter
//                         .digitsOnly, // Autorise uniquement les chiffres
//                   ],
//                   decoration: InputDecoration(
//                     hintText: "Nombre de places",
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) =>
//                       value!.isEmpty ? "Entrez le nombre de places" : null,
//                 ),
//                 const SizedBox(height: 10),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (_formKey.currentState!.validate()) {
//                         double frais =
//                             tarif * double.parse(_nbPlaceController.text);
//                         final StatusController controller =
//                             Get.put(StatusController());
//                         OrangeMoneyService()
//                             .makePayment(
//                                 merchantKey: "e9afd305",
//                                 amount: frais,
//                                 returnUrl: "https://yadebus.com",
//                                 cancelUrl:
//                                     "https://yadebus.com/webpaydev/cancel",
//                                 notifUrl: "https://yadebus.com/webpaydev/notif",
//                                 reference: "ref-xyz.456")
//                             .then((value) => {})
//                             .then((value) {
//                           print(
//                               'isUserInBrowser: ${controller.isUserInBrowser.value}');
//                         });
//                         // controller.updateIsBrowserStatus(true);
//                         // Début de la vérification de l'utilisateur dans le navigateur
//                         if (controller.isUserInBrowser.value == true) {
//                           print(
//                               'L\'utilisateur est toujours dans le navigateurrrrrrr.');
//                         } else {
//                           // Arrêtez les vérifications lorsque l'utilisateur quitte le navigateur
//                           // await _sendReservation(context, idVoyage, nbPlace);
//                           print(
//                               'L\'utilisateur a quitté le navigateurrtttttttt.');
//                           controller.sendResev == true
//                               ? await _sendReservation(
//                                   context, idVoyage, nbPlace)
//                               : null;

//                           // initUniLinks();
//                         }
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: bleu,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15)),
//                       minimumSize: const Size(310, 45),
//                     ),
//                     child: const Text(
//                       "Réserver",
//                       style: TextStyle(
//                           fontSize: 20,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
