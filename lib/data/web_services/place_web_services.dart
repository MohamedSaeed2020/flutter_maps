import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_maps/shared/constants/strings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceWebServices {
  late Dio dio;

  PlaceWebServices() {
    BaseOptions options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,
    );

    dio = Dio(options);
  }

  Future<List<dynamic>> fetchPlaceSuggestions(String placeKeyword,
      String sessionToken,) async {
    Map<String, dynamic> queryParameters = {
      'input': placeKeyword,
      'key': googleMapsApi,
      'sessiontoken': sessionToken,
      'type': 'address',
      'components': 'country:eg',
    };
    try {
      Response response = await dio.get(
        placeSuggestionsBaseUrl,
        queryParameters: queryParameters,
      );
      log(response.data['predictions'].toString());
      log(response.data['error_message'].toString());
      log(response.statusCode.toString());
      return response.data['predictions'];
    } catch (error) {
      log(error.toString());
      return [];
    }
  }

  Future<dynamic> fetchPlaceDetails(String placeId,
      String sessionToken,) async {
    Map<String, dynamic> queryParameters = {
      'place_id': placeId,
      'key': googleMapsApi,
      'sessiontoken': sessionToken,
      'fields': 'geometry',
    };
    try {
      Response response = await dio.get(
        placeDetailsBaseUrl,
        queryParameters: queryParameters,
      );
      log(response.data.toString());
      log(response.statusCode.toString());
      return response.data;
    } catch (error) {
      log(error.toString());
      return Future.error('Place Details Error Is: $error',
          StackTrace.fromString('Place Details Error Stack Trace'));
    }
  }

  Future<dynamic> fetchPlaceDirections(LatLng origin,
      LatLng destination,) async {
    Map<String, dynamic> queryParameters = {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${origin.latitude},${origin.longitude}',
      'key': googleMapsApi,
    };
    try {
      Response response = await dio.get(
        placeDirectionsBaseUrl,
        queryParameters: queryParameters,
      );
      log(response.data.toString());
      log(response.statusCode.toString());
      return response.data;
    } catch (error) {
      log(error.toString());
      return Future.error('Place Details Error Is: $error',
          StackTrace.fromString('Place Details Error Stack Trace'));
    }
  }
}
