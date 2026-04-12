
import 'package:flutter/material.dart';
import 'package:yade_bus/constant/constantes.dart';

class EventReservationDetail extends StatelessWidget {
  final Map<String, String> event;

  const EventReservationDetail({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, 
        backgroundColor: bleuFoncer,
        title: Text('Détails'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Numéro de Confirmation', event['numConfirmation']!),
            Divider(),
            _buildRow('Date de Réservation', event['dateReserv']!),
            Divider(),
            _buildRow('État', event['etat']!),
            Divider(),
            _buildRow('Passager', event['passager']!),
            Divider(),
            _buildRow('Nombre de Places', '2'),
            Divider(),
            _buildRow('Provenance', 'XYZ'),
            Divider(),
            _buildRow('Option Billet', 'Première classe'),
            Divider(),
            _buildRow('Agence', 'Agence ABC'),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligne aux deux extrémités
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
