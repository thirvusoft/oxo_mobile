import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:oxo/constants.dart';

import '../../Widget /apiservice.dart';

class distance extends StatefulWidget {
  const distance({super.key});

  @override
  State<distance> createState() => _distanceState();
}

class _distanceState extends State<distance> {
  final LocationController locationController = Get.put(LocationController());

  Position? position;
  double roundDistanceInKM = 0.0;
  var temps;
  bool start = true;
  final location = Hive.box('location');

  @override
  void dispose() {
    // Cancel any asynchronous operation that is still running
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
              title: Text("${roundDistanceInKM} KM"),
              subtitle: (location.isNotEmpty)
                  ? Text(location.values.toString())
                  : Text(""),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                      backgroundColor: (location.isEmpty)
                          ? const Color(0xFF2B3467)
                          : const Color(0Xffcccccc),
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
                  const SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                      backgroundColor: const Color(0xFF2B3467),
                      child: IconButton(
                          onPressed: () {
                            getloc(true);
                          },
                          icon: const Icon(
                            PhosphorIcons.pause_bold,
                            color: Colors.white,
                          ))),
                  const SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                      backgroundColor: const Color(0xFF2B3467),
                      child: IconButton(
                          onPressed: () async {
                            await Hive.box('location').clear();
                            setState(() {
                              final location = Hive.box('location');
                              locations.clear();
                              print(location.length);
                              temps = "";
                              roundDistanceInKM = 0.0;
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
    print(locationController.latitude.toString());
    print(locationController.longitude.toString());
    print(locationController.address.toString());
    print(locationController.longitude.value.runtimeType);
    if (location.length <= 1) {}

    var des = {};
    des["lat"] = locationController.latitude;
    des["long"] = locationController.longitude;
    if (location.length <= 1) {
      setState(() {
        temps = "start";
        // locations.add(locationController.latitude.value);
        // locations.add(locationController.longitude.value);
        location.add(locationController.latitude.value);
        location.add(locationController.longitude.value);
      });
    }
    print("llllllllllll");
    print(location.values.first);
    print(location.values.last);
    print("llllllllllll");

    // print(locations);
    // print(locations.first);
    // print(locations.last);
    if (temp) {
      setState(() {
        temps = "ends";
      });
      double distanceInMeters = Geolocator.distanceBetween(
          locationController.latitude.value,
          locationController.longitude.value,
          location.values.first,
          location.values.last);

      print(distanceInMeters);
      double distanceInKiloMeters = distanceInMeters / 1000;
      setState(() {
        roundDistanceInKM =
            double.parse((distanceInKiloMeters).toStringAsFixed(3));
      });

      print(distanceInMeters);
      print("xxxxxxxxxxxx");
      print(distanceInKiloMeters);
      print("xxxxxxxxxxxx");
      print(roundDistanceInKM);
    }
  }
}
