import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

import 'package:location/location.dart';
import 'package:oxo/constants.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  void initState() {
    // setCustomMarkerIcon();

    super.initState();
    double distanceInMeters =
        Geolocator.distanceBetween(37.4274684, -122.1698161, 137.422, -122.084);
    double distanceInKiloMeters = distanceInMeters / 1000;
    double roundDistanceInKM =
        double.parse((distanceInKiloMeters).toStringAsFixed(2));
    print(roundDistanceInKM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
