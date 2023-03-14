import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  late StreamSubscription<Position> streamSubscription;

  @override
  void onInit() {
    super.onInit();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      streamSubscription = Geolocator.getPositionStream().listen((event) {
        latitude.value = event.latitude;
        longitude.value = event.longitude;
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
