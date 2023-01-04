import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/screens/Appointment/customer_list.dart';
import 'package:oxo/screens/add_dealer.dart/dealer.dart';
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
    distributor_list();
    timer_notify = Timer.periodic(Duration(seconds: 10), (Timer t) => notification());
    appointment_notify = Timer.periodic(Duration(seconds: 10), (Timer t) => appointmentnotification());


 
    tz.initializeTimeZones();

  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromRGBO(44, 185, 176, 1),
            title: Center(
              child: Text(
                'Home Page',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 20, letterSpacing: .2, color: Colors.white),
                ),
              ),
            )),
        body: SingleChildScrollView(child:
        Center(
            child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.width / 5),
                child: Row(children: <Widget>[
                  getCardItem(height),
                  getCardItem2(height),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: Padding(
                padding: EdgeInsets.only(
                  top: size.width / 5,
                ),
                child: Row(children: <Widget>[
                  getCardItem3(height),
                  getCardItem4(height),
                ]),
              )),
                 SizedBox(
                height: 10,
              ),
              Container(
                  child: Padding(
                padding: EdgeInsets.only(
                  top: size.width / 5,
                ),
                child: Row(children: <Widget>[
                  getCardItem5(height),
                ]),
              ))
            ],
          ),
        ))));
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
              color: Colors.grey.withOpacity(.5),
              spreadRadius: 10,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Icon(
                      Icons.supervisor_account,
                      size: 70,
                      color: Color.fromRGBO(44, 185, 176, 1),
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
              SizedBox(
                height: 30,
              ),
              Container(
                // decoration: const BoxDecoration(
                //     color:Color.fromRGBO(44, 185, 176, 1),
                //     borderRadius: BorderRadius.only(
                //         bottomRight: Radius.circular(12),
                //         bottomLeft: Radius.circular(12))),
                child: ElevatedButton(
                  child: Text('Add Dealer'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => dealer()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                    backgroundColor: Color(0xFF21899C),
                    shape: StadiumBorder(),
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
                color: Colors.grey.withOpacity(.5),
                spreadRadius: 10,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Icon(
                        Icons.shopping_cart,
                        size: 70,
                        color: Color.fromRGBO(44, 185, 176, 1),
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  // decoration: const BoxDecoration(
                  //     color:Color.fromRGBO(44, 185, 176, 1),
                  //     borderRadius: BorderRadius.only(
                  //         bottomRight: Radius.circular(12),
                  //         bottomLeft: Radius.circular(12))),
                  child: ElevatedButton(
                    child: Text('Create Order'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => order()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 15.0),
                      backgroundColor: Color(0xFF21899C),
                      shape: StadiumBorder(),
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
              color: Colors.grey.withOpacity(.5),
              spreadRadius: 10,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Icon(
                      Icons.location_on_outlined,
                      size: 70,
                      color: Color.fromRGBO(44, 185, 176, 1),
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
              SizedBox(
                height: 30,
              ),
              Container(
                // decoration: const BoxDecoration(
                //     color:Color.fromRGBO(44, 185, 176, 1),
                //     borderRadius: BorderRadius.only(
                //         bottomRight: Radius.circular(12),
                //         bottomLeft: Radius.circular(12))),
                child: ElevatedButton(
                  child: Text('Location Pins'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => location_pin()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                    backgroundColor: Color(0xFF21899C),
                    shape: StadiumBorder(),
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
                color: Colors.grey.withOpacity(.5),
                spreadRadius: 10,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Icon(
                        Icons.delivery_dining_outlined,
                        size: 70,
                        color: Color.fromRGBO(44, 185, 176, 1),
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  // decoration: const BoxDecoration(
                  //     color:Color.fromRGBO(44, 185, 176, 1),
                  //     borderRadius: BorderRadius.only(
                  //         bottomRight: Radius.circular(12),
                  //         bottomLeft: Radius.circular(12))),
                  child: ElevatedButton(
                    child: Text('Distributor'),
                    onPressed: () {
                      customer_creation();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 15.0),
                      backgroundColor: Color(0xFF21899C),
                      shape: StadiumBorder(),
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
                color: Colors.grey.withOpacity(.5),
                spreadRadius: 10,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Icon(
                        Icons.delivery_dining_outlined,
                        size: 70,
                        color: Color.fromRGBO(44, 185, 176, 1),
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  // decoration: const BoxDecoration(
                  //     color:Color.fromRGBO(44, 185, 176, 1),
                  //     borderRadius: BorderRadius.only(
                  //         bottomRight: Radius.circular(12),
                  //         bottomLeft: Radius.circular(12))),
                  child: ElevatedButton(
                    child: Text('Fix Appointment'),
                      onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => appointment()),
                    );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 15.0),
                      backgroundColor: Color(0xFF21899C),
                      shape: StadiumBorder(),
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
                      : const Color.fromRGBO(44, 185, 176, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(44, 185, 176, 1),
                )),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          child: Text('Select'),
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
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            backgroundColor: Color(0xFF21899C),
            shape: StadiumBorder(),
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
          """https://demo14prime.thirvusoft.co.in/api/method/oxo.custom.api.distributor"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
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
          """https://demo14prime.thirvusoft.co.in/api/method/oxo.custom.api.notification"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          notification_list.add((json.decode(response.body)['message'][i]));
        }
      });
      NotificationService().showNotification(1, "Delivery Status","These Orders are not yet deliveried  "+notification_list.toString(),3);
      
    }
  }

  Future appointmentnotification() async {
    appointment_notification = [];
    var response = await http.get(
      Uri.parse(
          """https://demo14prime.thirvusoft.co.in/api/method/oxo.custom.api.appointment_notification"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          appointment_notification.add((json.decode(response.body)['message'][i]['name']));
          time=((json.decode(response.body)['message'][i]['scheduled_time']));
          notify_appointment.add(appointment_notify);

        }
      });
      Appointment_NotificationService().appointment_showNotification(1, "Today's Appointment","Today's Appointments are "+appointment_notification.toString()+time,3);
      
    }
  }


}
