import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/controller/nbplace_st_up.dart';
import 'package:yade_bus/models/events.dart';
import 'package:yade_bus/services/orange_money_service.dart';
import 'package:yade_bus/services/reservation_service.dart';
import 'package:yade_bus/widgets/snack_bar.dart';

class DetailDivertissement extends StatefulWidget {
  dynamic evenement;
  DetailDivertissement({super.key, required this.evenement});

  @override
  State<DetailDivertissement> createState() => _DetailDivertissementState();
}

class _DetailDivertissementState extends State<DetailDivertissement> {
  final String defaultImage = "assets/images/div-default.jpg";
  final List<String> imageUrls = [
    'https://media.istockphoto.com/id/1806011581/fr/photo/des-jeunes-gens-heureux-et-ravis-de-danser-de-sauter-et-de-chanter-pendant-le-concert-de-leur.jpg?s=612x612&w=0&k=20&c=d1GQ5j33_Ie7DBUM0gTxQcaPhkEIQxkBlWO0TLNPB8M=',
    // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkc3Cya8bQnPu8OPdwzDna1nz0JU9b4icpAA&s',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: bleuFoncer,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.asset(
              //   "assets/images/div-default.jpg",
              //   height: 250,
              //   width: double.infinity,
              //   fit: BoxFit.cover,
              // ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 250,
                  viewportFraction: 1.0,
                  autoPlay: true,
                ),
                items: imageUrls.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.network(
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: const Icon(Icons.image_outlined,
                                size: 40, color: Colors.grey),
                          );
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Container(
                              height: 250,
                              // width: double.infinity,
                              color: Colors.grey.withOpacity(0.3),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              ),
                            );
                          }
                        },
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  );
                }).toList(),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: ListView(
                      children: [
                        Center(
                          child: Text(
                            "${widget.evenement['tarif'] ?? "inconnu"} F",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDetailRowWithIcon(Icons.person, "Organisateur",
                            widget.evenement['organisateur'] ?? "inconnu"),
                        _buildDetailRowWithIcon(Icons.location_city, "Ville",
                            widget.evenement['lieu'] ?? "inconnu"),
                        _buildDetailRowWithIcon(Icons.event, "Date Début",
                            widget.evenement['dateDebut'] ?? "inconnu"),
                        _buildDetailRowWithIcon(
                            Icons.event_available,
                            "Date Fin",
                            widget.evenement['dateFin'] ?? "inconnu"),
                        _buildDetailRowWithIcon(Icons.phone, "Téléphone",
                            widget.evenement['tel'] ?? "inconnu"),
                        _buildDetailRowWithIcon(Icons.category, "Catégorie",
                            widget.evenement['category'] ?? "inconnu"),
                        _buildDetailRowWithIcon(Icons.tag, "Tags",
                            widget.evenement['tags'] ?? "inconnu"),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Boutons en bas
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                      width: 120,
                      FontAwesomeIcons.whatsapp,
                      'WhatsApp',
                      Colors.green,
                      () =>
                          _launchURL('https://wa.me/?text=Check%20this%20car')),
                  _buildActionButton(
                      Icons.call,
                      'Appel',
                      bleu,
                      width: 94,
                      () => _launchURL('tel:82511723')),
                  _buildActionButton(
                      Icons.assignment_turned_in,
                      'Reserver',
                      bleu,
                      width: 112,
                      () {
                          int idEvent = widget.evenement['idEvent'] is String
                    ? int.parse(widget.evenement['idEvent'])
                    : widget.evenement['idEvent'];
               
                int tarif = widget.evenement['tarif'] is String
                    ? int.parse(widget.evenement['tarif'])
                    : widget.evenement['tarif'];
                int nbPlace = widget.evenement['nbPlaces'] is String
                    ? int.parse(widget.evenement['nbPlaces'])
                    : widget.evenement['nbPlaces'];
                
                _openDialog(     
                   context,
                    idEvent,
                    tarif,
                    nbPlace);
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithIcon(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(icon, color: bleuFoncer, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onPressed,
      {double? width}) {
    return SizedBox(
      width: width != null ? width : 110,
      height: 35,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 14, color: Colors.white),
        label: Text(label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 11)),
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: onPressed,
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Impossible de lancer $url';
    }
  }

  
  Future<void> _openDialog(BuildContext context, int idEvent, int tarif, int nbPlace,
      ) async {
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
        BuildContext context, int idEvent, int nbPlace) async {
      final StatusController controller = Get.put(StatusController());
      // Vérifiez si les paramètres requis ne sont pas vides
      ReservationService()
          .addTicketReservation(
              idEvent: idEvent,
              telephone: _numeroController.text,
              passager: "${_prenomController.text} ${_nomController.text}",
              nbPlaces: int.parse(_nbPlaceController.text))
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

    
    }
    

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
                        "Reservation de tickets",
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
                          print(frais.toString());
                          // print(widget.type.toString());
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
                                    context,
                                    idEvent,
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
