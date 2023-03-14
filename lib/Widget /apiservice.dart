import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var address = ''.obs;
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

      streamSubscription =
          Geolocator.getPositionStream().listen((Position event) {
        latitude.value = event.latitude;
        longitude.value = event.longitude;
        getAddressFromLatLang(event);
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> newPlace = await GeocodingPlatform.instance
        .placemarkFromCoordinates(position.latitude, position.longitude,
            localeIdentifier: "en");

    Placemark place = newPlace[0];
    address.value = '${place.postalCode}';
  }
}
