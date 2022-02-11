import 'package:geolocator/geolocator.dart';
class LocationHelpers {

  ///Get Current Location
  static Future<Position> getCurrentLocation() async {
    bool isLocationServicesEnabled =
        await Geolocator.isLocationServiceEnabled();
    if (!isLocationServicesEnabled) {
      await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition(
      //the default accuracy is best
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
