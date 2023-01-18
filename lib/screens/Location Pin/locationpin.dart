import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oxo/constants.dart';

class location_pin extends StatefulWidget {
  const location_pin({super.key});

  @override
  State<location_pin> createState() => _location_pinState();
}

class _location_pinState extends State<location_pin> {
  void initState() {
    location_list();
    EasyLoading.show(status: 'Loading...');

    //
  }

  Completer<GoogleMapController> _controller = Completer();
  MapType _currentMapType = MapType.normal;
  List<Marker> _markers = [];
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  static LatLng _center =
      LatLng(location[0]["latitude"], location[0]["longitude"]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
           backgroundColor: Color(0xffEB455F),
        title: const Text('Location'),
      ),
      body: (location.isEmpty)
          ? (Container())
          : Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 7,
                  ),
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(_markers),
                ),
              ],
            ),
    );
  }

  Future location_list() async {
    var response = await http.get(
        Uri.parse(
            """${dotenv.env['API_URL']}/api/method/oxo.custom.api.location_list"""));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        status = false;
        EasyLoading.dismiss();
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          location.add((json.decode(response.body)['message'][i]));
        }

        for (int j = 0; j <= location.length; j++) {
          setState(() {
            _markers.add(Marker(
              markerId: MarkerId(location[j]["name"].toString()),
              position:
                  LatLng(location[j]["latitude"], location[j]["longitude"]),
              onTap: () {},
              infoWindow: InfoWindow(
                title: location[j]["name"],
                snippet: location[j]["pincode"],
              ),
              icon: BitmapDescriptor.defaultMarker,
            ));
          });
        }
      });
    }
  }
}
