// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

// class NotificationService {
//   static final NotificationService _notificationService = NotificationService._internal();

//   factory NotificationService() {
//     return _notificationService;
//   }

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   NotificationService._internal();

//   Future<void> initNotification() async {
//     final AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');

//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//       android: initializationSettingsAndroid,
//     );

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> showNotification(int id, String title, String body, int seconds) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.now(tz.local).add(Duration(seconds: 10)),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'main_channel',
//           'Main Channel',
//           importance: Importance.max,
//           priority: Priority.max,
//           icon: '@mipmap/ic_launcher',
//           styleInformation: BigTextStyleInformation(''),
//         ),

//       ),
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//     );
//   }

//   Future<void> cancelAllNotifications() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }
// }
import 'package:flutter/material.dart';

Widget myListView(
  bool value,
  List item,
) {
  return ListView.builder(
      itemCount: item.length,
      itemBuilder: (BuildContext context, int index) {
        var index_value = index + 1;
        print(item);
        return Card(
            elevation: 2,
            child: ListTile(
                leading: CircleAvatar(
                  radius: 12.5,
                  backgroundColor: const Color(0xFF2B3467),
                  child: Text(
                    index_value.toString(),
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFffffff),
                    ),
                  ),
                ),
                trailing: Visibility(
                  visible: value,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                              0xFF2B3467), // background (button) color
                          foregroundColor:
                              Colors.white, // foreground (text) colorR
                        ),
                        onPressed: () {
                          
                        },
                        child: const Text('Dispatched'),
                      ),
                    ],
                  ),
                ),
                title: Text(item[index]["name"].toString())));
      });
}
