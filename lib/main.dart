// @dart=2.9
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:oxo/screens/login.dart';
import 'package:oxo/screens/notification/notification.dart';
import 'package:oxo/screens/sales/home_page.dart';
import 'package:oxo/screens/sales/order_page.dart';
import 'package:oxo/screens/sales/sales_order.dart';
import 'package:oxo/screens/splashscreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Widget /bottomnaviagtion.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyHomePage());
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'test': (context) => sales_order(),
        'bottom': (context) => MainPage(),
        'homepage': (context) => const home_page(),
        'category_groups': (context) => category_group(),
        "notification": (context) => const notification(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        //google fonts lato theme...
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: createMaterialColor(const Color(0xFFEB455F)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: splashscreen(),
      // builder: EasyLoading.init(),
    ));
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  ;
  return MaterialColor(color.value, swatch);
}
