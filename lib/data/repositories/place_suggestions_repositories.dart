import 'package:flutter_maps/data/models/place_details.dart';
import 'package:flutter_maps/data/models/place_directions.dart';
import 'package:flutter_maps/data/models/places_suggestions.dart';
import 'package:flutter_maps/data/web_services/place_web_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceSuggestionsRepositories {
  final PlaceWebServices placeWebServices;

  PlaceSuggestionsRepositories(this.placeWebServices);

  Future<List<PlaceSuggestions>> fetchPlaceSuggestions(
    String placeKeyword,
    String sessionToken,
  ) async {
    final suggestions = await placeWebServices.fetchPlaceSuggestions(
      placeKeyword,
      sessionToken,
    );
    return suggestions
        .map((suggestion) => PlaceSuggestions.fromJson(suggestion))
        .toList();
  }

  Future<PlaceDetails> fetchPlaceDetails(
    String placeId,
    String sessionToken,
  ) async {
    final placeDetails = await placeWebServices.fetchPlaceDetails(
      placeId,
      sessionToken,
    );

    return PlaceDetails.fromJson(placeDetails);
  }

  Future<PlaceDirections> fetchPlaceDirections(
    LatLng origin,
    LatLng destination,
  ) async {
    final placeDirections = await placeWebServices.fetchPlaceDirections(
      origin,
      destination,
    );

    return PlaceDirections.fromJson(placeDirections);
  }
}
