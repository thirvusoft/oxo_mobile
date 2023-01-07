import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/screens/Appointment/customer_list.dart';
import 'package:oxo/screens/add_dealer.dart/dealer.dart';
import 'package:oxo/screens/sales/item_category_list.dart';
import 'package:oxo/screens/sales/order.dart';
import 'package:http/http.dart' as http;
import 'package:oxo/screens/distributor/distributor.dart';
import 'package:searchfield/searchfield.dart';
import '../../constants.dart';
import '../Appointment/appointment.dart';
import '../Location Pin/locationpin.dart';
import '../notification/appointment_notification.dart';
import '../notification/notificationservice.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'order_page.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  @override
  late Timer timer_notify;
  late Timer appointment_notify;

  void initState() {
    // TODO: implement initState
    // distributor_list();
    // timer_notify = Timer.periodic(Duration(seconds: 10), (Timer t) => notification());
    // appointment_notify = Timer.periodic(Duration(seconds: 10), (Timer t) => appointmentnotification());

    tz.initializeTimeZones();
    var hour = DateTime.now().hour;

    if (hour <= 12) {
      print('Good Morning');
      setState(() {
        day_status = "Good Morning ";
      });
    } else if ((hour > 12) && (hour <= 16)) {
      setState(() {
        day_status = "Good Afternoon ";
      });
      print('Good Afternoon');
    } else if ((hour > 16) && (hour < 20)) {
      setState(() {
        day_status = "Good Evening ";
      });
      print('Good Evening');
    } else {
      setState(() {
        day_status = "Good Night ";
      });
      print('Good Night');
    }
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color(0xffEB455F),
        appBar: AppBar(
          backgroundColor: Color(0xffEB455F),
          elevation: 0,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(PhosphorIcons.list),
            color: Color(0xFFffffffff),
          ),
          automaticallyImplyLeading: false,
          // backgroundColor: const Color(0xFFfffffff),
          title: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: day_status,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 20,
                          letterSpacing: .2,
                          color: Color(0xFFfffffffff)))),
              // TextSpan(
              //     text: " " + user_name,
              //     style: GoogleFonts.poppins(
              //         textStyle: TextStyle(
              //             fontSize: 20,
              //             letterSpacing: .2,
              //             color: Color(0xFFfffffffff)))),
            ]),

            // Text(
            //   day_status,
            //   style: GoogleFonts.poppins(
            //     textStyle: const TextStyle(
            //         fontSize: 15, letterSpacing: .2, color: Color(0xFFfffffffff)),
            //   ),
          ),
        ),
        body: Padding(
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
                    getCardItem(height),
                    getCardItem2(height),
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
                    getCardItem3(height),
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
        ));
  }

  Widget getCardItem(height) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(left: 10),
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
              const Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset(
                      "assets/add_friends.png",
                      height: 65,
                    ),
                    // child: const Icon(
                    //   PhosphorIcons.user_plus_light,
                    //   size: 50,
                    //   color: Color(0xFF2B3467),
                  ),
                  // padding: const EdgeInsets.all(10),

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
                height: 30,
              ),
              Container(
                // decoration: const BoxDecoration(
                //     color:const Color(0xFF2B3467),
                //     borderRadius: BorderRadius.only(
                //         bottomRight: Radius.circular(12),
                //         bottomLeft: Radius.circular(12))),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const dealer()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 15.0),
                    backgroundColor: const Color(0xFF2B3467),
                    // shape: const StadiumBorder(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: Text('Add Dealer',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 15,
                              letterSpacing: .2,
                              color: Color(0xFFfffffffff)))),
                ),
                // padding: const EdgeInsets.all(12),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget getCardItem2(height) {
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
                      child: Image.asset(
                        "assets/Order_confirmed.png",
                        height: 65,
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
                    child: Text('Create Order',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 15,
                                letterSpacing: .2,
                                color: Color(0xFFfffffffff)))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const category()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 15.0),
                      backgroundColor: const Color(0xFF2B3467),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
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

  Widget getCardItem3(height) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(left: 10),
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
              const Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset(
                      "assets/Current_location.png",
                      height: 65,
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
                height: 30,
              ),
              Container(
                // decoration: const BoxDecoration(
                //     color:const Color(0xFF2B3467),
                //     borderRadius: BorderRadius.only(
                //         bottomRight: Radius.circular(12),
                //         bottomLeft: Radius.circular(12))),
                child: ElevatedButton(
                  child: Text('Delear Location',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 15,
                              letterSpacing: .1,
                              color: Color(0xFFfffffffff)))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const location_pin()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 15.0),
                    backgroundColor: const Color(0xFF2B3467),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                // padding: const EdgeInsets.all(12),
              )
            ],
          ),
        ),
      ),
    ));
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
                    child: const Text('Fix Appointment'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => appointment()),
                      );
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

  Future notification() async {
    notification_list = [];
    var response = await http.get(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.notification"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          notification_list.add((json.decode(response.body)['message'][i]));
        }
      });
      NotificationService().showNotification(1, "Delivery Status",
          "These Orders are not yet deliveried  $notification_list", 3);
    }
  }

  Future appointmentnotification() async {
    appointment_notification = [];
    var response = await http.get(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.appointment_notification"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          appointment_notification
              .add((json.decode(response.body)['message'][i]['name']));
          time = ((json.decode(response.body)['message'][i]['scheduled_time']));
          notify_appointment.add(appointment_notify);
        }
      });
      Appointment_NotificationService().appointment_showNotification(
          1,
          "Today's Appointment",
          "Today's Appointments are $appointment_notification" + time,
          3);
    }
  }
}
