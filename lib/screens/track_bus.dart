import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackBus extends StatefulWidget {
  const TrackBus({super.key});

  @override
  State<TrackBus> createState() => _TrackBusState();
}

class _TrackBusState extends State<TrackBus> {
 
 
 // Position initiale (ex: Prague comme sur ton image)
  late GoogleMapController mapController;

  // 1. DÉFINITION DES TRACÉS (POLYLINES)
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  BitmapDescriptor? busIcon;
  static const LatLng _pointStart = LatLng(50.0850, 14.4378); // Bleu
  static const LatLng _pointMiddle = LatLng(50.0755, 14.4300); // Orange (Bus)
  static const LatLng _pointEnd = LatLng(50.0650, 14.4500); // Vert

  @override
  void initState() {
    super.initState();
    _loadIcons();
    _createPolylines();
    _createMarkers();
  }

  void _loadIcons() async {
    // Si tu as un fichier image pour le bus :
    busIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)), 'assets/bus_marker.png');
  }

  void _createPolylines() {
    setState(() {
      _polylines.addAll([
        // Segment Bleu (Départ -> Bus)
        const Polyline(
          polylineId: PolylineId('route_blue'),
          points: [_pointStart, _pointMiddle],
          color: Color(0xFF47A9FF),
          width: 6,
          jointType: JointType.round,
        ),
        // Segment Vert (Bus -> Arrivée)
        const Polyline(
          polylineId: PolylineId('route_green'),
          points: [_pointMiddle, _pointEnd],
          color: Color(0xFF4CAF50),
          width: 6,
          jointType: JointType.round,
        ),
      ]);
    });
  }

  void _createMarkers() {
    setState(() {
      // Point de départ (Bleu)
      _markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: _pointStart,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );

      // Le BUS (Orange)
      _markers.add(
        Marker(
          markerId: const MarkerId('bus'),
          position: _pointMiddle,
          // Utilise l'icône orange par défaut si tu n'as pas d'image asset
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: const InfoWindow(title: "Bus en mouvement"),
        ),
      );

      // Point d'arrivée (Vert)
      _markers.add(
        Marker(
          markerId: const MarkerId('end'),
          position: _pointEnd,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // CARTE
          GoogleMap(
            initialCameraPosition:
                const CameraPosition(target: _pointMiddle, zoom: 14),
            polylines: _polylines,
            markers: _markers,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) => mapController = controller,
          ),

          // HEADER (Titre & Retour)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              children: [
                _buildCircularButton(
                    Icons.arrow_back_ios_new, () => Navigator.pop(context)),
                const Expanded(
                  child: Text("Track your bus",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E2432))),
                ),
                const SizedBox(width: 45),
              ],
            ),
          ),

          // CARTE DE DÉTAILS
          _buildBottomCard(),
        ],
      ),
    );
  }

  Widget _buildBottomCard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Distance",
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                    Text("15 km",
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.green[50], shape: BoxShape.circle),
                  child: const Icon(Icons.share, color: Colors.green, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildStepIndicator(Colors.green, "Pod Karlovem", "Oct 02, 16:00",
                isFirst: true),
            _buildStepIndicator(Colors.blue, "Bernard Pub", "Oct 02, 16:25",
                isLast: true),
            const SizedBox(height: 25),

            // BOUTON BLEU DÉGRADÉ
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                    colors: [Color(0xFF47A9FF), Color(0xFF007AFF)]),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF007AFF).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6))
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent),
                icon: const Icon(Icons.phone_in_talk, color: Colors.white),
                label: const Text("CALL DRIVER",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(Color color, String title, String time,
      {bool isFirst = false, bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.3), width: 3),
                ),
                child: Center(
                    child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                            color: color, shape: BoxShape.circle))),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: Colors.grey[200])),
            ],
          ),
          const SizedBox(width: 15),
          Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(time,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
        child: Icon(icon, size: 20),
      ),
    );
  }
}
