class PlaceSuggestions {
  late String placeId;
  late String placeDescription;

  PlaceSuggestions.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    placeDescription = json['description'];
  }
}
