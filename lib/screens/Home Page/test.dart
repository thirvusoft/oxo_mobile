import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

import 'package:location/location.dart';
import 'package:oxo/constants.dart';
import 'package:vector_math/vector_math.dart';
import 'dart:math' show sin, cos, sqrt, atan2;

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  void initState() {
    // setCustomMarkerIcon();

    // super.initState();
    // double distanceInMeters =
    //     Geolocator.distanceBetween(37.4274684, -122.1698161, 137.422, -122.084);
    // double distanceInKiloMeters = distanceInMeters / 1000;
    // double roundDistanceInKM =
    //     double.parse((distanceInKiloMeters).toStringAsFixed(2));
    // print(roundDistanceInKM);
    //Use Geolocator to find the current location(latitude & longitude)

//Calculating the distance between two points without Geolocator plugin
    getDistance() {
      double pLat = 22.8965265;
      double pLng = 76.2545445;
      double earthRadius = 6371000;

      var dLat = radians(pLat - 37.4274684);
      var dLng = radians(pLng - -122.1698161);
      var a = sin(dLat / 2) * sin(dLat / 2) +
          cos(radians(37.4274684)) *
              cos(radians(pLat)) *
              sin(dLng / 2) *
              sin(dLng / 2);
      var c = 2 * atan2(sqrt(a), sqrt(1 - a));
      var d = earthRadius * c;
      print(d); //d is the distance in meters
    }

//Calculating the distance between two points with Geolocator plugin
    // getDistance() {
    //   final double distance = Geolocator.distanceBetween(
    //       pLat, pLng, _currentPosition.latitude, _currentPosition.longitude);
    //   print(distance);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
