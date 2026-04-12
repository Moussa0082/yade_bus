import 'package:flutter/material.dart';
import 'package:yade_bus/constant/constantes.dart';

class ReporterVoyage extends StatefulWidget {
  const ReporterVoyage({super.key});

  @override
  State<ReporterVoyage> createState() => _ReporterVoyageState();
}

class _ReporterVoyageState extends State<ReporterVoyage> {
  
   TextEditingController dateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? confirmationNumber;
  String? userNumber;
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
      // appBar: AppBar(
      //   title: Text("Annuler Voyage"),
      //   backgroundColor: Colors.blue,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Numéro de confirmation",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le numéro de confirmation';
                  }
                  return null;
                },
                onSaved: (value) {
                  confirmationNumber = value;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Numéro de l'utilisateur",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre numéro d\'utilisateur';
                  }
                  return null;
                },
                onSaved: (value) {
                  userNumber = value;
                },
              ),
              SizedBox(height: 16),
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
              SizedBox(height: 16),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      // Vous pouvez ensuite envoyer ces informations au serveur ou effectuer l'annulation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Voyage reporter avec succès')),
                      );
                    }
                  },
                  child: Text(
                    "Reporter le Voyage",
                    style: TextStyle(color: blanc),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }