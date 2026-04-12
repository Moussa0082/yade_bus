import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yade_bus/constant/constantes.dart';

class ReservationDetailsPage extends StatelessWidget {
  final Map<String, String> reservation;

  const ReservationDetailsPage({Key? key, required this.reservation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bleuFoncer,
        leading: IconButton(
            onPressed: Get.back,
            icon: Icon(
              Icons.arrow_back_ios,
              color: blanc,
            )),
        centerTitle: true,
        title: Text('Détails de la Réservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow(
                'Numéro de Confirmation', reservation['numConfirmation']!),
            Divider(),
            _buildRow('Date de Réservation', reservation['dateReserv']!),
            Divider(),
            _buildRow('État', reservation['etat']!),
            Divider(),
            _buildRow('Passager', reservation['passager']!),
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
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Aligne aux deux extrémités
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
