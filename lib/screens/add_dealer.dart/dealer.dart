import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:oxo/constants.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/screens/sales/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:searchfield/searchfield.dart';

class dealer extends StatefulWidget {
  const dealer({super.key});

  @override
  State<dealer> createState() => _dealerState();
}

class _dealerState extends State<dealer> {
  @override
  var login_loading_dealer = false;
  void initState() {
    // TODO: implement initState
    territory_list();
    state_list();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var currentAddress;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffEB455F),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_outlined),
          ),
          // backgroundColor: const Color(0xFFEB455F),
          title: Text(
            'Dealer Creation',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 20, letterSpacing: .2, color: Colors.white),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    // bottom: 20.0,
                    child: Column(
                      children: <Widget>[
                        dealer_name(size),
                        dealer_mobile(size),
                        dealer_address(size),
                        dealer_submit(size)
                        // buildFooter(size),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget dealer_name(Size size) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: SizedBox(
          child: Form(
              key: name_key,
              child: TextFormField(
                controller: dealername,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter dealer name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                          color: const Color(0xFFEB455F), width: 2.0),
                    ),
                    hintText: "Enter dealer name"),
              )),
        ));
  }

  Widget dealer_mobile(Size size) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        child: SizedBox(
          child: Form(
              key: mobile_key,
              child: TextFormField(
                controller: dealermobile,
                maxLength: 10,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                          color: const Color(0xFFEB455F), width: 2.0),
                    ),
                    hintText: "Enter dealer mobile number"),
              )),
        ));
  }

  Widget dealer_address(Size size) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
        child: SizedBox(
          child: Form(
              key: address_key,
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "Add Dealer Address",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: const Color(0xFF2B3467)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: TextFormField(
                    controller: dealerdoorno,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter doorno';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                              color: const Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: "Enter door no"),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: TextFormField(
                    controller: dealercity,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter street';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                              color: const Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: "Enter street"),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: SearchField(
                    controller: dealerterritory,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select territory';
                      }
                      return null;
                    },
                    suggestions: territory
                        .map((String) => SearchFieldListItem(String))
                        .toList(),
                    suggestionState: Suggestion.expand,
                    textInputAction: TextInputAction.next,
                    hasOverlay: false,
                    searchStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    searchInputDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                              color: const Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: "Select Territory"),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: SearchField(
                    controller: dealerstate,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Select state';
                      }
                      return null;
                    },
                    suggestions: state
                        .map((String) => SearchFieldListItem(String))
                        .toList(),
                    suggestionState: Suggestion.expand,
                    textInputAction: TextInputAction.next,
                    hasOverlay: false,
                    searchStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    searchInputDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                              color: const Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: "Select State"),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: TextFormField(
                    controller: dealerpincode,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                              color: const Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: "Enter postal code"),
                  )),
                ],
              )),
        ));
  }

  Widget dealer_submit(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
      child: SizedBox(
        child: AnimatedButton(
            text: 'Submit',
            color: const Color(0xFFEB455F),
            pressEvent: () {
              if (name_key.currentState!.validate() &&
                  mobile_key.currentState!.validate() &&
                  address_key.currentState!.validate()) {
                _getCurrentLocation();
                customer_creation(
                    dealername.text,
                    dealermobile.text,
                    dealerdoorno.text,
                    dealercity.text,
                    dealerterritory.text,
                    dealerstate.text,
                    dealerpincode.text);
                dealername.clear();
                dealermobile.clear();
                dealerdoorno.clear();
                dealerterritory.clear();
                dealercity.clear();
                dealerstate.clear();
                dealerpincode.clear();
              }
            }),
      ),
    );
  }

  Future customer_creation(
    full_name,
    phone_number,
    dealerdoorno,
    dealercity,
    territory,
    state,
    pincode,
  ) async {
    print(current_position);
    print("lllll");
    print("lllll");
    // print(current_position.trim());
    // double location = double.parse(current_position);
    // print(location);

    var response = await http.get(Uri.parse(
        """${dotenv.env['API_URL']}/api/method/oxo.custom.api.new_customer?full_name=${full_name}&phone_number=${phone_number}&doorno=${dealerdoorno}&address=${dealercity}&territory=${territory}&state=${state}&pincode=${pincode}&latitude=${current_position!.latitude}&longitude=${current_position!.longitude}&auto_pincode=${auto_pincode}"""));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));

      setState(() {
        AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          title: (json.decode(response.body)['message']),
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => home_page()),
            );
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {},
        ).show();
      });
    } else if (response.statusCode == 500) {
      Fluttertoast.showToast(
          msg: (json.decode(response.body)['message']),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Color.fromARGB(255, 234, 10, 10),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

// /api/method/frappe.client.get_list?

  Future territory_list() async {
    territory = [];

    var response = await http.get(Uri.parse(
        """${dotenv.env['API_URL']}/api/method/oxo.custom.api.territory"""));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          territory.add((json.decode(response.body)['message'][i]));
        }
      });
    }
  }

  Future state_list() async {
    state = [];

    var response = await http.get(Uri.parse(
        """${dotenv.env['API_URL']}/api/method/oxo.custom.api.state"""));

    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          state.add((json.decode(response.body)['message'][i]));
        }
      });
    }
  }

  Position? _position;
  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    _getAddressFromLatLng(position);
    setState(() {
      _position = position;
      current_position = _position!;
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';

        auto_pincode = ' ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
