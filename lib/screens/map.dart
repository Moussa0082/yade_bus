// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapScreen extends StatefulWidget {
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController _googleMapController;
//   Marker? _origin;
//   bool _isLoading = true;
//   LatLng _currentPosition = LatLng(0, 0);
//   List<Place> _places = [];

//   @override
//   void initState() {
//     super.initState();
//     _determinePosition().then((position) {
//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//         _isLoading = false;
//         _populateNearbyPlaces();
//       });
//     });
//   }

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Les services de localisation sont désactivés.');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Les permissions de localisation sont refusées.');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Les permissions de localisation sont refusées de manière permanente.');
//     }

//     return await Geolocator.getCurrentPosition();
//   }

//   void _populateNearbyPlaces() {
//     _places = [
//       Place(
//           name: "Compagnie A",
//           address: "123 Rue A",
//           latLng: LatLng(
//               _currentPosition.latitude + 0.05, _currentPosition.longitude)),
//       Place(
//           name: "Compagnie B",
//           address: "456 Rue B",
//           latLng: LatLng(_currentPosition.latitude - 0.03,
//               _currentPosition.longitude + 0.02)),
//       Place(
//           name: "Compagnie C",
//           address: "789 Rue C",
//           latLng: LatLng(
//               _currentPosition.latitude, _currentPosition.longitude - 0.04)),
//       // Ajouter d'autres lieux ici
//     ];

//     setState(() {});
//   }

//   void _showPlaceDetails(Place place) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(place.name),
//           content: Text(
//               'Adresse: ${place.address}\nCoordonnées: ${place.latLng.latitude}, ${place.latLng.longitude}'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Fermer'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _googleMapController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool bToggle = true;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Maps'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Stack(
//               children: [
//                 GoogleMap(
//                   initialCameraPosition:
//                       CameraPosition(target: _currentPosition, zoom: 14.0),
//                   onMapCreated: (controller) =>
//                       _googleMapController = controller,
//                   markers: {
//                     Marker(
//                       markerId: MarkerId('current_location'),
//                       position: _currentPosition,
//                       infoWindow: InfoWindow(title: 'Vous êtes ici'),
//                       icon: BitmapDescriptor.defaultMarkerWithHue(
//                           BitmapDescriptor.hueBlue),
//                     ),
//                     for (var place in _places)
//                       Marker(
//                         // icon: BitmapDescriptor.defaultMarkerWithHue((bToggle)
//                         //     ? BitmapDescriptor.hueYellow
//                         //     : BitmapDescriptor.hueBlue),
//                         markerId: MarkerId(place.name),
//                         position: place.latLng,
//                         infoWindow: InfoWindow(title: place.name),
//                         onTap: () => _showPlaceDetails(place),
//                       )
//                   },
//                 ),
//               ],
//             ),
//     );
//   }
// }

// class Place {
//   final String name;
//   final String address;
//   final LatLng latLng;

//   Place({required this.name, required this.address, required this.latLng});
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yade_bus/constant/constantes.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _googleMapController;
  Marker? _origin;
  bool _isLoading = true;
  LatLng _currentPosition = LatLng(0, 0);
  List<Place> _places = [];

  @override
  void initState() {
    super.initState();
    _determinePosition().then((position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
        _populateNearbyPlaces();
      });
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Les services de localisation sont désactivés.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Les permissions de localisation sont refusées.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Les permissions de localisation sont refusées de manière permanente.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _populateNearbyPlaces() {
    _places = [
      Place(
          name: "Rimbo",
          address: "123 Rue A",
          numero: "20-22-21-09",
          latLng: LatLng(
              _currentPosition.latitude + 0.05, _currentPosition.longitude)),
      Place(
          name: "Diarra",
          address: "456 Rue B",
          numero: "20-02-21-01",
          latLng: LatLng(_currentPosition.latitude - 0.03,
              _currentPosition.longitude + 0.02)),
      Place(
          name: "Sonef",
          address: "789 Rue C",
          numero: "20-29-245-08",
          latLng: LatLng(
              _currentPosition.latitude, _currentPosition.longitude - 0.04)),
    ];

    setState(() {});
  }

  // Calculer la distance entre la position actuelle et un lieu
  double _calculateDistance(LatLng destination) {
    return Geolocator.distanceBetween(
      _currentPosition.latitude,
      _currentPosition.longitude,
      destination.latitude,
      destination.longitude,
    );
  }

  // Afficher la distance et les informations dans un BottomSheet
  void _showPlaceDetails(Place place) {
    double distance = _calculateDistance(place.latLng);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Détails de ${place.name}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Adresse: ${place.address}'),
                SizedBox(height: 10),
                Text('Distance: ${distance.toStringAsFixed(2)} mètres'),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  Future<BitmapDescriptor> createCustomMarkerBitmap(String text) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    const double markerWidth = 150;
    const double markerHeight = 80;

    final Paint paint = Paint()..color = Colors.white;

    // Dessiner un fond pour le marqueur
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0.0, 0.0, markerWidth, markerHeight),
        Radius.circular(10.0),
      ),
      paint,
    );

    // Dessiner le texte à l'intérieur du marqueur
    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    painter.layout();
    painter.paint(
        canvas,
        Offset(markerWidth / 2 - painter.width / 2,
            markerHeight / 2 - painter.height / 2));

    final img = await pictureRecorder
        .endRecording()
        .toImage(markerWidth.toInt(), markerHeight.toInt());

    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: bleuFoncer,
      //   leading: IconButton(
      //       onPressed: () {
      //         Get.back();
      //       },
      //       icon: Icon(
      //         Icons.arrow_back_ios,
      //         color: blanc,
      //       )),
      //   centerTitle: true,
      //   title: Text(
      //     'Agence proches',
      //     style: TextStyle(color: blanc),
      //   ),
      // ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _currentPosition, zoom: 14.0),
                  onMapCreated: (controller) =>
                      _googleMapController = controller,
                  markers: {
                    Marker(
                      markerId: MarkerId('current_location'),
                      position: _currentPosition,
                      infoWindow: InfoWindow(title: 'Vous êtes ici'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
                    ),
                    for (var place in _places)
                      Marker(
                        markerId: MarkerId(place.name),
                        position: place.latLng,
                        infoWindow: InfoWindow(
                            title: place.name, snippet: place.numero),
                        // onTap: () => _showPlaceDetails(place),
                      )
                  },
                ),
              ],
            ),
    );
  }

  Future<BitmapDescriptor> _createCustomMarkerIcon(String placeName) async {
    final Widget widget = Text(
      placeName,
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
    return await createCustomMarkerBitmap(placeName);
  }
}

class Place {
  final String name;
  final String address;
  final String numero;
  final LatLng latLng;

  Place(
      {required this.name,
      required this.address,
      required this.numero,
      required this.latLng});
}
