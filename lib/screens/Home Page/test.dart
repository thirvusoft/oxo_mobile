import 'dart:math';

import 'package:flutter/material.dart';
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
    getCurrentLocation();
    // setCustomMarkerIcon();

    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Track Kilometer$km",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: currentLocation.toString().isEmpty
            ? Container()
            : SingleChildScrollView(
                child: Column(children: <Widget>[
                Container(
                  height: height / 10,
                  width: width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color(0xffffffff),
                  ),
                  child: ListTile(
                    leading: Text(currentLocation!.speed.toString()),
                    title: Text(
                      // ignore: prefer_interpolation_to_compose_strings
                      'Total Kilometer : ' + km.toStringAsFixed(2),

                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 15,
                            letterSpacing: .1,
                            color: Color(0xff19183e)),
                      ),
                    ),
                    // trailing: Icon(Icons.more_vert),
                  ),
                )
              ])));
  }

  void getCurrentLocation() async {
    Location location = new Location();
    PermissionStatus _permissionGranted;
    print("vvvvvvvvvvvvv");
    print(_permissionGranted = await location.hasPermission());

    location.enableBackgroundMode(enable: true);

    // location.getLocation().then(
    //   (location) {
    //     setState(() {
    //       currentLocation = location;
    //     });
    //   },
    // );
    if (_permissionGranted != PermissionStatus.granted) {
      location.onLocationChanged.listen(
        (newLoc) async {
          await updateBackgroundNotification(
            subtitle: 'Location: ${newLoc.latitude}, ${newLoc.longitude}',
            onTapBringToFront: true,
          );
          setState(() {
            currentLocation = newLoc;
            print(currentLocation);
            print(currentLocation);
            var des = {};
            des["lat"] = currentLocation!.latitude;
            des["long"] = currentLocation!.longitude;
            locations.add(des);
            print(locations);

            calculateDistance(locations.first["lat"], locations.first["long"],
                locations.last["lat"], locations.last["long"]);
          });
        },
      );
    }
  }

  Future<bool> updateBackgroundNotification({
    String? subtitle,
    bool? onTapBringToFront,
  }) {
    throw Exception('Method did not return a value.');
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    print("kmmmmmmmm");
    setState(() {
      km = 12742 * asin(sqrt(a));
    });
    print(12742 * asin(sqrt(a)));
    return 12742 * asin(sqrt(a));
  }
  
}
