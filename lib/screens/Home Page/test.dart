import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

import 'package:location/location.dart';
import 'package:oxo/constants.dart';

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(20.5937, 78.9629);
  LocationData? currentLocation;

  @override
  void initState() {
    // setCustomMarkerIcon();

    super.initState();
    getloc();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Track Kilometer",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  getloc() async {
    List<Placemark> newPlace = await GeocodingPlatform.instance
        .placemarkFromCoordinates(11.022603, 76.998793, localeIdentifier: "en");

    Placemark place = newPlace[0];
    print('${place.postalCode}');
  }
}
