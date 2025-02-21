
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_gmaps/.env.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yade_bus/models/direction.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio? _dio;

  DirectionsRepository({ Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio!.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': 'AIzaSyAGfHUMe4txPpExG8-VbN8FM0igoFBJsl4',
        // 'key': 'AIzaSyCyaGsgH-BPLXTAaOJI5dNVbGcBk1DXPYs',
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}