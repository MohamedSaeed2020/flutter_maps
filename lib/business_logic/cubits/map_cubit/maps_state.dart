part of 'maps_cubit.dart';

@immutable
abstract class MapsState {}

class MapsInitial extends MapsState {}

class PlacesSuggestionsLoadedState extends MapsState {
  final List<PlaceSuggestions> placeSuggestions;

  PlacesSuggestionsLoadedState(this.placeSuggestions);
}

class PlacesDetailsLoadedState extends MapsState {
  final PlaceDetails placeDetails;

  PlacesDetailsLoadedState(this.placeDetails);
}

class PlacesDirectionsLoadedState extends MapsState {
  final PlaceDirections placeDirections;

  PlacesDirectionsLoadedState(this.placeDirections);
}
