import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:oxo/screens/notification/notification.dart';
import 'package:oxo/screens/route_plan/visit_log.dart';
import 'package:oxo/screens/sample.dart';

import 'package:oxo/screens/splashscreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'Db/customer.dart';
import 'screens/Home Page/home_page.dart';
import 'screens/Sales Order/sales_order.dart';
import 'package:get/get.dart';
import 'screens/Sales Order/template_page.dart';

void main() async {
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MyHomePage(), // Wrap your app
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  var appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.initFlutter();
  Box customer;
  Box location;
  customer = await Hive.openBox('customer_details');
  location = await Hive.openBox('location');
  await dotenv.load(fileName: ".env");
  Hive.registerAdapter(LocationAdapter());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: GetMaterialApp(
      useInheritedMediaQuery: true,
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      routes: {
        'test': (context) => sales_order(),
        'homepage': (context) => const home_page(),
        'category_groups': (context) => category_group(),
        "notification": (context) => const notification(),
        "Visitlog": (context) => const Visitlog(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        //google fonts lato theme...
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        // primarySwatch: createMaterialColor(const Color(0xFF273b69)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: createMaterialColor(const Color(0xFFEB455F)),
        // visualDensity: VisualDensity.adaptivePlatformDensity,
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
