import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class DistrictController extends GetxController {
  var products = [].obs;

  @override
  void onInit() {
    super.onInit();
    getDistrict();
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
      print(""""""
          """"""
          """"""
          """"""
          """"""
          """"""
          """"""
          """"""
          """"""
          """"""
          """"""
          """"""
          "");
      print(products);
      print(products.length);
    }
  }
}
