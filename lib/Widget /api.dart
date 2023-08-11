import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

class DistrictController extends GetxController {
  var products = [].obs;
  LocationData? _currentLocation;
  Location _locationService = Location();
  LocationData? _previousLocation;
  double significantChangeThreshold = 1;
  RxString permission = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getDistrict();
    _checkLocationPermissions();
  }

  Future<void> getDistrict() async {
    products = [].obs;
    products.clear();
    SharedPreferences token = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.parse(
            """${dotenv.env['API_URL']}/api/method/oxo.custom.api.district_list"""),
        headers: {"Authorization": token.getString("token") ?? ""});

    if (response.statusCode == 200) {
      for (var i = 0;
          i < json.decode(response.body)['district_list'].length;
          i++) {
        products.add((json.decode(response.body)['district_list'][i]));
      }
    }
  }

  Future<void> _checkLocationPermissions() async {
    print("pooooooooooooooooooooooooooooooooooooooooooooo");
    var status = await Permission.location.status;

    var isLoading = true.obs;

    if (status.toString() == "PermissionStatus.granted") {
      isLoading.value = false;
    }

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
      if (_previousLocation != null) {
        double distance = _calculateDistance(
          _previousLocation!.latitude,
          _previousLocation!.longitude,
          result.latitude,
          result.longitude,
        );
        print("rrrrrrrrrrrrrrrrrrrrrrrrrrrrr");

        if (distance >= significantChangeThreshold) {
          _currentLocation = result;

          _callAPI(_currentLocation);

          _previousLocation = _currentLocation;
        }
      } else {
        _previousLocation = result;
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
    print("[][][]");
    var now = new DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    SharedPreferences token = await SharedPreferences.getInstance();
    String lat = currentLocation.latitude.toString();
    String long = currentLocation.longitude.toString();
    var docname = token.getString("docname_live").toString() == "null"
        ? ""
        : token.getString("docname_live");

    var response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/api/method/oxo.custom.api.lat'),
      headers: {"Authorization": token.getString("token") ?? ""},
      body: {
        'lat': lat,
        'long': long,
        'user': token.getString('full_name') ?? "",
        'doc_name': docname,
        'date': formattedDate,
      },
    );

    print(response.body);
    if (response.statusCode == 200) {
      // If the API call is successful, parse the response data
      final responseData = json.decode(response.body);

      var apiResponse = responseData["message"].toString();
      // var apiResponse = responseData["message"].toString() == "null"
      //     ? token.getString("docname_live")
      //     : responseData["message"].toString();
      token.setString('docname_live', apiResponse!);
    } else {
      // Handle API errors

      var apiResponse = 'Error: ${response.statusCode}';
    }
  }
}
