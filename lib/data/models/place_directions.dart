import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDirections {
  //the box around the directions
  late LatLngBounds bounds;

  //the points that pass through the polyline
  late List<PointLatLng> polyLinePoints;
  late String totalDistance;
  late String totalDuration;

  PlaceDirections(
    this.bounds,
    this.polyLinePoints,
    this.totalDistance,
    this.totalDuration,
  );

  factory PlaceDirections.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json['routes'][0]);
    final northEast = data['bounds']['northeast'];
    final southWest = data['bounds']['southwest'];
    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(southWest['lat'], southWest['lng']),
      northeast: LatLng(northEast['lat'], northEast['lng']),
    );

    late final String distance;
    late final String duration;
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }
    final apiPolyLinePoints = data['overview_polyline']['points'];
    PolylinePoints polylinePoints = PolylinePoints();
    return PlaceDirections(bounds,
        polylinePoints.decodePolyline(apiPolyLinePoints), distance, duration);
  }
}
