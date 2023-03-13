import 'package:flutter/material.dart';
import 'package:location/location.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData _locationData;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Text(_locationData.toString())],
      ),
    );
  }

  test() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // Handle the case when the user does not enable the location service.
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        // Handle the case when the user does not grant location permission.
        return;
      }
    }
    setState(() {
          _locationData = await location.getLocation();

    });

  }
}
