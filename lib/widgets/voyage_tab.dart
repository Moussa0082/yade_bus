import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/screens/cancel_voyage.dart';
import 'package:yade_bus/screens/map.dart';
import 'package:yade_bus/screens/reporter_voyage.dart';
import 'package:yade_bus/widgets/my_reservation_tab.dart';
import 'package:yade_bus/widgets/user_reservation_list.dart';
import 'package:yade_bus/widgets/voyage_form.dart';

import 'new_voyage_form.dart';

// class VoyageTab extends StatefulWidget {
//   const VoyageTab({super.key});

//   @override
//   State<VoyageTab> createState() => _VoyageTabState();
// }

// class _VoyageTabState extends State<VoyageTab> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 5, // Nombre d'onglets
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//               onPressed: () {
//                 Get.back();
//               },
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 color: blanc,
//               )),
//           centerTitle: true,
//           backgroundColor: bleuFoncer,
//           title: const Text(
//             'Yade',
//             style: TextStyle(color: blanc, fontWeight: FontWeight.bold),
//           ),
//           bottom:
//               // TabBar(
//               //   isScrollable: true,
//               //   tabs: [
//               //     Tab(text: 'Billet Voyage'),
//               //     Tab(text: 'Reporter Voyage'),
//               //     Tab(text: 'Annuler Voyage'),
//               //     Tab(text: 'Mes reservations'),
//               //   ],
//               // ),
//               TabBar(
//             labelPadding: EdgeInsets.only(
//                 left: 0,
//                 right: 20), // Définit un padding global pour les onglets
//             isScrollable: true,
//             indicatorColor: blanc,
//             labelStyle: const TextStyle(color: bleu),
//             tabs: [
//               Tab(
//                 child: Text(
//                   'Billet Voyage',
//                   style: TextStyle(color: blanc),
//                 ),
//               ),
//               Tab(
//                 child: Text(
//                   'Reporter Voyage',
//                   style: TextStyle(color: blanc),
//                 ),
//               ),
//               Tab(
//                 child: Text(
//                   'Annuler Voyage',
//                   style: TextStyle(color: blanc),
//                 ),
//               ),
//               Tab(
//                 child: Text(
//                   'Mes reservations',
//                   style: TextStyle(color: blanc),
//                 ),
//               ),
//               Tab(
//                 child: Text(
//                   'Agence proches',
//                   style: TextStyle(color: blanc),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             VoyageForm(),
//             ReporterVoyage(),
//             CancelVoyage(),
//             TabbedPage(),
//             MapScreen(),
//           ],
//         ),
//       ),
//     );
//   }
// }

class VoyageTab extends StatefulWidget {
  const VoyageTab({super.key});

  @override
  State<VoyageTab> createState() => _VoyageTabState();
}

class _VoyageTabState extends State<VoyageTab> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _canScrollLeft = false;
  bool _canScrollRight =
      true; // Initialisation supposant qu'il y a du contenu à droite

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Billet Voyage',
      'icon': Icons.travel_explore,
      'page': NewVoyageForm(), // Remplacez par votre page
    },
    {
      'title': 'Annuler Voyage',
      'icon': Icons.cancel,
      'page': CancelVoyage(), // Remplacez par votre page
    },
    {
      'title': 'Reporter Voyage',
      'icon': Icons.calendar_today,
      'page': ReporterVoyage(), // Remplacez par votre page
    },
    {
      'title': 'Agence proches',
      'icon': Icons.location_on,
      'page': MapScreen(), // Remplacez par votre page
    },
    {
      'title': 'Mes reservations',
      'icon': Icons.list_alt,
      'page': TabbedPage(), // Remplacez par votre page
    },
  ];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_checkScroll);

    // Vérifie la position après le rendu initial
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkScroll());
  }

  void _checkScroll() {
    if (!_scrollController.hasClients) return;

    setState(() {
      _canScrollLeft = _scrollController.position.pixels > 0;
      _canScrollRight = _scrollController.position.pixels <
          _scrollController.position.maxScrollExtent;
    });
  }

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.position.pixels - 100,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.position.pixels + 100,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: blanc),
        ),
        centerTitle: true,
        backgroundColor: bleuFoncer,
        title: const Text(
          'Yade',
          style: TextStyle(
            color: blanc,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(43),
          child: Container(
            height: 50,
            decoration: BoxDecoration(color: blanc),
            child: Stack(
              children: [
                // Liste défilante horizontale
                Positioned.fill(
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: _selectedIndex == index ? bleuFoncer : bleu,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                        child: InkWell(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _pages[index]['icon'],
                                color: _selectedIndex == index
                                    ? blanc
                                    : Colors.grey[200],
                                size: 28,
                              ),
                              SizedBox(width: 8),
                              Text(
                                _pages[index]['title'],
                                style: TextStyle(
                                  color: _selectedIndex == index
                                      ? blanc
                                      : Colors.grey[200],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Bouton Scroll à gauche (si nécessaire)
                if (_canScrollLeft)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.white.withOpacity(0)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: IconButton(
                        onPressed: _scrollLeft,
                        icon: Icon(Icons.chevron_left,
                            color: bleuFoncer, size: 30),
                      ),
                    ),
                  ),
                // Bouton Scroll à droite (si nécessaire)
                if (_canScrollRight)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white.withOpacity(0), Colors.white],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: IconButton(
                        onPressed: _scrollRight,
                        icon: Icon(Icons.chevron_right,
                            color: bleuFoncer, size: 30),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Ajout du SingleChildScrollView
        child: Column(
          children: [
            // Page correspondante
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  80, // Ajustez la hauteur de la page
              child: _pages[_selectedIndex]['page'],
            ),
          ],
        ),
      ),
    );
  }
}
