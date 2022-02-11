import 'package:bloc/bloc.dart';
import 'package:flutter_maps/data/models/place_details.dart';
import 'package:flutter_maps/data/models/place_directions.dart';
import 'package:flutter_maps/data/models/places_suggestions.dart';
import 'package:flutter_maps/data/repositories/place_suggestions_repositories.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  PlaceSuggestionsRepositories placeSuggestionsRepositories;

  MapsCubit(this.placeSuggestionsRepositories) : super(MapsInitial());

  void emitPlaceSuggestionsState(String placeKeyword, String sessionToken) {
    placeSuggestionsRepositories
        .fetchPlaceSuggestions(placeKeyword, sessionToken)
        .then((placeSuggestions) {
      emit(PlacesSuggestionsLoadedState(placeSuggestions));
    });
  }

  void emitPlaceDetailsState(String placeId, String sessionToken) {
    placeSuggestionsRepositories
        .fetchPlaceDetails(placeId, sessionToken)
        .then((placeDetails) {
      emit(PlacesDetailsLoadedState(placeDetails));
    });
  }

  void emitPlaceDirectionsState(LatLng origin, LatLng destination) {
    placeSuggestionsRepositories
        .fetchPlaceDirections(origin, destination)
        .then((placeDirections) {
      emit(PlacesDirectionsLoadedState(placeDirections));
    });
  }
}
