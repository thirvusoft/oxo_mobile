import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class LocationUpdatePage extends StatefulWidget {
  @override
  _LocationUpdatePageState createState() => _LocationUpdatePageState();
}

class _LocationUpdatePageState extends State<LocationUpdatePage> {
  LocationData? _currentLocation;
  Location _locationService = Location();
  LocationData? _previousLocation;

  double significantChangeThreshold = 10;

  @override
  void initState() {
    super.initState();
    _checkLocationPermissions();
  }

  Future<void> _checkLocationPermissions() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
    _startLocationService();
  }

  void _startLocationService() {
    _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 10000,
    );
    _locationService.enableBackgroundMode(enable: true);

    _locationService.onLocationChanged.listen((LocationData result) async {
      print("1");
      print(_previousLocation != null);
      if (_previousLocation != null) {
        print("22");
        double distance = _calculateDistance(
          _previousLocation!.latitude,
          _previousLocation!.longitude,
          result.latitude,
          result.longitude,
        );
        print("distance");
        print(distance);
        print(distance >= significantChangeThreshold);
        if (distance >= significantChangeThreshold) {
          setState(() {
            _currentLocation = result;
          });

          _callAPI(_currentLocation);

          _previousLocation = _currentLocation;
        }
      } else {
        print('ppppppppppppppppppppppppp');
        _previousLocation = result;
        print(_previousLocation);
      }
    });
  }

  double _calculateDistance(lat1, lon1, lat2, lon2) {
    const int earthRadius = 6371000;
    double dLat = (lat2 - lat1) * (math.pi / 180);
    double dLon = (lon2 - lon1) * (math.pi / 180);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * (math.pi / 180)) *
            math.cos(lat2 * (math.pi / 180)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  Future<void> _callAPI(currentLocation) async {
    print("pppp");
    var now = new DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    SharedPreferences token = await SharedPreferences.getInstance();
    String lat = currentLocation.latitude.toString();
    String long = currentLocation.longitude.toString();
    var docname = token.getString("docname_live").toString() == "null"
        ? ""
        : token.getString("docname_live");
    print(docname);
    print("[[][][][][][][][]]][]][][]][]][][]]][][][]]][]");

    var response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/api/method/oxo.custom.api.lat'),
      // headers: {"Authorization": token.getString("token") ?? ""},
      body: {
        'lat': lat,
        'long': long,
        'user': "aathisha@gmail.com",
        'doc_name': docname,
        'date': formattedDate,
      },
    );
    print("[[][][][][][][][]]][]][][]][]][][]]][][][]]][]");
    print('Body: ${response.body}');
    if (response.statusCode == 200) {
      // If the API call is successful, parse the response data
      final responseData = json.decode(response.body);
      setState(() {
        var apiResponse = responseData["message"].toString();
        // var apiResponse = responseData["message"].toString() == "null"
        //     ? token.getString("docname_live")
        //     : responseData["message"].toString();
        print(apiResponse);
        token.setString('docname_live', apiResponse!);
        print(token.getString("docname_live"));
      });
    } else {
      // Handle API errors
      setState(() {
        var apiResponse = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Update Example'),
      ),
      body: Center(
        child: _currentLocation != null
            ? Text(
                'Latitude: ${_currentLocation!.latitude}\n'
                'Longitude: ${_currentLocation!.longitude}',
                textAlign: TextAlign.center,
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
