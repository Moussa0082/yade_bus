import 'package:flutter/material.dart';
import 'package:yade_bus/constant/constantes.dart';



class EnvoiColisTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Center(
           child: const Text(
              'Envoyer un Colis',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
         ),
         const SizedBox(height: 20),
        TextFormField(
                     validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veuillez entrer le nom de l'expéditeur";
                      } else {
                        return null;
                      }
                      },
                    decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person,
                                color: Colors.blueGrey[400]),
                            hintText:  "Nom de l'expéditeur",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                  ),
          const SizedBox(height: 20),
        TextFormField(
                     validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veuillez entrer l'adresse de destination";
                      } else {
                        return null;
                      }
                      },
                    decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_on,
                                color: Colors.blueGrey[400]),
                            hintText:  "Adresse de destination",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                  ),
         const SizedBox(height: 20),
       TextFormField(
                     validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Veuillez saisir le poids du colis";
                      } else {
                        return null;
                      }
                      },
                    decoration: InputDecoration(
                            prefixIcon: Icon(Icons.badge,
                                color: Colors.blueGrey[400]),
                            hintText:  "Poids du colis",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                  ),
         const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Action pour envoyer le colis
            },
            icon: const Icon(Icons.send ,color: blanc,),
            label: const Text('Envoyer' , style: TextStyle(color: blanc),),
            style: ElevatedButton.styleFrom(
              backgroundColor: bleu, // Couleur principale
            ),
          ),
        ],
      ),
    );
  }
}

class ReceptionColisTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         const Text(
            'Colis Réceptionnés',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
         const  SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Exemple: 5 colis
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.inbox, color: Colors.blue),
                    title: Text('Colis #${index + 1}'),
                    subtitle: const Text('Statut: En attente de réception'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Action pour confirmer la réception
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: bleu),
                      child: const Text('Recevoir', style: TextStyle(color: blanc),),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ColisTabScreen extends StatefulWidget {
  @override
  _ColisTabScreenState createState() => _ColisTabScreenState();
}

class _ColisTabScreenState extends State<ColisTabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:const Text('Gestion de Colis'),
        bottom: TabBar(
          dividerColor: bleu,
          indicatorColor: bleu,
          labelStyle: const TextStyle(color: bleu),
          controller: _tabController,
          tabs: const [
            Tab(text: 'Envoi de Colis', icon: Icon(Icons.send)),
            Tab(text: 'Réception de Colis', icon: Icon(Icons.inbox)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          EnvoiColisTab(),
          ReceptionColisTab(),
        ],
      ),
    );
  }
}
