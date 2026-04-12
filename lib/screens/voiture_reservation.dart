import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:yade_bus/widgets/custom_btn.dart';

class VoitureReservation extends StatefulWidget {
  const VoitureReservation({super.key});

  @override
  State<VoitureReservation> createState() => _VoitureReservationState();
}

class _VoitureReservationState extends State<VoitureReservation> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _pickupTime = '10:00';
  String? _returnTime = '17:00';

  List<String> availableTimes = [
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
  ];

  String getNumberOfDays() {
    if (_startDate != null && _endDate != null) {
      int difference = _endDate!.difference(_startDate!).inDays + 1;
      return '$difference jour${difference > 1 ? 's' : ''} sélectionné${difference > 1 ? 's' : ''}';
    }
    return '0 jours sélectionnés';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date & Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),

            // Sélection de la plage de dates
            Text(
              'Date ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedDate: _startDate, // Initialiser la date de départ
              initialSelectedRange: PickerDateRange(
                  _startDate, _endDate), // Initialiser la plage de dates
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  setState(() {
                    _startDate = args.value.startDate;
                    _endDate = args.value.endDate;
                  });
                }
              },
              monthViewSettings: DateRangePickerMonthViewSettings(
                firstDayOfWeek:
                    1, // Lundi comme premier jour de la semaine (comme dans l'image)
              ),
              selectionColor: Colors.blue.withOpacity(
                  0.3), // Couleur de sélection pour les jours (comme dans l'image)
              rangeSelectionColor: Colors.blue
                  .withOpacity(0.1), // Couleur pour la plage de sélection
              todayHighlightColor: Colors.blue, // Couleur pour le jour actuel
              headerStyle: DateRangePickerHeaderStyle(
                textAlign: TextAlign.center, // Centrer le titre du mois
              ),
            ),

            Text(getNumberOfDays()),

            Spacer(),
            // Bouton de réservation
            btnLarge("Reserver", rouge, blanc, () {})
          ],
        ),
      ),
    );
  }
}
