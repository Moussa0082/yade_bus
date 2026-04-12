// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/provider/AuthProvider.dart';
import 'package:yade_bus/screens/agent/acheter_ticket.dart';
import 'package:yade_bus/screens/agent/liste_voyageur.dart';
import 'package:yade_bus/screens/agent/modifier_reservation.dart';
import 'package:yade_bus/screens/agent/scanne_ticket.dart';

import '../../widgets/custom_btn.dart';
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
      "icone": Icons
          .shopping_cart, // Icône de panier d'achat pour l'achat de tickets
    },
    {
      "name": "Scanner ticket",
      "dest": ScannerTicketPage(),
      "icone": Icons
          .qr_code_scanner, // Icône de scanner de code QR pour scanner les tickets
    },
    {
      "name": "Liste voyageur",
      "dest": ListeVoyageursPage(),
      "icone": Icons.people, // Icône de personnes pour la liste des voyageurs
    },
    {
      "name": "Modifier/Annuler réservation",
      "dest": ModifierReservationPage(),
      "icone": Icons
          .edit_calendar, // Icône de calendrier d'édition pour modifier/annuler les réservations
    }
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: bleu,
        image: DecorationImage(
          image: const AssetImage("assets/images/gr-p.png"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(bleu.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: bleuFoncer,
          // leading: IconButton(
          //     onPressed: () {
          //       Get.back();
          //     },
          //     icon: const Icon(
          //       Icons.arrow_back_ios,
          //       color: blanc,
          //     )),
          title: Text(
            "Bienvenue ${auth.user!.prenom} ${auth.user!.nom}",
            style: const TextStyle(color: blanc),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Image.asset(
                height: 200,
                fit: BoxFit.cover,
                width: double.infinity,
                "assets/images/logo.png"),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.60,
                decoration: const BoxDecoration(
                  color: blanc,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                    // 16.0
                  ),
                ),
                padding: const EdgeInsets.all(
                    16.0), // Ajouter un padding pour l'espacement global

                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Permet d'occuper toute la largeur
                    children: [
                      Expanded(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                2, // Deux colonnes pour une apparence plus large
                            crossAxisSpacing:
                                16.0, // Espacement entre les colonnes
                            mainAxisSpacing:
                                16.0, // Espacement entre les lignes
                            childAspectRatio:
                                1, // Ratio pour rendre les cartes carrées
                          ),
                          itemCount: servicesCategories.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: background,
                                borderRadius: BorderRadius.circular(
                                    16.0), // Bords arrondis
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                    offset:
                                        Offset(0, 3), // Crée une ombre légère
                                  ),
                                ],
                                border: Border.all(
                                  color: bleuFoncer, // Bordure avec couleur
                                  width: 1.5, // Épaisseur de la bordure
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Get.to(servicesCategories[index]['dest']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        servicesCategories[index]['icone'] ??
                                            Icons.help_outline,
                                        size: 48,
                                        color: bleuFoncer, // Couleur de l'icône
                                      ),
                                      const SizedBox(height: 16.0),
                                      Text(
                                        servicesCategories[index]['name'],
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: bleuFoncer, // Couleur du texte
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
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
            ),
          ],
        ),
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