import 'dart:async';
import 'dart:convert';
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
                  mapType: MapType.hybrid,
                  markers: Set<Marker>.of(_markers),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Align(
                //     alignment: Alignment.topRight,
                //     child: FloatingActionButton(
                //       onPressed: _onMapTypeButtonPressed,
                //       materialTapTargetSize: MaterialTapTargetSize.padded,
                //       child: const Icon(Icons.map, size: 36.0),
                //     ),
                //   ),
                // ),
              ],
            ),
    );
  }

  Future location_list() async {
    print(
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    location = [];

    var response = await http.get(
        Uri.parse(
            """https://demo14prime.thirvusoft.co.in/api/method/oxo.custom.api.location_list"""),
        headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        status = false;
        EasyLoading.dismiss();
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          location.add((json.decode(response.body)['message'][i]));
        }
        print("xxxxxxxx");
        print(location[0]["latitude"]);
        print("xxxxxxxx");
        for (int i = 0; i <= location.length; i++) {
          print(location[i]["latitude"]);
          print(location[i]["longitude"]);
          print(location[i]["longitude"].runtimeType);
          setState(() {
            _markers.add(Marker(
              markerId: MarkerId(location[i]["name"].toString()),
              position:
                  LatLng(location[i]["latitude"], location[i]["longitude"]),
              onTap: () {},
              infoWindow: InfoWindow(
                title: location[i]["name"],
                // snippet: '5 Star Rating',
              ),
              icon: BitmapDescriptor.defaultMarker,
            ));
          });
        }
        print(location);
      });
    }
  }
}
