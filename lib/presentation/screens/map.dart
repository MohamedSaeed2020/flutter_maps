import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/cubits/map_cubit/maps_cubit.dart';
import 'package:flutter_maps/data/models/place_details.dart';
import 'package:flutter_maps/data/models/place_directions.dart';
import 'package:flutter_maps/data/models/places_suggestions.dart';
import 'package:flutter_maps/presentation/widgets/map_widgets/distance_and_time.dart';
import 'package:flutter_maps/presentation/widgets/map_widgets/my_drawer.dart';
import 'package:flutter_maps/presentation/widgets/map_widgets/places_item.dart';
import 'package:flutter_maps/shared/constants/colors.dart';
import 'package:flutter_maps/shared/helpers/location_helpers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //variables
  static Position? position;
  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    bearing: 0.0,
    tilt: 0.0,
    zoom: 15.0,
    target: LatLng(position!.latitude, position!.longitude),
  );
  final Completer<GoogleMapController> _completer = Completer();
  FloatingSearchBarController fsbController = FloatingSearchBarController();
  List<PlaceSuggestions> placesSuggestions = [];

  ///These variables for place details
  late CameraPosition searchedPlaceCameraPosition;
  late PlaceDetails placeDetails;
  Set<Marker> markers = {};
  late PlaceSuggestions placeSuggestion;
  late Marker searchedPlaceMarker;
  late Marker currentLocationMarker;

  ///These variables for place directions
  PlaceDirections? placeDirections;
  late List<LatLng> polylinePoints;
  var isSearchedPlaceMarkerClicked = false;
  var isTimeAndDistanceVisible = false;
  late String time;
  late String distance;

  //methods

  ///These methods for place details

  void getSelectedPlaceDetails(PlaceSuggestions placeSuggestions) {
    final sessionToken = const Uuid().v4();
    BlocProvider.of<MapsCubit>(context)
        .emitPlaceDetailsState(placeSuggestions.placeId, sessionToken);
  }

  Widget buildSelectedPlaceDetailsBloc() {
    return BlocListener(
      listener: (context, state) {
        if (state is PlacesDetailsLoadedState) {
          placeDetails = state.placeDetails;
          goToSearchedPlace(placeDetails);
          getDirections(placeDetails);
        }
      },
      child: Container(),
    );
  }

  Future<void> goToSearchedPlace(PlaceDetails placeDetails) async {
    buildNewCameraPosition(placeDetails);
    GoogleMapController controller = await _completer.future;
    await controller.animateCamera(
        CameraUpdate.newCameraPosition(searchedPlaceCameraPosition));
    buildSearchedPlaceMarker();
  }

  void buildNewCameraPosition(PlaceDetails placeDetails) {
    searchedPlaceCameraPosition = CameraPosition(
      bearing: 0.0,
      tilt: 0.0,
      zoom: 15.0,
      target: LatLng(
        placeDetails.result.geometry.location.lat,
        placeDetails.result.geometry.location.lng,
      ),
    );
  }

  void buildSearchedPlaceMarker() {
    searchedPlaceMarker = Marker(
      markerId: const MarkerId('1'),
      position: searchedPlaceCameraPosition.target,
      infoWindow: InfoWindow(
        title: placeSuggestion.placeDescription,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      onTap: () {
        buildCurrentLocationMarker();
        // show time and distance
        setState(() {
          isSearchedPlaceMarkerClicked = true;
          isTimeAndDistanceVisible = true;
        });
      },
    );
    addMarkerToMarkersSetAndUpdateUi(searchedPlaceMarker);
  }

  void buildCurrentLocationMarker() {
    currentLocationMarker = Marker(
      markerId: const MarkerId('2'),
      position: _myCurrentLocationCameraPosition.target,
      infoWindow: const InfoWindow(
        title: 'My Current Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      onTap: () {},
    );
    addMarkerToMarkersSetAndUpdateUi(currentLocationMarker);
  }

  void addMarkerToMarkersSetAndUpdateUi(Marker marker) {
    setState(() {
      markers.add(marker);
    });
  }

  //*******************************************************//

  ///These methods for place suggestion

  Widget buildPlacesSuggestionsBloc() {
    return BlocBuilder<MapsCubit, MapsState>(builder: (context, state) {
      if (state is PlacesSuggestionsLoadedState) {
        placesSuggestions = state.placeSuggestions;
        if (placesSuggestions.isNotEmpty) {
          return buildPacesSuggestionsList(placesSuggestions);
        } else {
          return Container();
        }
      } else {
        return Container();
      }
    });
  }

  Widget buildPacesSuggestionsList(List<PlaceSuggestions> places) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            placeSuggestion = placesSuggestions[index];
            fsbController.close();
            getSelectedPlaceDetails(placeSuggestion);
            //clear previous polyline
            polylinePoints.clear();
            removeAllMarkersAndUpdateUI();
          },
          child: PlacesItem(place: places[index]),
        );
      },
      itemCount: places.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
    );
  }

  void removeAllMarkersAndUpdateUI(){
    setState(() {
      markers.clear();
    });
  }

  void getPlaceSuggestions(String placeKeyword) {
    final sessionToken = const Uuid().v4();
    BlocProvider.of<MapsCubit>(context)
        .emitPlaceSuggestionsState(placeKeyword, sessionToken);
  }

  //*******************************************************//

  ///These methods for place directions
  void getDirections(PlaceDetails placeDetails) {
    BlocProvider.of<MapsCubit>(context).emitPlaceDirectionsState(
      LatLng(position!.latitude, position!.longitude),
      LatLng(
        placeDetails.result.geometry.location.lat,
        placeDetails.result.geometry.location.lng,
      ),
    );
  }

  Widget buildPlacesDirectionsBloc() {
    return BlocListener(
      listener: (context, state) {
        if (state is PlacesDirectionsLoadedState) {
          placeDirections = state.placeDirections;
          getPolylinePoints(placeDirections);
        }
      },
      child: Container(),
    );
  }

  void getPolylinePoints(PlaceDirections? placeDirections) {
    polylinePoints = placeDirections!.polyLinePoints
        .map(
          (pointLatLng) => LatLng(
        pointLatLng.latitude,
        pointLatLng.longitude,
      ),
    )
        .toList();
  }

  //*******************************************************//


  void getCurrentLocation() {
    LocationHelpers.getCurrentLocation().then((position) {
      _MapScreenState.position = position;
    }).whenComplete(() {
      setState(() {});
    });
  }

  Widget buildMap() {
    return GoogleMap(
      initialCameraPosition: _myCurrentLocationCameraPosition,
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      markers: markers,
      onMapCreated: (GoogleMapController googleMapController) {
        _completer.complete(googleMapController);
      },
      polylines: placeDirections != null
          ? {
              Polyline(
                polylineId: const PolylineId('my_polyline'),
                color: Colors.black,
                width: 2,
                points: polylinePoints,
              ),
            }
          : {},
    );
  }

  Future<void> _goToMyCurrentLocation() async {
    GoogleMapController controller = await _completer.future;
    await controller.animateCamera(
        CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      controller: fsbController,
      width: isPortrait ? 600 : 500,
      openWidth: isPortrait ? 600 : 500,
      height: 48,
      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
      margins: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0.0),
      border: const BorderSide(
        style: BorderStyle.none,
      ),
      elevation: 6.0,
      hint: 'Find a place...',
      hintStyle: const TextStyle(fontSize: 18.0),
      queryStyle: const TextStyle(fontSize: 18.0),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      physics: const BouncingScrollPhysics(),
      /*Specify a custom transition to be used for
      animating between opened and closed stated.*/
      transition: CircularFloatingSearchBarTransition(),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,

      ///Very important
      debounceDelay: const Duration(milliseconds: 500),
      iconColor: MyColors.blue,
      onQueryChanged: (query) {
        getPlaceSuggestions(query);
        debugPrint('Query: $query');

        // Call your model, bloc, controller here.
      },
      onFocusChanged: (x) {
        //when you open search bar is true , when you close is false
        //hide time and distance row
        setState(() {
          isTimeAndDistanceVisible = false;
        });
        debugPrint('Focus: $x');
      },

      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Icon(
              Icons.place,
              color: Colors.black.withOpacity(0.6),
            ),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildPlacesSuggestionsBloc(),
                buildSelectedPlaceDetailsBloc(),
                buildPlacesDirectionsBloc(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Stack(
        //fit: StackFit.expand,
        children: [
          position != null
              ? buildMap()
              : const Center(
                  child: CircularProgressIndicator(
                    color: MyColors.blue,
                  ),
                ),
          buildFloatingSearchBar(),
          isSearchedPlaceMarkerClicked
              ?DistanceAndTime(isTimeAndDistanceVisible: isTimeAndDistanceVisible,placeDirections: placeDirections,)
              :Container(),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 8, 30),
        child: FloatingActionButton(
          backgroundColor: MyColors.blue,
          child: const Icon(
            Icons.place,
            color: Colors.white,
          ),
          onPressed: _goToMyCurrentLocation,
        ),
      ),
    );
  }
}
