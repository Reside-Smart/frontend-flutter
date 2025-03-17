// import 'package:geolocator/geolocator.dart';

// mixin GeoLocator {
//   Future<Position> determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       bool opened = await Geolocator.openLocationSettings();
//       if (!opened) {
//         return Future.error("Please enable location services to proceed.");
//       }
//       return Future.error('Location services are disabled.');
//     }

//     // Check the current permission status.
//     permission = await Geolocator.checkPermission();

//     // Handle permanently denied permissions by guiding the user to app settings.
//     if (permission == LocationPermission.deniedForever) {
//       bool opened = await Geolocator.openAppSettings();
//       if (!opened) {
//         return Future.error('Location permissions are permanently denied.');
//       }
//       return Future.error(
//         'Location permissions are permanently denied. Please enable them in the app settings.',
//       );
//     }
//     // Request permission if it is denied.
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     // Return the current position if permission is granted.
//     return await Geolocator.getCurrentPosition();
//   }
// }
