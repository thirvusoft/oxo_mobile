// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:http/http.dart' as http;

// import '../../constants.dart';
// import 'notificationservice.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   @override
//   void initState() {
//     super.initState();

//     tz.initializeTimeZones();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//                 onPressed: () {
//                   NotificationService().cancelAllNotifications();
//                 },
//                 child: Text('cancel')),
//             ElevatedButton(
//                 onPressed: () {
//                   NotificationService().showNotification(1, "Appointment", "The Dealer fix the appointment for the date 12.12.2022 ",1);
//                 },
//                 child: Text('show'))
//           ],
//         ),
//       ),
//     );
//   }

// }
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/constants.dart';
import 'package:http/http.dart' as http;
import 'package:oxo/screens/Appointment/appointment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class notification extends StatefulWidget {
  const notification({super.key});

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  late Timer timer;
  @override
  void initState() {
    appointmentnotification_Lists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: ListView.builder(
        itemCount: appointment_notification_lists.length,
        itemBuilder: (BuildContext context, int index) {
          var newIndex = index + 1;
          return Card(
              elevation: 2.5,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 12.5,
                  backgroundColor: const Color(0xFF2B3467),
                  child: Text(
                    newIndex.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 15.0,
                      color: const Color(0xFFffffff),
                    ),
                  ),
                ),
                title: Text(
                  appointment_notification_lists[index]["name"],
                  style: GoogleFonts.inter(
                    fontSize: 15.0,
                    color: const Color(0xFF151624),
                  ),
                ),
                subtitle: Text(
                    appointment_notification_lists[index]['scheduled_time']),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF2B3467), // background (button) color
                    foregroundColor: Colors.white, // foreground (text) color
                  ),
                  onPressed: () {
                    print(appointment_notification_lists[index]["name"]);
                    appointment_status(
                        appointment_notification_lists[index]["name"]);
                  },
                  child: const Text('Visited'),
                ),
              ));
        },
      ),
    );
  }

  Future appointmentnotification_Lists() async {
    appointment_notification_lists = [];

    var response = await http.get(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.notification_list?username=${username}"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    print(
        """${dotenv.env['API_URL']}/api/method/oxo.custom.api.notification_list?username=${username}""");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      print("fffffffffffffffffffffffffffffffffff");
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          appointment_notification_lists
              .add((json.decode(response.body)['message'][i]));
          // time = ((json.decode(response.body)['message'][i]['scheduled_time']));
          // notify_appointment.add(appointment_notify);
          print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
          print(appointment_notification_lists);
          print(time);
        }
      });

      print("cvcvcvcvcvcvcvc");
      print(counter);

      print(appointment_notification_list);
    }
  }

  appointment_status(name) async {
    SharedPreferences token = await SharedPreferences.getInstance();
    print(token.getString("token"));
    print('object');
    var response = await http.post(
        Uri.parse(
            """${dotenv.env['API_URL']}/api/method/oxo.custom.api.notification_status?name=${name}"""),
        headers: {"Authorization": token.getString("token") ?? ""});
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      appointmentnotification_Lists();
      Fluttertoast.showToast(
          msg: (json.decode(response.body)['message']),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Color.fromARGB(255, 43, 52, 103),
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }
}
