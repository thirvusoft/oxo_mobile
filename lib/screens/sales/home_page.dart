// ignore_for_file: unnecessary_new

import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'dart:developer';
import 'package:just_audio/just_audio.dart';
import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:oxo/screens/Appointment/customer_list.dart';
import 'package:oxo/screens/login.dart';
import 'package:oxo/screens/sales/item_category_list.dart';
import 'package:http/http.dart' as http;
import 'package:oxo/screens/distributor/distributor.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../Appointment/appointment.dart';
import '../Location Pin/locationpin.dart';
import '../add_dealer.dart/dealer.dart';
import '../add_dealer.dart/y.dart';
import '../notification/appointment_notification.dart';
import '../notification/notificationservice.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:cron/cron.dart';
import 'package:collection/collection.dart';

import 'order_page.dart';
import 'orderlist.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  @override
  late Timer timer_notify;

  late Timer timer;
  late AudioPlayer player;
  void initState() {
    final myList = [1, 2, 3];

    final myElement = myList.firstWhereOrNull((a) => a == 3);
    print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    print(myElement);
    player = AudioPlayer();
    // Timer.periodic(const Duration(seconds: 1), (timer) async {
    //   appointmentnotification();R
    // });
    // appointmentnotification();
    distributor_list();
    // timer_notify =
    //     Timer.periodic(Duration(seconds: 10), (Timer t) => notification());

    // timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
    //   appointmentnotification_List();
    // });

    user();
    tz.initializeTimeZones();
    var hour = DateTime.now().hour;

    if (hour <= 12) {
      setState(() {
        day_status = "Good Morning ";
      });
    } else if ((hour > 12) && (hour <= 16)) {
      setState(() {
        day_status = "Good Afternoon ";
      });
    } else if ((hour > 16) && (hour < 20)) {
      setState(() {
        day_status = "Good Evening ";
      });
    } else {
      setState(() {
        day_status = "Good Night ";
      });
    }
  }

  Future<void> user() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    setState(() {
      username = token.getString('full_name');
    });
  }

  Widget build(BuildContext context) {
    ContainerTransitionType _containerTransitionType =
        ContainerTransitionType.fade;
    final size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        // drawer: createDrawerHeader(context),

        backgroundColor: const Color(0xffEB455F),
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xffEB455F),
            elevation: 0,
            actions: [
              new Stack(
                children: <Widget>[
                  new IconButton(
                      icon: const Icon(
                        PhosphorIcons.bell,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, 'notification');
                        setState(() {
                          counter = 0;
                        });
                      }),
                  (counter != 0 && counter != null)
                      ? new Positioned(
                          right: 22,
                          top: 11,
                          child: new Container(
                            padding: const EdgeInsets.all(1),
                            decoration: new BoxDecoration(
                              color: const Color(0xFF2B3467),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 10,
                              minHeight: 10,
                            ),
                          ),
                        )
                      : new Container()
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: IconButton(
                  onPressed: () {
                    _delete(context);
                  },
                  icon: const Icon(PhosphorIcons.sign_out),
                ),
              ),
            ],
            // centerTitle: true,
            title: Align(
              alignment: Alignment.topCenter,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: day_status,
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 20,
                              letterSpacing: .2,
                              color: Color(0xffffffff)))),
                  TextSpan(
                      text: " $username",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 20,
                              letterSpacing: .2,
                              color: Color(0xFFfffffffff)))),
                ]),

                // Text(
                //   day_status,
                //   style: GoogleFonts.poppins(
                //     textStyle: const TextStyle(
                //         fontSize: 15, letterSpacing: .2, color: Color(0xFFfffffffff)),
                //   ),
              ),
            )),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Container(
            // color: Color(0xffeff4fd),
            height: height,
            decoration: const BoxDecoration(
                color: Color(0xffe8effc),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                )),
            child: SingleChildScrollView(
                child: Center(
                    child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: size.width / 5),
                  child: Row(children: <Widget>[
                    const SizedBox(
                      width: 5,
                    ),
                    getCardItem(height),
                    const SizedBox(
                      width: 20,
                    ),
                    getCardItem2(height),
                    const SizedBox(
                      width: 5,
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.width / 28,
                  ),
                  child: Row(children: <Widget>[
                    const SizedBox(
                      width: 5,
                    ),
                    getCardItem3(height),
                    const SizedBox(
                      width: 20,
                    ),
                    // getCardItem5(height),
                    const SizedBox(
                      width: 5,
                    ),
                    // getCardItem4(height),
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.width / 15,
                  ),
                  child: Row(children: <Widget>[
                    const SizedBox(
                      width: 5,
                    ),
                    // getCardItem6(height),
                    // getCardItem4(height),
                  ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Container(
                //     child: Padding(
                //   padding: EdgeInsets.only(
                //     top: size.width / 5,
                //   ),
                //   child: Row(children: <Widget>[
                //     getCardItem5(height),
                //   ]),
                // ))
              ],
            ))),
          ),
        )));
  }

  Widget getCardItem(height) {
    ContainerTransitionType _containerTransitionType =
        ContainerTransitionType.fade;
    return OpenContainer(
      transitionType: _containerTransitionType,
      transitionDuration: Duration(milliseconds: 500),
      openBuilder: (context, _) => dealer(),
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: const BorderSide(color: Colors.white, width: 1)),
      closedColor: Colors.white,
      closedBuilder: (context, _) => Container(
        alignment: Alignment.center,
        height: 180,
        width: 180,
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Image.asset(
              "assets/add_friends.png",
              height: 75,
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF2B3467),
                  border: Border.all(
                    color: const Color(0xFF2B3467),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  " Add Dealer ",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 15, letterSpacing: .2, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getCardItem2(height) {
    ContainerTransitionType _containerTransitionType =
        ContainerTransitionType.fade;
    return Center(
        child: OpenContainer(
      transitionType: _containerTransitionType,
      transitionDuration: Duration(milliseconds: 500),
      openBuilder: (context, _) => category(),
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: const BorderSide(color: Colors.white, width: 1)),
      closedColor: Colors.white,
      closedBuilder: (context, _) => Container(
        alignment: Alignment.center,
        height: 180,
        width: 180,
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Image.asset(
              "assets/Order_confirmed.png",
              height: 75,
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF2B3467),
                  border: Border.all(
                    color: const Color(0xFF2B3467),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Create Order",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 15, letterSpacing: .2, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget getCardItem3(height) {
    ContainerTransitionType _containerTransitionType =
        ContainerTransitionType.fade;
    return OpenContainer(
      transitionType: _containerTransitionType,
      transitionDuration: Duration(milliseconds: 500),
      openBuilder: (context, _) => location_pin(),
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: const BorderSide(color: Colors.white, width: 1)),
      closedColor: Colors.white,
      closedBuilder: (context, _) => Container(
        alignment: Alignment.center,
        height: 180,
        width: 180,
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Image.asset(
              "assets/Current_location.png",
              height: 75,
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF2B3467),
                  border: Border.all(
                    color: const Color(0xFF2B3467),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Dealer Location ",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 15, letterSpacing: .2, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getCardItem4(height) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: height / 45),
        child: Container(
          height: 180,
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 230, 227, 227).withOpacity(.5),
                spreadRadius: 10,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Icon(
                        Icons.delivery_dining_outlined,
                        size: 50,
                        color: Color(0xFF2B3467),
                      ),
                      // padding: const EdgeInsets.all(10),
                    ),
                    // Container(
                    //   child: Text(
                    //     "20",
                    //     style: TextStyle(
                    //       color: Colors.blueAccent,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  // decoration: const BoxDecoration(
                  //     color:const Color(0xFF2B3467),
                  //     borderRadius: BorderRadius.only(
                  //         bottomRight: Radius.circular(12),
                  //         bottomLeft: Radius.circular(12))),
                  child: ElevatedButton(
                    child: const Text('Distributor'),
                    onPressed: () {
                      customer_creation();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 15.0),
                      backgroundColor: const Color(0xFF2B3467),
                      shape: const StadiumBorder(),
                    ),
                  ),
                  // padding: const EdgeInsets.all(12),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getCardItem5(height) {
    ContainerTransitionType containerTransitionType =
        ContainerTransitionType.fade;
    return OpenContainer(
      transitionType: containerTransitionType,
      transitionDuration: const Duration(milliseconds: 500),
      openBuilder: (context, _) => appointment(),
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: const BorderSide(color: Colors.white, width: 1)),
      closedColor: Colors.white,
      closedBuilder: (context, _) => Container(
        alignment: Alignment.center,
        height: 180,
        width: 180,
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Image.asset(
              "assets/Booking.png",
              height: 75,
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF2B3467),
                  border: Border.all(
                    color: const Color(0xFF2B3467),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Fix Appointment",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 15, letterSpacing: .2, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getCardItem6(height) {
    ContainerTransitionType containerTransitionType =
        ContainerTransitionType.fade;
    return OpenContainer(
      transitionType: containerTransitionType,
      transitionDuration: Duration(milliseconds: 500),
      openBuilder: (context, _) => order_list(),
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: const BorderSide(color: Colors.white, width: 1)),
      closedColor: Colors.white,
      closedBuilder: (context, _) => Container(
        alignment: Alignment.center,
        height: 180,
        width: 180,
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Image.asset(
              "assets/order_list.png",
              height: 75,
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF2B3467),
                  border: Border.all(
                    color: const Color(0xFF2B3467),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "  Order List  ",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 15, letterSpacing: .2, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future customer_creation() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(actions: <Widget>[
        SearchField(
          controller: customer_name_home_page,
          suggestions: distributor_home
              .map((String) => SearchFieldListItem(String))
              .toList(),
          suggestionState: Suggestion.expand,
          textInputAction: TextInputAction.next,
          hasOverlay: false,
          searchStyle: TextStyle(
            fontSize: 15,
            color: Colors.black.withOpacity(0.8),
          ),
          searchInputDecoration: InputDecoration(
            hintText: 'Select Distributor name',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: customer_name_home_page.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: customer_name_home_page.text.isEmpty
                      ? Colors.transparent
                      : const Color(0xFF2B3467),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: const Color(0xFF2B3467),
                )),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          child: const Text('Select'),
          onPressed: () {
            distributor_list();
            print(distributorname);
            print(distributorname);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => order_status()),
            );
          },
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            backgroundColor: const Color(0xFF2B3467),
            shape: const StadiumBorder(),
          ),
        ),
      ]),
    );
  }

  Future distributor_list() async {
    print("object");
    distributor_home = [];
    var response = await http.get(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.distributor"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          distributor_home.add((json.decode(response.body)['message'][i]));
        }
      });
    }
  }

  // Future notification() async {
  //   notification_list = [];
  //   var response = await http.get(
  //     Uri.parse(
  //         """${dotenv.env['API_URL']}/api/method/oxo.custom.api.notification?username=${username}"""),
  //     // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
  //   );
  //   print(response.statusCode);
  //   print(response.body);
  //   print("nptifffsffdfdfs");
  //   if (response.statusCode == 200) {
  //     await Future.delayed(const Duration(milliseconds: 500));
  //     setState(() {
  //       for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
  //         notification_list.add((json.decode(response.body)['message'][i]));
  //       }
  //     });
  //     NotificationService().showNotification(1, "Delivery Status",
  //         "These Orders are not yet deliveried  $notification_list", 3);
  //   }
  // }

  Future appointmentnotification() async {
    setState(() {
      time_ = [];
      data1 = "";
    });

    DateTime now = new DateTime.now();
    // print(now);

    // print(now);
    DateTime fiftyDaysAgo = now.subtract(new Duration(minutes: 50));
    // print("subtraction");
    // print(fiftyDaysAgo);
    var data = DateFormat('yyyy-MM-dd kk:mm:ss:00').format(now);

    // var formatter = new DateFormat('yyyy-MM-dd');
    // String formattedDate = formatter.format(now);
    SharedPreferences token = await SharedPreferences.getInstance();
    setState(() {
      username = token.getString('full_name');
    });

    SharedPreferences appointment = await SharedPreferences.getInstance();

    // Timer.periodic(const Duration(seconds: 5), (timer) async {
    //   // print(DateTime.now());
    //   DateTime now = new DateTime.now();
    //   var formatter = new DateFormat('yyyy-MM-dd');
    //   String formattedDate = formatter.format(now);
    //   print(formattedDate);
    //   print(timer.tick);
    //   print("clear");
    //   List<String> tags = appointment.getStringList("appointment") ?? [];
    //   print(tags);
    //   await appointment.remove('appointment');
    //   // appointment.clear();
    //   print(tags);
    // });
    appointment_notification = [];

    List<String> tags = appointment.getStringList("appointment") ?? [];
    List<String> times = appointment.getStringList("time") ?? [];
    // print("wnanananananana");
    // print(tags);
    // print(times);

    // print(username);
    var response = await http.get(
      Uri.parse(
          "https://oxo.thirvusoft.co.in/api/method/oxo.custom.api.appointment_notifications?username=${token.getString('full_name').toString()}"),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    // print("kkkkkkkkkkkkkkkkkkkkkkkk");
    // print(
    //     """${dotenv.env['API_URL']}/api/method/oxo.custom.api.appointment_notifications?username=${username}""");
    // print(response.statusCode);
    // print("tyeyeyeyeeye");
    // print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        time_ = [];
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          // print((json.decode(response.body)['message'][i]['scheduled_time']));
          appointment_notification
              .add((json.decode(response.body)['message'][i]['name']));

          time_.add(
              (json.decode(response.body)['message'][i]['scheduled_time']));
          // // pre.setStringList("time",
          //     (json.decode(response.body)['message'][i]['scheduled_time']));
          // notify_appointment.add(appointment_notify);
        }
      });

      List<String> tags = appointment.getStringList("appointment") ?? [];
      // print(tags);

      // // if ((listEquals(tags, appointment_notification) == false) &&
      // //     appointment_notification.isNotEmpty) {
      // print("tetststststststststststs");
      // print(data);

      // print(time_.first);
      if (time_.isNotEmpty) {
        print(time_);
        // print(time_.first);
        var temp = time_.firstOrNull;
        // print(temp);
        setState(() {
          check = DateTime.parse(temp!);
          // DateTime fiftyDaysAgo = check.subtract(const Duration(hours: 1));
          data1 = DateFormat('yyyy-MM-dd kk:mm:15:00').format(check);
          // print(check.toString() + " " + data1);
          // print(check);
          // print(check.runtimeType);

          print(data);
          print(data1);

          if (data.compareTo(data1) == 0) {
            int i = 1;
            i++;
            print(i);
            print("correct");

            player.setAsset('assets/ping.mp3');
            // player.play();

            showOverlayNotification((context) {
              return Card(
                  color: const Color(0xffe8effc),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'notification');
                    },
                    child: SafeArea(
                      child: ListTile(
                        title: const Text("Today's Appointment"),
                        subtitle: Text(appointment_notification.first),
                        trailing: IconButton(
                            icon: const Icon(
                              PhosphorIcons.x_circle_light,
                              color: Color(0xffEB455F),
                            ),
                            onPressed: () {
                              OverlaySupportEntry.of(context)?.dismiss();
                            }),
                      ),
                    ),
                  ));
            }, duration: const Duration(seconds: 15));
            time_.clear();
            appointment.setStringList("appointment", appointment_notification);
          }
        });
      }
    }
  }

  void _delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text("Please Confirm",
                style: TextStyle(
                    fontSize: 20, letterSpacing: .2, color: Color(0xFF2B3467))),
            content: const Text("Are you sure to logout?",
                style: TextStyle(
                    fontSize: 15, letterSpacing: .2, color: Color(0xFF2B3467))),
            actions: [
              // The "Yes" button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () async {
                  final token = await SharedPreferences.getInstance();
                  print(token.getString("token"));
                  // await token.clear();
                  await token.remove('token');
                  print(token.getString("token"));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: const Text("Yes"),
              ),
            ],
          );
        });
  }

  Future appointmentnotification_List() async {
    appointment_notification_list = [];
    var response = await http.get(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.notification_list?username=${username}"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    if (response.statusCode == 200) {
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          appointment_notification_list
              .add((json.decode(response.body)['message'][i]));
          // time = ((json.decode(response.body)['message'][i]['scheduled_time']));
          // notify_appointment.add(appointment_notify);
        }
        counter = appointment_notification_list.length;
      });
    }
  }
}
