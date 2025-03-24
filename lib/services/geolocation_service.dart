import 'package:geolocator/geolocator.dart';

class GeolocationService {
  Future<Position?> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
  
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}