import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/widgets/events_reservation_detail.dart';

class EventsTab extends StatefulWidget {
  @override
  _EventsTabState createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> events = [];
  bool _isLoading = false;

  Future<void> _searchEvents() async {
    setState(() {
      _isLoading = true;
      events = [];
    });

    // Simuler le chargement des données
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      events = [
        {
          'numConfirmation': '123456',
          'dateReserv': '2025-03-01',
          'etat': 'Confirmée',
          'passager': 'John Doe'
        },
        {
          'numConfirmation': '789012',
          'dateReserv': '2025-02-28',
          'etat': 'Annulée',
          'passager': 'Jane Smith'
        },
        {
          'numConfirmation': '345678',
          'dateReserv': '2025-02-27',
          'etat': 'En attente',
          'passager': 'Mark Lee'
        },
      ]; // Remplacez par vos données
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(labelText: 'Rechercher des événements'),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: rouge),
              onPressed: _searchEvents,
              child: Text(
                'Rechercher',
                style: TextStyle(color: blanc),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? ListView.builder(
                    itemCount: 5, // Nombre de shimmer items
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListTile(
                          title: Container(
                            width: double.infinity,
                            height: 10.0,
                            color: Colors.white,
                          ),
                          subtitle: Container(
                            width: double.infinity,
                            height: 8.0,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return ListTile(
                        title: Text("Réservation ${event['numConfirmation']}"),
                        subtitle: Text("Date: ${event['dateReserv']}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EventReservationDetail(event: event),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
