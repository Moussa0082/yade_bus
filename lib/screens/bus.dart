import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/screens/track_bus.dart';

class Bus extends StatefulWidget {
  const Bus({super.key});

  @override
  State<Bus> createState() => _BusState();
}

class _BusState extends State<Bus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Fond légèrement gris
      body: Column(
        children: [
          _buildHeader(), // Partie Orange
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                _buildBusCard("10 min", "Pod Karlovem", "Bernard Pub", true),
                _buildBusCard("05 min", "Pod Karlovem", "Bernard Pub", false),
                _buildBusCard("15 min", "Station Central", "Airport", false),
              ],
            ),
          ),
          // _buildBottomNavbar(),
        ],
      ),
    );
  }

  // HEADER ORANGE (Recherche)
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 30),
      decoration: const BoxDecoration(
        color: bleu, // Orange corail
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Icon(Icons.bus_alert, color: Colors.white),
                SizedBox(width: 10),
                Text("MYBUS",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18))
              ]),
              Icon(Icons.notifications_none, color: Colors.white),
            ],
          ),
          const SizedBox(height: 30),
          // Formulaire blanc
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Column(
              children: [
                _buildSearchInput(Icons.radio_button_checked, Colors.green,
                    "From", "Your location"),
                const Divider(height: 30, indent: 30),
                _buildSearchInput(Icons.location_on, Colors.blue, "To",
                    "Prague, Czech Republic"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Boutons en bas du header
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15)),
                  child: const Row(children: [
                    Icon(Icons.calendar_today, color: Colors.white, size: 18),
                    SizedBox(width: 10),
                    Text("Depart at: Now",
                        style: TextStyle(color: Colors.white))
                  ]),
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  Get.to(const TrackBus());
                },
                child: Container(
                  height: 55,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(
                      child: Text("GO",
                          style: TextStyle(
                              color: bleu,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // CARTE DE TRAJET (L'élément de la liste) ttttt
  Widget _buildBusCard(
      String minutes, String start, String end, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Departure on:",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(minutes,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E2432))),
                ],
              ),
              const Column(
                children: [
                  Text("Travel time: 15 min",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: 5),
                  Row(children: [
                    Icon(Icons.wb_sunny_outlined, size: 14),
                    Text(" 16:00", style: TextStyle(fontSize: 12)),
                    Icon(Icons.chevron_right, size: 14),
                    Icon(Icons.nightlight_round, size: 14),
                    Text(" 16:25", style: TextStyle(fontSize: 12))
                  ]),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8)),
                child: const Column(children: [
                  Icon(Icons.ac_unit, color: bleu, size: 16),
                  Text("AC",
                      style: TextStyle(
                          color: bleu,
                          fontSize: 10,
                          fontWeight: FontWeight.bold))
                ]),
              )
            ],
          ),
          const SizedBox(height: 20),
          _buildStopRow(Colors.green, start, "Oct 02, 16:00"),
          _buildStopRow(Colors.blue, end, "Oct 02, 16:25"),
          if (isSelected) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: bleu,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("BUY TICKET",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ]
        ],
      ),
    );
  }

  // WIDGETS UTILITAIRES
  Widget _buildSearchInput(
      IconData icon, Color color, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 15),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
        ]),
      ],
    );
  }

  Widget _buildStopRow(Color color, String name, String time) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 12),
        const SizedBox(width: 15),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Spacer(),
        Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
