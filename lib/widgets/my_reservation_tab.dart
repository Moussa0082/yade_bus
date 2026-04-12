import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/widgets/list_user_reserved_events.dart';
import 'package:yade_bus/widgets/user_reservation_list.dart';
class TabbedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Nombre d'onglets
      child: Scaffold(
        body: Column(
          children: [
            // Ajout du TabBar en haut
            Container(
              color: bleuFoncer, // Mettre une couleur de fond similaire à l'AppBar
              child: TabBar(
                indicatorColor: blanc,
                labelStyle: const TextStyle(color: bleu),
                tabs: [
                  Tab(
                    child: Text(
                      'Réservations',
                      style: TextStyle(color: blanc),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Evénements',
                      style: TextStyle(color: blanc),
                    ),
                  ),
                ],
              ),
            ),
            // Le reste du contenu, c'est-à-dire le TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  ReservationsTab(),
                  EventsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
