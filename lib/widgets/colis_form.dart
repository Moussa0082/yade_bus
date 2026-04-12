import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yade_bus/constant/constantes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class EnvoiColisTab extends StatefulWidget {
  const EnvoiColisTab({super.key});

  @override
  State<EnvoiColisTab> createState() => _EnvoiColisTabState();
}

class _EnvoiColisTabState extends State<EnvoiColisTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      // backgroundColor: bleu,
      //   title: Row(
      //     children: [
      //       Image.asset(
      //         'assets/images/logo.png',
      //         height: 40,
      //       ),
      //       const SizedBox(width: 10),
      //       const Text(
      //         'Yade',
      //         style: TextStyle(color: blanc, fontWeight: FontWeight.bold),
      //       ),
      //     ],
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
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
                    prefixIcon: Icon(Icons.person, color: Colors.blueGrey[400]),
                    hintText: "Nom de l'expéditeur",
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
                    prefixIcon:
                        Icon(Icons.location_on, color: Colors.blueGrey[400]),
                    hintText: "Adresse de destination",
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
                    prefixIcon: Icon(Icons.badge, color: Colors.blueGrey[400]),
                    hintText: "Poids du colis",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                // const Spacer(flex: 2),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Action pour envoyer le colis
                      },
                      icon: const Icon(
                        Icons.send,
                        color: blanc,
                      ),
                      label: const Text(
                        'Envoyer',
                        style: TextStyle(color: blanc),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bleu, // Couleur principale
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ColisTab extends StatefulWidget {
  const ColisTab({super.key});

  @override
  State<ColisTab> createState() => _ColisTabState();
}

class _ColisTabState extends State<ColisTab>
    with SingleTickerProviderStateMixin {
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
        bottom: TabBar(
          dividerColor: blanc,
          indicatorColor: blanc,
          labelStyle: const TextStyle(color: bleu),
          controller: _tabController,
          tabs: const [
            // Onglet Voyage avec icône et texte alignés horizontalement
            Tab(
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centrer le texte et l'icône
                children: [
                  Icon(
                    Icons.send,
                    color: blanc,
                  ),
                  SizedBox(width: 4), // Espacement entre l'icône et le texte
                  Text(
                    'Envoi colis',
                    style: TextStyle(
                        color: blanc,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Onglet Divertissements avec icône et texte alignés horizontalement
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.gps_fixed_sharp, color: blanc),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Tracker colis',
                      style: TextStyle(
                          color: blanc,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: bleu,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: blanc,
            )),
        title: const Text(
          'Colis',
          style: TextStyle(color: blanc, fontWeight: FontWeight.bold),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Voyage Tab content
          EnvoiColisTab(),
          ReceptionColisTab()
          // const LocationScreen()
        ],
      ),
    );
  }
}

// class ReceptionColisTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Colis Réceptionnés',
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: ListView.builder(
//               itemCount: 5, // Exemple: 5 colis
//               itemBuilder: (context, index) {
//                 return Card(
//                   child: ListTile(
//                     leading: const Icon(Icons.inbox, color: Colors.blue),
//                     title: Text('Colis #${index + 1}'),
//                     subtitle: const Text('Statut: En attente de réception'),
//                     trailing: ElevatedButton(
//                       onPressed: () {
//                         // Action pour confirmer la réception
//                       },
//                       style: ElevatedButton.styleFrom(backgroundColor: bleu),
//                       child: const Text(
//                         'Recevoir',
//                         style: TextStyle(color: blanc),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class ReceptionColisTab extends StatefulWidget {
  @override
  _ReceptionColisTabState createState() => _ReceptionColisTabState();
}

class _ReceptionColisTabState extends State<ReceptionColisTab> {
  final TextEditingController _trackingNumberController =
      TextEditingController();
  GoogleMapController? _mapController;
  Marker? _parcelMarker;
  Polyline? _routePolyline;
  LatLng? _currentPosition;
  LatLng? _parcelPosition; // Position du colis simulée

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  Future<void> _getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _trackParcel() {
    if (_trackingNumberController.text.isEmpty) {
      return;
    }

    // Simuler la localisation du colis en fonction du numéro de suivi
    // Vous pouvez modifier cela pour interroger une API réelle.
    setState(() {
      _parcelPosition = LatLng(_currentPosition!.latitude + 0.02,
          _currentPosition!.longitude + 0.02);

      // Ajouter un marqueur pour le colis
      _parcelMarker = Marker(
        markerId: MarkerId('parcel'),
        position: _parcelPosition!,
        infoWindow:
            InfoWindow(title: 'Colis #${_trackingNumberController.text}'),
      );

      // Tracer le chemin (polyline) entre la position actuelle et le colis
      _routePolyline = Polyline(
        polylineId: PolylineId('route'),
        points: [_currentPosition!, _parcelPosition!],
        color: Colors.blue,
        width: 5,
      );

      // Centrer la carte sur le colis
      _mapController?.animateCamera(CameraUpdate.newLatLng(_parcelPosition!));
    });
  }

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
          const SizedBox(height: 20),
          TextField(
            controller: _trackingNumberController,
            decoration: const InputDecoration(
              labelText: 'Numéro de Suivi',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _trackParcel,
              child: const Text(
                'Tracker',
                style: TextStyle(color: blanc),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _buildMap(),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return _currentPosition == null
        ? const Center(child: CircularProgressIndicator())
        : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition!,
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: {
              Marker(
                markerId: const MarkerId('current_location'),
                position: _currentPosition!,
                infoWindow: const InfoWindow(title: 'Vous êtes ici'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              ),
              if (_parcelMarker != null) _parcelMarker!,
            },
            polylines: _routePolyline != null ? {_routePolyline!} : {},
          );
  }
}

class ColisTabScreen extends StatefulWidget {
  @override
  _ColisTabScreenState createState() => _ColisTabScreenState();
}

class _ColisTabScreenState extends State<ColisTabScreen>
    with SingleTickerProviderStateMixin {
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
        title: const Text('Gestion de Colis'),
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
