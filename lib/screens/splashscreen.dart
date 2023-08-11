import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oxo/constants.dart';
import 'package:oxo/screens/Home%20Page/home_page.dart';
import 'package:oxo/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widget /api.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  late Timer timer;

  void initState() {
    super.initState();
    time();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  Future time() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    print(token.getString("token"));
    setState(() {
      tokens = token.getString('token').toString();
      print(tokens);
    });

    if (token.getString('token') == null) {
      timer = Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ));
      });
    } else {
      timer = Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const home_page(),
            ));

        final DistrictController _checkLocationPermissions =
            Get.put(DistrictController());
        print("dfhdsufiuasdgfsdgusdgvsvdhvhkvjdjvbsdvbzkvbzv");
        print(_checkLocationPermissions.permission);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(child: Image.asset("assets/Splash_screen1.gif")));
  }
}
