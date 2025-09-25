import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../core/errors/exceptions.dart';

class LocationService {
  static Future<Position> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const PermissionException('Location services are disabled');
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw const PermissionException('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw const PermissionException(
          'Location permissions are permanently denied',
        );
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      if (e is PermissionException) rethrow;
      throw PermissionException('Failed to get location: ${e.toString()}');
    }
  }

  static Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        return 'Unknown location';
      }

      final place = placemarks.first;
      final components = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.postalCode,
      ].where((component) => component != null && component.isNotEmpty);

      return components.join(', ');
    } catch (e) {
      throw ServerException('Failed to get address: ${e.toString()}');
    }
  }

  static Future<List<Location>> getCoordinatesFromAddress(String address) async {
    try {
      return await locationFromAddress(address);
    } catch (e) {
      throw ServerException('Failed to get coordinates: ${e.toString()}');
    }
  }

  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}
