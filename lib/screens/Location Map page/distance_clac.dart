import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
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
  @override
  void dispose() {
    // Cancel any asynchronous operation that is still running
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print(locationController.latitude.toString());
    // print(locationController.longitude.toString());
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

    var des = {};
    des["lat"] = locationController.latitude;
    des["long"] = locationController.longitude;
    if (locations.length <= 1) {
      setState(() {
        temps = "start";
        locations.add(locationController.latitude.value);
        locations.add(locationController.longitude.value);
        start = false;
      });
    }
    print(locations);
    print(locations.first);
    print(locations.last);
    if (temp) {
      setState(() {
        temps = "ends";
      });
      double distanceInMeters = Geolocator.distanceBetween(
          locationController.latitude.value,
          locationController.longitude.value,
          locations.first,
          locations.last);

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
}
