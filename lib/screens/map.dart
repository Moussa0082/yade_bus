import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yade_bus/models/direction.dart';
import 'package:yade_bus/services/direction_service.dart';

class MapSreen extends StatefulWidget {
  const MapSreen({super.key});

  @override
  State<MapSreen> createState() => _MapSreenState();
}

class _MapSreenState extends State<MapSreen> {
  
  
  //  GoogleMapController? _controller;
  // Position? _currentPosition;
  // List<Marker> _markers = [];
  // bool _isSatelliteView = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _getCurrentLocation();
  // }

  // Future<void> _getCurrentLocation() async {
  //   // Vérifie les autorisations pour la géolocalisation
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //   }

  //   if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
  //     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  //     setState(() {
  //       _currentPosition = position;
  //       // Déplace la caméra vers la position de l'utilisateur
  //       _controller?.animateCamera(CameraUpdate.newLatLng(
  //         LatLng(position.latitude, position.longitude),
  //       ));

  //       // Ajout de la position de l'utilisateur comme marqueur
  //       _markers.add(
  //         Marker(
  //           markerId: MarkerId("current_location"),
  //           position: LatLng(position.latitude, position.longitude),
  //           infoWindow: InfoWindow(title: "Vous êtes ici"),
  //           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //         ),
  //       );
  //     });

  //     // Ajoutez ici les points d'intérêt (marqueurs proches de la position de l'utilisateur)
  //     _addNearbyMarkers(position);
  //   }
  // }

  // // Ajoute des marqueurs à proximité de la position de l'utilisateur
  // void _addNearbyMarkers(Position position) {
  //   List<LatLng> nearbyLocations = [
  //     LatLng(position.latitude + 0.01, position.longitude + 0.01),
  //     LatLng(position.latitude - 0.01, position.longitude - 0.01),
  //     LatLng(position.latitude + 0.02, position.longitude + 0.01),
  //   ];

  //   for (var i = 0; i < nearbyLocations.length; i++) {
  //     _markers.add(
  //       Marker(
  //         markerId: MarkerId("marker_$i"),
  //         position: nearbyLocations[i],
  //         infoWindow: InfoWindow(title: "Point d'intérêt $i"),
  //         onTap: () => _showMarkerDetails(i),
  //       ),
  //     );
  //   }

  //   setState(() {}); // Mettre à jour la carte avec les nouveaux marqueurs
  // }

  // // Montre des détails lorsque l'utilisateur clique sur un marqueur
  // void _showMarkerDetails(int markerId) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Détails du point d'intérêt"),
  //         content: Text("Voici les détails du point d'intérêt $markerId."),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text("Fermer"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Carte en temps réel'),
  //       actions: [
  //         IconButton(
  //           icon: Icon(_isSatelliteView ? Icons.map : Icons.satellite),
  //           onPressed: () {
  //             setState(() {
  //               _isSatelliteView = !_isSatelliteView;
  //             });
  //           },
  //         ),
  //       ],
  //     ),
  //     body: _currentPosition == null
  //         ? const Center(child: CircularProgressIndicator())
  //         : GoogleMap(
  //             initialCameraPosition: CameraPosition(
  //               target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
  //               zoom: 15,
  //             ),
  //             mapType: _isSatelliteView ? MapType.satellite : MapType.normal,
  //             markers: Set.from(_markers),
  //             onMapCreated: (GoogleMapController controller) {
  //               _controller = controller;
  //             },
  //             myLocationEnabled: true, // Affiche l'icône de localisation de l'utilisateur
  //           ),
  //   );
  // }
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  late GoogleMapController _googleMapController;
  Marker? _origin; // Nullable
  Marker? _destination; // Nullable
  Directions? _info; // Nullable

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Google Maps'),
        actions: [
          if (_origin != null) // Vérification si _origin n'est pas null
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin!.position, // Accès avec !
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ORIGIN'),
            ),
          if (_destination != null) // Vérification si _destination n'est pas null
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination!.position, // Accès avec !
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('DEST'),
            )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              if (_origin != null) _origin!, // Utilisez le point d'exclamation !
              if (_destination != null) _destination!
            },
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info!.polylinePoints // Accès avec !
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onLongPress: _addMarker,
          ),
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${_info!.totalDistance}, ${_info!.totalDuration}', // Accès avec !
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController.animateCamera(
          _info != null
              ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0) // Accès avec !
              : CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        // Reset destination
        _destination = null;

        // Reset info
        _info = null;
      });
    } else {
      // Origin is already set
      // Set destination
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // Get directions
      final directions = await DirectionsRepository()
          .getDirections(origin: _origin!.position, destination: pos); // Utilisez !
      setState(() => _info = directions);
    }
  }

}