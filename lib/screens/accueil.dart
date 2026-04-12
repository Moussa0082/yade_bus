import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/screens/cancel_voyage.dart';
import 'package:yade_bus/screens/divertissement.dart';
import 'package:yade_bus/screens/login/login.dart';
import 'package:yade_bus/screens/map.dart';
import 'package:yade_bus/screens/my_reservation.dart';
import 'package:yade_bus/widgets/colis_form.dart';
import 'package:yade_bus/widgets/location_voiture.dart';
import 'package:yade_bus/widgets/location_tab.dart';
import 'package:yade_bus/widgets/my_reservation_tab.dart';
import 'package:yade_bus/widgets/voyage_form.dart';
import 'package:yade_bus/widgets/voyage_tab.dart';

import '../widgets/slider_comp.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final List<String> imageList = [
    'assets/images/colis-im.jpeg',
    'assets/images/div-default.jpg',
    'assets/images/rservation.jpg',
    'assets/images/gr-p.png',
    'assets/images/voyage-vol.jpeg',
  ];

  final List<Map<String, dynamic>> menuItems = [
    {
      "title": "Reservation",
      "icon": CupertinoIcons.tickets,
      "route": "/reservation",
      "widget": VoyageTab(), // Widget placé avec une clé "widget"
    },
    {
      "title": "Divertissements/Events",
      "icon": FeatherIcons.volume2,
      "route": "/events",
      "widget": DivertissementScreen(), // Exemple pour une autre page
    },
    {
      "title": "Colis",
      "icon": CupertinoIcons
          .archivebox, // A filled box icon representing parcels or packages
      "route": "/colis",
      "widget": ColisTab(), // Example for another page
    },
    {
      "title": "Location",
      "icon": CupertinoIcons
          .cube_box, // A solid location pin icon representing location
      "route": "/location",
      "widget": LocationTab(), // Example for another page
    },

    // {
    //   "title": "Agences proches",
    //   "icon": CupertinoIcons.location_solid,
    //   "route": "/map",
    //   "widget": MapScreen(), // Exemple pour une autre page
    // },
    // {
    //   "title": "Annuler Voyage",
    //   "icon": CupertinoIcons.clear_circled,
    //   "route": "/annuler_voyage",
    //   "widget": CancelVoyage(), // Exemple pour une autre page
    // },
    // {
    //   "title": "Mes Reservations",
    //   "icon": CupertinoIcons.list_bullet,
    //   "route": "/mes_reservations",
    //   "widget": TabbedPage(), // Exemple pour une autre page
    // },
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bleuFoncer,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'Yade',
              style: TextStyle(color: blanc, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          // Bouton Se connecter
          // ElevatedButton.icon(
          //   onPressed: () {
          //     // Action pour le bouton
          //     Get.to(LoginPage(),
          //         transition: Transition.leftToRight,
          //         duration: Duration(seconds: 1));
          //   },
          //   icon: Icon(Icons.login, color: Colors.white),
          //   label: Text('Se connecter', style: TextStyle(color: Colors.white)),
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: bleu, // Couleur de fond
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //   ),
          // ),
          IconButton(
            onPressed: () {
              Get.to(const LoginPage(), transition: Transition.leftToRight);
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (_) => LoginScreen()));
            },
            icon: Icon(
              Icons.login,
              color: blanc,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 2),
            Image.asset(
                height: 150,
                fit: BoxFit.cover,
                width: double.infinity,
                "assets/images/image_r1.png"),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(menuItems[index]['widget']);
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => menuItems[index][
                      //         'widget'], // Naviguer vers la page associée au widget
                      //   ),
                      // );
                    },
                    child: buildCard(
                      menuItems[index]['title'],
                      menuItems[index]['icon'],
                      menuItems[index]['widget'],
                    ),
                  );
                },
              ),
            ),
            Center(
                child: Text(
              "Nos partenaires",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
            const SizedBox(
              height: 15,
            ),
            AgencySlider(),
          ],
        ),
      ),
    );
  }

  Widget buildCard(String text, IconData icon, Widget dest) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Icon(icon, color: bleuFoncer, size: 50)),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: bleuFoncer,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
