import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/screens/login.dart';
import 'package:oxo/screens/notification/notification.dart';
import 'package:oxo/screens/sales/home_page.dart';
import 'package:oxo/screens/sales/order.dart';
import 'package:oxo/screens/sales/sales_order.dart';
import 'package:oxo/screens/splashscreen.dart';

void main() async {
  runApp(MyHomePage());
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'test':(context) => sales_order()
      },
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          //google fonts lato theme...
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
          // primarySwatch:Colors.,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

      home: home_page(),
    );
  }
}





