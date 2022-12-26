import 'dart:convert';

import 'package:oxo/constants.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:searchfield/searchfield.dart';
import 'package:date_field/date_field.dart';

import '../sales/home_page.dart';

class appointment extends StatefulWidget {
  @override
  State<appointment> createState() => _appointmentState();
}

class _appointmentState extends State<appointment> {
  @override
  void initState() {
    customer_delear_list();
  }

  var datetime;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromRGBO(44, 185, 176, 1),
            title: Center(
              child: Text(
                'Fix Appointment',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 20, letterSpacing: .2, color: Colors.white),
                ),
              ),
            )),
        body: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    // bottom: 20.0,
                    child: Column(
                      children: <Widget>[dealer_name(size)],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget dealer_name(Size size) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: SizedBox(
            child: Form(
                key: appointment_name_key,
                child: Column(children: [
                  Container(
                    child: SearchField(
                      controller: appointment_delear_name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select Delear';
                        }
                        return null;
                      },
                      suggestions: customer_list
                          .map((String) => SearchFieldListItem(String,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15.0, top: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    String,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              )))
                          .toList(),
                      suggestionState: Suggestion.expand,
                      textInputAction: TextInputAction.next,
                      hasOverlay: false,
                      searchStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black.withOpacity(0.8),
                      ),
                      searchInputDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(44, 185, 176, 1),
                                width: 2.0),
                          ),
                          hintText: "Select Delear"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  DateTimeFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(44, 185, 176, 1),
                            width: 2.0,
                          ),
                        ),
                        hintText: "Select Date and Time"),
                    // initialValue: DateTime.now().add(const Duration(days: 0)),
                    // autovalidateMode: AutovalidateMode.always,
                    // validator: (DateTime e) =>
                    //     (e.day ?? 0) == 1 ? 'Select Date and Time' : null,
                    onDateSelected: (DateTime datetime_value) {
                      datetime = datetime_value;
                      print(datetime);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ), TextFormField(
                controller: appointment_emailid,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email id';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(44, 185, 176, 1), width: 2.0),
                    ),
                    hintText: "Enter email id"),
              ),
                  SizedBox(
                    height: 10,
                  ), 
                  AnimatedButton(
                    text: 'Submit',
                    color: Color.fromRGBO(44, 185, 176, 1),
                    pressEvent: () {
                      appointment_creation(
                          appointment_delear_name.text, datetime,appointment_emailid.text);
                    },
                  ),
                ]))));
  }

  Future customer_delear_list() async {
    customer_list = [];
    var response = await http.get(
      Uri.parse(
          """https://demo14prime.thirvusoft.co.in/api/method/oxo.custom.api.customer_list"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    print(response.statusCode);
    print(response.body);
    print('qqqqqqqqqqqqqqqqqqqqqqqqqqqq');
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          customer_list.add((json.decode(response.body)['message'][i]));
        }
      });
    }
  }

  Future appointment_creation(
    delear_name,
    date_time,
    email
  ) async {
    print("object");
    print(date_time);
    print(delear_name);
    var response = await http.get(
        Uri.parse(
            """https://demo14prime.thirvusoft.co.in/api/method/oxo.custom.api.Appointment_creation?customer_name=${delear_name}&date_time=${date_time}&email=${email}"""),
        headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          title: (json.decode(response.body)['message']),
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => home_page()),
            );
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {},
        ).show();
      });
    } else {
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.error,
        title: (json.decode(response.body)['message']),
        btnOkOnPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => home_page()),
          );
        },
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {},
      ).show();
    }
  }
}
