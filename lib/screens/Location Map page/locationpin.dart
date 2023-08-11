import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:date_field/date_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oxo/constants.dart';
import 'package:searchfield/searchfield.dart';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class location_pin extends StatefulWidget {
  @override
  State<location_pin> createState() => _location_pinState();
}

class _location_pinState extends State<location_pin> {
  @override
  void initState() {
    super.initState();
    locationlist("", "", "");

    //
  }

  Completer<GoogleMapController> _controller = Completer();
  MapType _currentMapType = MapType.normal;
  List<Marker> _markers = [];

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  var todate;
  var formdate;
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

  static final LatLng _center = LatLng(double.parse(location[0]["latitude"]),
      double.parse(location[0]["longitude"]));
  TextEditingController territory = TextEditingController();
  TextEditingController date_ = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xffEB455F),
        title: const Text('Location'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              PhosphorIcons.faders_light,
              color: Colors.white,
            ),
            onPressed: () {
              // showPopup(context);
              _scaleDialog();
            },
          )
        ],
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

  Future locationlist(usr, formdate, todate) async {
    SharedPreferences token = await SharedPreferences.getInstance();
    await dotenv.load();

    var response = await http.post(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.location_list"""),
      headers: {"Authorization": token.getString("token") ?? ""},
      body: {
        'user': usr,
        'from_time': formdate,
        'to_time': todate,
      },
    );
    final Uint8List markerIcon = await getBytesFromAsset("assets/Pin.png", 300);
    if (response.statusCode == 200) {
      location = [];
      _markers = [];
      setState(() {
        status = false;
        print(response.body);
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          location.add((json.decode(response.body)['message'][i]));
        }
        if (location.isNotEmpty) {
          for (int j = 0; j <= location.length; j++) {
            setState(() {
              _markers.add(Marker(
                  markerId: MarkerId(location[j]["user"].toString()),
                  position: LatLng(double.parse(location[j]["latitude"]),
                      double.parse(location[j]["longitude"])),
                  onTap: () {},
                  infoWindow: InfoWindow(
                    title: location[j]["user"],
                    snippet: location[j]["creation"],
                  ),
                  icon: BitmapDescriptor.fromBytes(markerIcon)));
            });
          }
        }
      });
    }
  }

  territorys(txt) async {
    await dotenv.load();
    SharedPreferences token = await SharedPreferences.getInstance();

    var response = await http.post(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/frappe.desk.search.search_link"""),
      headers: {"Authorization": token.getString("token") ?? ""},
      body: {
        'txt': txt,
        'doctype': "User",
        'ignore_user_permissions': "1",
        'reference_doctype': "Employee",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        txt_ = [];
        for (var item in json.decode(response.body)['results']) {
          if (item.containsKey('description')) {
            txt_.add(item['description']);
          }
        }
      });
      return txt_;
    }
  }

  void _scaleDialog() {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Widget _dialog(BuildContext context) {
    return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
              title: const Text("Flutter Dev's"),
              actions: <Widget>[
                SearchField(
                  controller: territory,
                  onSearchTextChanged: (p0) {
                    setState(() {
                      territorys(
                        territory.text,
                      );
                    });
                  },
                  suggestions: txt_
                      .map((String) => SearchFieldListItem(String))
                      .toList(),
                  suggestionState: Suggestion.expand,
                  marginColor: Colors.white,
                  onSuggestionTap: (x) {
                    FocusScope.of(context).unfocus();
                  },
                  textInputAction: TextInputAction.next,
                  searchStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  searchInputDecoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Color(0xFF808080)),
                    ),
                    // border: OutlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      // borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide:
                          BorderSide(color: Color(0xFFEB455F), width: 2.0),
                    ),
                    labelText: "Sales Executive",

                    // hintText: "Select Area"
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DateTimeFormField(
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Color(0xFF808080)),
                    ),
                    counterText: "",
                    // border: OutlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      // borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide:
                          BorderSide(color: Color(0xFFEB455F), width: 2.0),
                    ),
                    labelText: "From time",
                    // hintText: "Enter dealer mobile number"
                  ),
                  // initialValue: DateTime.now().add(const Duration(days: 0)),
                  // autovalidateMode: AutovalidateMode.always,
                  // validator: (DateTime e) =>
                  //     (e.day ?? 0) == 1 ? 'Select Date and Time' : null,
                  onDateSelected: (DateTime datetime_value) {
                    formdate = datetime_value.toString();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                DateTimeFormField(
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Color(0xFF808080)),
                    ),
                    counterText: "",
                    // border: OutlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      // borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide:
                          BorderSide(color: Color(0xFFEB455F), width: 2.0),
                    ),
                    labelText: "To time ",
                    // hintText: "Enter dealer mobile number"
                  ),
                  onDateSelected: (DateTime datetime_value) {
                    todate = datetime_value.toString();
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    locationlist(territory.text, formdate, todate);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    backgroundColor: Color(0xFF2B3467),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              ],
            ));
  }
}
