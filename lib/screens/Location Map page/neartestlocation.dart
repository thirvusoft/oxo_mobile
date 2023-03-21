import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widget /api.dart';
import '../../Widget /apiservice.dart';
import '../../constants.dart';

class nearest_location extends StatefulWidget {
  const nearest_location({super.key});

  @override
  State<nearest_location> createState() => _nearest_locationState();
}

List fianllist = [];
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
            child: Column(
          children: [
            SearchField(
              controller: nearest_disterict,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select State';
                }
                if (!state.contains(value)) {
                  return 'State not found';
                }
                return null;
              },
              suggestions: fianllist
                  .map((String) => SearchFieldListItem(String))
                  .toList(),
              suggestionState: Suggestion.expand,
              textInputAction: TextInputAction.next,
              hasOverlay: false,
              marginColor: Colors.white,
              searchStyle: TextStyle(
                fontSize: 15,
                color: Colors.black.withOpacity(0.8),
              ),
              onSuggestionTap: (x) {
                FocusScope.of(context).unfocus();
                area_list(nearest_disterict.text);
              },
              searchInputDecoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFF808080)),
                ),
                // border: OutlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  // borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Color(0xFFEB455F), width: 2.0),
                ),
                labelText: "State",
                // hintText: "State"
              ),
            ),
            Text((kms.isNotEmpty) ? kms.toString() : "")
          ],
        )));
  }

  area_list(district) async {
    try {
      Dio dio = Dio();

      SharedPreferences Autho = await SharedPreferences.getInstance();

      dio.options.headers = {
        "Authorization": Autho.getString('token') ?? '',
      };
      final params = {"district": district};

      // Make the request
      final response = await dio.get(
          "${dotenv.env['API_URL']}//api/method/oxo.custom.api.area_list",
          queryParameters: params);

      // Print the response
      if (response.statusCode == 200) {
        var responseData = response.data;
        d = responseData["State"];
        print(locationController.latitude.value);
        print(locationController.longitude.value);
        for (int i = 0; i < d.length; i++) {
          print(d[i]["longitude"]);
          double distanceInMeters = Geolocator.distanceBetween(
              locationController.latitude.value,
              locationController.longitude.value,
              d[i]["latitude"],
              d[i]["longitude"]);
          print(distanceInMeters);
          double distanceInKiloMeters = distanceInMeters / 1000;
          double roundDistanceInKM = 0.00;
          setState(() {
            roundDistanceInKM =
                double.parse((distanceInKiloMeters).toStringAsFixed(2));
          });
          print(roundDistanceInKM.toString() + " km");
          var des = {};
          des["name"] = d[i]["name"];
          des["lat"] = d[i]["latitude"];
          des["km"] = roundDistanceInKM;
          kms.add(des);
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
