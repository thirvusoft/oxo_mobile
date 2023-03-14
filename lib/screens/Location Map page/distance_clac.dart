import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../constants.dart';

class distance extends StatefulWidget {
  const distance({super.key});

  @override
  State<distance> createState() => _distanceState();
}

class _distanceState extends State<distance> {
  Position? position;
  double roundDistanceInKM = 0.0;
  var temps;
  bool start = true;
  @override
  void dispose() {
    // Cancel any asynchronous operation that is still running
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xffEB455F),
        title: const Text('Location'),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                // backgroundColor: Colors.purple,
                child: Text("1"),
              ),
              title: Text(roundDistanceInKM.toString()),
              subtitle: Text((temps != null) ? temps : ""),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                      child: IconButton(
                          onPressed: (start)
                              ? () {
                                  getloc(false);
                                }
                              : null,
                          icon: const Icon(
                            PhosphorIcons.play_bold,
                            color: Colors.white,
                          ))),
                  CircleAvatar(
                      child: IconButton(
                          onPressed: () {
                            getloc(true);
                          },
                          icon: const Icon(
                            PhosphorIcons.pause_bold,
                            color: Colors.white,
                          ))),
                  CircleAvatar(
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              locations.clear();
                              temps = "";
                            });
                          },
                          icon: const Icon(
                            PhosphorIcons.arrow_clockwise_bold,
                            color: Colors.white,
                          ))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  getloc(bool temp) async {
    Position position = await _determinePosition();
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position!.latitude);
    print(position!.longitude);

    var des = {};
    des["lat"] = position!.latitude;
    des["long"] = position!.longitude;
    if (locations.length <= 1) {
      setState(() {
        temps = "start";
        locations.add(position!.latitude);
        locations.add(position!.longitude);
        start = false;
      });
    }
    print(locations);
    print(locations.first);
    print(locations.first);
    if (temp) {
      setState(() {
        temps = "ends";
      });
      double distanceInMeters = Geolocator.distanceBetween(position!.latitude,
          position!.longitude, locations.first, locations.last);

      print(distanceInMeters);
      double distanceInKiloMeters = distanceInMeters / 1000;
      setState(() {
        roundDistanceInKM =
            double.parse((distanceInKiloMeters).toStringAsFixed(2));
      });

      print(distanceInMeters);
      print("xxxxxxxxxxxx");
      print(distanceInKiloMeters);
      print("xxxxxxxxxxxx");
      print(roundDistanceInKM);
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
// When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
