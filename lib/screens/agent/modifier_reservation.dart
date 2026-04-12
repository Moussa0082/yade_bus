// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../constant/constantes.dart';

// class ModifierReservationPage extends StatefulWidget {
//   @override
//   _ModifierReservationPageState createState() =>
//       _ModifierReservationPageState();
// }

// class _ModifierReservationPageState extends State<ModifierReservationPage> {
//   String? selectedReservation;
//   TextEditingController dateController = TextEditingController();

//   Future<void> _selectDate(BuildContext context) async {
//     DateTime currentDate = DateTime.now();
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: currentDate, // Date initiale
//       firstDate: currentDate, // Date minimale (date du jour)
//       lastDate: DateTime(2100), // Date maximale, vous pouvez la changer
//       helpText: 'Sélectionner une date ', // Texte d'aide
//       cancelText: 'Annuler',
//       confirmText: 'OK',
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light(), // Ajustez le thème si nécessaire
//           child: child!,
//         );
//       },
//     );

//     if (picked != currentDate && picked != null) {
//       // Si une date a été sélectionnée, formater le mois et le jour avec deux chiffres
//       String formattedDate =
//           "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

//       // Afficher la date formatée dans le TextFormField
//       dateController.text = formattedDate;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: bleuFoncer,
//         centerTitle: true,
//         leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: Icon(
//               Icons.arrow_back_ios,
//               color: blanc,
//             )),
//         title: Text(
//           "Modifier/Annuler une réservation",
//           style: TextStyle(color: blanc),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             DropdownButtonFormField<String>(
//               value: selectedReservation,
//               hint: Text("Sélectionner une réservation"),
//               items: ['Réservation N1', 'Réservation N2', 'Réservation N3']
//                   .map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (newValue) =>
//                   setState(() => selectedReservation = newValue),
//             ),
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                     child: ElevatedButton(
//                         onPressed: () {},
//                         child: Text(
//                           "Annuler",
//                           style: TextStyle(color: blanc),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red))),
//                 SizedBox(width: 10),
//                 Expanded(
//                     child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: bleuFoncer),
//                         onPressed: () {
//                           _selectDate(context);
//                         },
//                         child: Text(
//                           "Modifier",
//                           style: TextStyle(color: blanc),
//                         ))),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constantes.dart';

class ModifierReservationPage extends StatefulWidget {
  @override
  _ModifierReservationPageState createState() =>
      _ModifierReservationPageState();
}

class _ModifierReservationPageState extends State<ModifierReservationPage> {
  String? selectedReservation;
  TextEditingController dateController = TextEditingController();
  bool isModif = false;

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: DateTime(2100),
      helpText: 'Sélectionner une date ',
      cancelText: 'Annuler',
      confirmText: 'OK',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    if (picked != currentDate && picked != null) {
      String formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bleuFoncer,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: blanc,
          ),
        ),
        title: Text(
          "Modifier/Annuler une réservation",
          style: TextStyle(color: blanc),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedReservation,
              hint: Text("Sélectionner une réservation"),
              items: ['Réservation N1', 'Réservation N2', 'Réservation N3']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) =>
                  setState(() => selectedReservation = newValue),
            ),
            SizedBox(height: 20),
            isModif
                ? InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                          labelText: 'Date de modification',
                          // border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Annuler",
                      style: TextStyle(color: blanc),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bleuFoncer,
                    ),
                    onPressed: () {
                      setState(() {
                        isModif = true;
                      });
                      // Vous pouvez ajouter ici la logique de modification
                    },
                    child: Text(
                      "Modifier",
                      style: TextStyle(color: blanc),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
