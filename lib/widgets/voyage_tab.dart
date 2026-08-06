import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yade_bus/screens/cancel_voyage.dart';
import 'package:yade_bus/screens/map.dart';
import 'package:yade_bus/screens/reporter_voyage.dart';
import 'package:yade_bus/widgets/my_reservation_tab.dart';

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

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Billet',
      'icon': Icons.travel_explore_rounded,
      'page': NewVoyageForm(),
    },
    {
      'title': 'Annuler',
      'icon': Icons.cancel_outlined,
      'page': CancelVoyage(),
    },
    {
      'title': 'Reporter',
      'icon': Icons.edit_calendar_rounded,
      'page': ReporterVoyage(),
    },
    {
      'title': 'Agences',
      'icon': Icons.location_on_rounded,
      'page': MapScreen(),
    },
    {
      'title': 'Réservations',
      'icon': Icons.receipt_long_rounded,
      'page': TabbedPage(),
    },
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(context),
          _buildTabBar(),
          Expanded(
            child: _pages[_selectedIndex]['page'],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2967FF), Color(0xFF1A56DB)],
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, top + 14, 20, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Voyage',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_pages.length, (index) {
            final selected = _selectedIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF2967FF)
                      : const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF2967FF)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _pages[index]['icon'],
                      color: selected
                          ? Colors.white
                          : const Color(0xFF6B7280),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _pages[index]['title'],
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : const Color(0xFF6B7280),
                        fontSize: 13,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
