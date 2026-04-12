import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/screens/divertissement.dart';
import 'package:yade_bus/screens/login/login.dart';
import 'package:yade_bus/widgets/colis_form.dart';
import 'package:yade_bus/widgets/location_voiture.dart';
import 'package:yade_bus/widgets/voyage_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        actions: const [],
        bottom: TabBar(
          dividerColor: blanc,
          indicatorColor: bleu,
          labelStyle: const TextStyle(color: bleu),
          controller: _tabController,
          tabs: const [
            // Onglet Voyage avec icône et texte alignés horizontalement
            Tab(
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centrer le texte et l'icône
                children: [
                  Icon(
                    Icons.travel_explore_outlined,
                    color: blanc,
                  ),
                  SizedBox(width: 4), // Espacement entre l'icône et le texte
                  Text(
                    'Voyage',
                    style: TextStyle(
                        color: blanc,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Onglet Divertissements avec icône et texte alignés horizontalement
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FeatherIcons.volume2, color: blanc),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Events',
                      style: TextStyle(
                          color: blanc,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),

            // Onglet Colis avec icône et texte alignés horizontalement
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FeatherIcons.package, color: blanc),
                  SizedBox(width: 4),
                  Text(
                    'Colis',
                    style: TextStyle(
                        color: blanc,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Voyage Tab content
          VoyageForm(),
          DivertissementScreen(),
          ColisTabScreen(),
          // const LocationScreen()
        ],
      ),
    );
  }
}
