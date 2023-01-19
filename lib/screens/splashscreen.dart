import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oxo/constants.dart';
import 'package:oxo/screens/login.dart';
import 'package:oxo/screens/sales/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    print("object");

    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString("token"));
    setState(() {
      tokens = prefs.getString('token');
      print(tokens);
    });
    if (tokens == null) {
      timer = Timer(
          const Duration(seconds: 2),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              )));
    } else {
      timer = Timer(
          const Duration(seconds: 2),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => home_page(),
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(child: Image.asset("assets/Splash_screen1.gif")));
  }
}
