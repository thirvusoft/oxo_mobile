// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:url_launcher/url_launcher.dart';

import '../../Widget /api.dart';
import '../../Widget /apiservice.dart';
import '../../constants.dart';

class nearest_location extends StatefulWidget {
  const nearest_location({super.key});

  @override
  State<nearest_location> createState() => _nearest_locationState();
}

List fianllist = [];
double totalDistance = 0.0;
List d = [];
var lat;
var long;
final DistrictController DistrictControllers = Get.put(DistrictController());
final LocationController locationController = Get.put(LocationController());

// final DistrictController locationController = Get.find<DistrictController>();

class _nearest_locationState extends State<nearest_location> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(DistrictControllers.products.value);
    temp();
  }

  temp() async {
    fianllist.clear();
    await DistrictControllers.getDistrict();
    await locationController.getLocation();
    List posts = [];
    posts.clear();
    print(locationController.latitude.value);
    print(locationController.longitude.value);
    posts = DistrictControllers.products.value;
    lat = locationController.latitude.value;
    long = locationController.longitude.value;
    setState(() {
      fianllist = posts.toSet().toList();
    });
    print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    print(lat);
    print(long);
    // Assume fetchProducts() is a method that retrieves the latest products data from a backend API
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xffEB455F),
          // title: const Text('Location'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 100,
                ),
                child: (kms.isEmpty)
                    ? Center(
                        child: GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          "assets/nearby.png",
                          height: MediaQuery.of(context).size.height / 3,
                        ),
                      ))
                    : SizedBox(
                        height:
                            MediaQuery.of(context).size.height / 5 * kms.length,
                        child: ListView.builder(
                            itemCount: kms.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                  onTap: () async {
                                    print(kms[index]["lat"]);
                                    print(kms[index]["long"]);
                                    var lat = kms[index]["lat"];
                                    var long = kms[index]["long"];
                                    // "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
                                    String googleUrl =
                                        "https://www.google.com/maps/search/?api=1&query=$lat,$long";
                                    final String encodedURl =
                                        Uri.encodeFull(googleUrl);

                                    if (await canLaunch(googleUrl)) {
                                      await launch(googleUrl);
                                    } else
                                      throw ("Couldn't open google maps");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Stack(children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            20), // Image border
                                        // Image radius
                                        child: Image.asset(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4.9,
                                          'assets/background.jpg',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Card(
                                              color: Colors.white70,
                                              child: ListTile(
                                                subtitle: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const WidgetSpan(
                                                          child: Icon(
                                                        PhosphorIcons
                                                            .map_pin_fill,
                                                        color:
                                                            Color(0xffEB455F),
                                                        size: 22,
                                                      )),
                                                      TextSpan(
                                                          text:
                                                              "${kms[index]["km"]} KM away",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      15)),
                                                    ],
                                                  ),
                                                ),
                                                title: Text(
                                                    " " + kms[index]["name"]),
                                                trailing: const Text(
                                                    "Map View >",
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF2B3467),
                                                        fontSize: 15)),
                                              )),
                                        ),
                                      )
                                    ]),
                                  ));
                            }),
                      ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 9.5),
                child: AnimatedButton(
                    text: 'Find',
                    color: const Color(0xFF2B3467),
                    pressEvent: () {
                      print(locationController.latitude.value);
                      print(locationController.longitude.value);
                      area_list(locationController.latitude.value,
                          locationController.longitude.value);
                    }),
              ),
            ],
          ),
        )));
  }

  area_list(latitude, longitude) async {
    try {
      Dio dio = Dio();

      SharedPreferences Autho = await SharedPreferences.getInstance();

      dio.options.headers = {
        "Authorization": Autho.getString('token') ?? '',
      };
      final params = {"latitude": latitude, "longitude": longitude};

      // Make the request
      final response = await dio.get(
          "${dotenv.env['API_URL']}//api/method/oxo.custom.api.area_list",
          queryParameters: params);

      // Print the response
      if (response.statusCode == 200) {
        kms = [];
        var responseData = response.data;
        d = responseData["State"];
        print(d);
        print(locationController.latitude.value);
        print(locationController.longitude.value);
        for (int i = 0; i < d.length; i++) {
          print(d[i]["longitude"]);
          double distanceInMeters = Geolocator.distanceBetween(
              locationController.latitude.value,
              locationController.longitude.value,
              d[i]["latitude"],
              d[i]["longitude"]);
          var p = 0.017453292519943295;
          var distance = distanceInMeters?.round().toInt();

          // totalDistance += calculateDistance(
          //     locationController.latitude.value,
          //     locationController.longitude.value,
          //     d[i]["latitude"],
          //     d[i]["longitude"]);
          print(distanceInMeters);
          double distanceInKiloMeters = distanceInMeters / 1000;
          double roundDistanceInKM = 0.00;
          setState(() {
            roundDistanceInKM =
                double.parse((distanceInKiloMeters).toStringAsFixed(2));
          });
          print("$roundDistanceInKM km");

          var des = {};
          des["name"] = d[i]["name"];
          des["lat"] = d[i]["latitude"];
          des["long"] = d[i]["longitude"];
          des["km"] = roundDistanceInKM;
          kms.add(des);
          kms.sort((a, b) => a["km"].compareTo(b["km"]));
          print(kms.length);
          print("pdppdpdpdpdpdpdpdpdpdpdpd");
          print(kms);
        }
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response!.data);
      } else {
        print(e.message);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
