// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/provider/AuthProvider.dart';
import 'package:yade_bus/screens/agent/liste_voyageur.dart';
import 'package:yade_bus/screens/agent/modifier_reservation.dart';
import 'package:yade_bus/screens/agent/scanne_ticket.dart';

import 'new_voyage_form_agent.dart';

// class AgentMainPage extends StatefulWidget {
//   @override
//   _AgentMainPageState createState() => _AgentMainPageState();
// }

// class _AgentMainPageState extends State<AgentMainPage> {
//   final List<Map<String, dynamic>> servicesCategories = [
//     {
//       "name": "Acheter ticket",
//       "dest": AcheterTicketPage(),
//       "icone": Icons
//           .shopping_cart, // Icône de panier d'achat pour l'achat de tickets
//     },
//     {
//       "name": "Scanner ticket",
//       "dest": ScannerTicketPage(),
//       "icone": Icons
//           .qr_code_scanner, // Icône de scanner de code QR pour scanner les tickets
//     },
//     {
//       "name": "Liste voyageur",
//       "dest": ListeVoyageursPage(),
//       "icone": Icons.people, // Icône de personnes pour la liste des voyageurs
//     },
//     {
//       "name": "Modifier/Annuler reservation",
//       "dest": ModifierReservationPage(),
//       "icone": Icons
//           .edit_calendar, // Icône de calendrier d'édition pour modifier/annuler les réservations
//     }
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: bleuFoncer,
//         leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: Icon(
//               Icons.arrow_back_ios,
//               color: blanc,
//             )),
//         title: Text(
//           'Dashboard',
//           style: TextStyle(color: blanc),
//         ),
//         centerTitle: true,
//       ),
//       body: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4, // Modifier pour 3 ou 4 colonnes
//                   crossAxisSpacing: 8.0,
//                   mainAxisSpacing: 8.0,
//                   childAspectRatio: 0.9,
//                 ),
//                 itemCount: servicesCategories.length,
//                 itemBuilder: (context, index) {
//                   return PaiementServiceCard(
//                     title: servicesCategories[index]['name'],
//                     dest: servicesCategories[index]['dest'],
//                     icon: servicesCategories[index]['icone'] ??
//                         Icons.help_outline,
//                   );
//                 },
//               ),
//             ),
//           ),

//         ],
//       ),
//     );
//   }
// }
class AgentMainPage extends StatefulWidget {
  const AgentMainPage({super.key});

  @override
  _AgentMainPageState createState() => _AgentMainPageState();
}

class _AgentMainPageState extends State<AgentMainPage> {
  final List<Map<String, dynamic>> servicesCategories = [
    {
      "name": "Acheter ticket",
      "dest": const NewVoyageFormAgent(),
      "icone": Icons.confirmation_number_rounded,
      "color": const Color(0xFF2967FF),
    },
    {
      "name": "Scanner ticket",
      "dest": ScannerTicketPage(),
      "icone": Icons.qr_code_scanner_rounded,
      "color": const Color(0xFF2967FF),
    },
    {
      "name": "Liste voyageurs",
      "dest": ListeVoyageursPage(),
      "icone": Icons.people_rounded,
      "color": const Color(0xFF2967FF),
    },
    {
      "name": "Modifier réservation",
      "dest": ModifierReservationPage(),
      "icone": Icons.edit_calendar_rounded,
      "color": const Color(0xFF2967FF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2967FF), Color(0xFF1A56DB)],
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, top + 14, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tableau de bord',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                        Text(
                          '${auth.user!.prenom} ${auth.user!.nom}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            title: const Text('Déconnexion',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            content: const Text(
                                'Voulez-vous vraiment vous déconnecter ?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(ctx, false),
                                child: const Text('Annuler',
                                    style: TextStyle(
                                        color: Color(0xFF6B7280))),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(ctx, true),
                                child: const Text('Déconnecter',
                                    style: TextStyle(
                                        color: Color(0xFFEF4444),
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          auth.logout();
                          Get.offAllNamed('/');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.logout_rounded,
                                color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Déconnexion',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Actions rapides',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: servicesCategories.length,
                      itemBuilder: (context, index) {
                        final item = servicesCategories[index];
                        final color = item['color'] as Color;
                        return GestureDetector(
                          onTap: () =>
                              Get.to(item['dest'] as Widget),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color:
                                        color.withValues(alpha: 0.12),
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    item['icone'] as IconData,
                                    color: color,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  item['name'] as String,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaiementServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? dest;

  const PaiementServiceCard(
      {super.key, required this.title, required this.icon, this.dest});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(dest, transition: Transition.rightToLeft);
      },
      child: Card(
        color: background,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Icon(
                icon,
                size: 30,
                color: bleuFoncer,
              ),
            ),
            const SizedBox(height: 3),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class TicketSalesChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       height: 600,
//       child: LineChart(
//         LineChartData(
//           lineBarsData: [
//             LineChartBarData(
//               spots: [
//                 FlSpot(1, 5),
//                 FlSpot(2, 25),
//                 FlSpot(3, 100),
//                 FlSpot(4, 75),
//                 FlSpot(5, 33),
//                 FlSpot(6, 80),
//                 FlSpot(7, 10),
//                 FlSpot(8, 15),
//                 FlSpot(9, 20),
//                 FlSpot(10, 35),
//                 FlSpot(11, 40),
//                 FlSpot(12, 50),
//               ],
//               isCurved: true,
//               color: Colors.blue,
//               barWidth: 3,
//               isStrokeCapRound: true,
//               belowBarData: BarAreaData(
//                 show: true,
//                 color: Colors.blue.withOpacity(0.3),
//               ),
//             ),
//           ],
//           titlesData: FlTitlesData(
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (value, meta) {
//                   switch (value.toInt()) {
//                     case 1:
//                       return Text('Jan');
//                     case 2:
//                       return Text('Feb');
//                     case 3:
//                       return Text('Mar');
//                     case 4:
//                       return Text('Apr');
//                     case 5:
//                       return Text('May');
//                     case 6:
//                       return Text('Jun');
//                     case 7:
//                       return Text('Jul');
//                     case 8:
//                       return Text('Aug');
//                     case 9:
//                       return Text('Sep');
//                     case 10:
//                       return Text('Oct');
//                     case 11:
//                       return Text('Nov');
//                     case 12:
//                       return Text('Dec');
//                     default:
//                       return Text('');
//                   }
//                 },
//               ),
//             ),
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: true),
//             ),
//           ),
//           gridData: FlGridData(show: true),
//           borderData: FlBorderData(
//             show: true,
//             border: Border.all(color: Colors.black, width: 1),
//           ),
//         ),
//       ),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Actions Agent'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AcheterTicketPage()),
//                 );
//               },
//               child: Text("Acheter un ticket pour un client"),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 16),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ScannerTicketPage()),
//                 );
//               },
//               child: Text("Scanner un ticket pour valider"),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 16),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ModifierReservationPage()),
//                 );
//               },
//               child: Text("Modifier ou annuler une réservation"),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 16),
//               ),
//             ),
//             SizedBox(height: 20),
            
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ListeVoyageursPage()),
//                 );
//               },
//               child: Text("Afficher la liste des voyageurs"),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }