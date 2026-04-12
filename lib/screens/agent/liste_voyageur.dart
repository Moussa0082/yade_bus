import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constantes.dart';

class ListeVoyageursPage extends StatefulWidget {
  @override
  _ListeVoyageursPageState createState() => _ListeVoyageursPageState();
}

class _ListeVoyageursPageState extends State<ListeVoyageursPage> {
  // Données fictives pour les voyages et les voyageurs
  TextEditingController dateController = TextEditingController();

  List<Map<String, dynamic>> voyages = [
    {
      'depart': 'Bamako',
      'destination': 'Ségou',
      'date': '2024-06-01',
      'voyageurs': [
        {'nom': 'Alice', 'siege': 'A1'},
        {'nom': 'Bob', 'siege': 'B2'},
        {'nom': 'Charlie', 'siege': 'C3'},
      ],
    },
    {
      'depart': 'Ségou',
      'destination': 'Sikasso',
      'date': '2024-06-02',
      'voyageurs': [
        {'nom': 'David', 'siege': 'D4'},
        {'nom': 'Eve', 'siege': 'E5'},
      ],
    },
    {
      'depart': 'Sikasso',
      'destination': 'Kayes',
      'date': '2024-06-03',
      'voyageurs': [
        {'nom': 'Frank', 'siege': 'F6'},
        {'nom': 'Grace', 'siege': 'G7'},
        {'nom': 'Hannah', 'siege': 'H8'},
        {'nom': 'Ivy', 'siege': 'I9'},
      ],
    },
  ];

  String? selectedDepart;
  String? selectedDestination;
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate, // Date initiale
      firstDate: currentDate, // Date minimale (date du jour)
      lastDate: DateTime(2100), // Date maximale, vous pouvez la changer
      helpText: 'Sélectionner une date ', // Texte d'aide
      cancelText: 'Annuler',
      confirmText: 'OK',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(), // Ajustez le thème si nécessaire
          child: child!,
        );
      },
    );

    if (picked != currentDate && picked != null) {
      // Si une date a été sélectionnée, formater le mois et le jour avec deux chiffres
      String formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

      // Afficher la date formatée dans le TextFormField
      dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        title: const Text('Liste des Voyageurs',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Départ',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  value: selectedDepart,
                  items: voyages.map((voyage) {
                    return DropdownMenuItem<String>(
                      value: voyage['depart'],
                      child: Text(voyage['depart']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDepart = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Destination',
                  ),
                  value: selectedDestination,
                  items: voyages.map((voyage) {
                    return DropdownMenuItem<String>(
                      value: voyage['destination'],
                      child: Text(voyage['destination']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDestination = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: dateController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today,
                            color: Colors.blueGrey[400]),
                        hintText: "Sélectionner une date",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      //     validator: (val) {
                      // if (val == null || val.isEmpty) {
                      //   return "Veuillez choisir une date";
                      // } else {
                      //   return null;
                      // }
                      // }
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: voyages
                  .where((voyage) =>
                      (selectedDepart == null ||
                          voyage['depart'] == selectedDepart) &&
                      (selectedDestination == null ||
                          voyage['destination'] == selectedDestination) &&
                      (selectedDate == null ||
                          voyage['date'] ==
                              "${selectedDate!.toLocal()}".split(' ')[0]))
                  .fold<int>(
                      0,
                      (sum, voyage) =>
                          sum + (voyage['voyageurs'].length as int)),
              itemBuilder: (_, voyageurIndex) {
                final filteredVoyages = voyages
                    .where((voyage) =>
                        (selectedDepart == null ||
                            voyage['depart'] == selectedDepart) &&
                        (selectedDestination == null ||
                            voyage['destination'] == selectedDestination) &&
                        (selectedDate == null ||
                            voyage['date'] ==
                                "${selectedDate!.toLocal()}".split(' ')[0]))
                    .toList();

                if (filteredVoyages.isEmpty) {
                  return Container(); // Ne rien afficher si aucun résultat n'est trouvé
                }

                int currentVoyageIndex = 0;
                num currentVoyageurIndex = voyageurIndex;

                while (currentVoyageurIndex >=
                    filteredVoyages[currentVoyageIndex]['voyageurs'].length) {
                  currentVoyageurIndex -=
                      filteredVoyages[currentVoyageIndex]['voyageurs'].length;
                  currentVoyageIndex++;
                }

                final voyage = filteredVoyages[currentVoyageIndex];
                final voyageur = voyage['voyageurs'][currentVoyageurIndex];

                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(voyageur['nom']),
                  subtitle: Text('Destination: ${voyage['destination']}'),
                  trailing: Text('Siège ${voyageur['siege']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
