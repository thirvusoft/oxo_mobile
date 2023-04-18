import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oxo/constants.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:oxo/screens/Home%20Page/home_page.dart';
import 'package:searchfield/searchfield.dart';
import 'package:date_field/date_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class appointment extends StatefulWidget {
  @override
  State<appointment> createState() => _appointmentState();
}

class _appointmentState extends State<appointment> {
  @override
  void initState() {
    print(role_);
    customer_delear_list();
    if (role_ == "super_admin") {
      visibilitytype = true;
    } else if (role_ == "sales_executive") {
      visibilitytype = false;
      visibilitdealer = true;
      visibilitydistributorsales = true;
    }
    print(visibilitdealer);
    print(visibilitydistributorsales);
  }

  GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
  bool you = false;
  bool others = false;
  List userlist = [];
  List salespartner = [];
  var usertype = "Customer";
  var datetime;
  var roles;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const home_page()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          automaticallyImplyLeading: false,
          // backgroundColor: Color(0xFFEB455F),
          title: Text(
            'Fix Appointment',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 20, letterSpacing: .2, color: Colors.white),
            ),
          ),
        ),
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
                key: myFormKey,
                child: Column(children: [
                  (role_ == "super_admin")
                      ? CheckboxListTile(
                          title: const Text('Click here to assign others'),
                          value: others,
                          onChanged: (value) {
                            setState(() {
                              print(others);
                              others = value!;
                              if (others) {
                                setState(() {
                                  roles = "super";
                                });
                              } else {
                                setState(() {
                                  roles = "super_admin";
                                });
                              }
                              print(roles);
                            });
                          },
                        )
                      : const SizedBox(),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height / 10,
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Expanded(
                  //           child:
                  //     ],
                  //   ),
                  // ),
                  (others)
                      ? Column(
                          children: [
                            Visibility(
                              visible: visibilitytype,
                              child: SearchField(
                                controller: typecontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select Delear';
                                  }
                                  return null;
                                },
                                suggestions: type
                                    .map((String) => SearchFieldListItem(String,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 2, top: 10),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              String,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        )))
                                    .toList(),
                                suggestionState: Suggestion.expand,
                                onSuggestionTap: (x) {
                                  FocusScope.of(context).unfocus();
                                  if (typecontroller.text == "Distributor") {
                                    setState(() {
                                      appointment_delear_name.clear();

                                      usertype = "Sales Partner";
                                      visibilitydistributor = true;
                                      visibilitydistributorsales = false;
                                    });
                                  } else if (typecontroller.text == "Dealer") {
                                    setState(() {
                                      appointment_delear_name.clear();

                                      usertype = "Customer";
                                      visibilitydistributor = false;
                                      visibilitydistributorsales = true;
                                      visibilitdealer = true;
                                    });
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                marginColor: Colors.white,
                                hasOverlay: false,
                                searchStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                                searchInputDecoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFF808080)),
                                  ),
                                  counterText: "",
                                  // border: OutlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(
                                    // borderRadius: BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: Color(0xFFEB455F), width: 2.0),
                                  ),
                                  labelText: "Type",
                                  // hintText: "Enter dealer mobile number"
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SearchField(
                              controller: salesexcutivenameappoint,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select Delear';
                                }
                                return null;
                              },
                              suggestions: userlist
                                  .map((String) => SearchFieldListItem(String,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 2, top: 10),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            String,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      )))
                                  .toList(),
                              suggestionState: Suggestion.expand,
                              onSuggestionTap: (x) {},
                              textInputAction: TextInputAction.next,
                              marginColor: Colors.white,
                              hasOverlay: false,
                              searchStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.8),
                              ),
                              searchInputDecoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFF808080)),
                                ),
                                counterText: "",
                                // border: OutlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEB455F), width: 2.0),
                                ),
                                labelText: "Sales Executive ",
                                // hintText: "Enter dealer mobile number"
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            (visibilitdealer)
                                ? (visibilitydistributorsales)
                                    ? SearchField(
                                        controller: appointment_delear_name,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select Delear';
                                          }
                                          return null;
                                        },
                                        suggestions: customer_list
                                            .map((String) =>
                                                SearchFieldListItem(String,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 2, top: 10),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          String,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    )))
                                            .toList(),
                                        suggestionState: Suggestion.expand,
                                        textInputAction: TextInputAction.next,
                                        marginColor: Colors.white,
                                        hasOverlay: false,
                                        searchStyle: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                        onSuggestionTap: (x) {
                                          TextInputAction.next;
                                          distributornameappoint.clear();
                                        },
                                        searchInputDecoration:
                                            const InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Color(0xFF808080)),
                                          ),
                                          counterText: "",
                                          // border: OutlineInputBorder(),
                                          focusedBorder: UnderlineInputBorder(
                                            // borderRadius: BorderRadius.all(Radius.circular(8)),
                                            borderSide: BorderSide(
                                                color: Color(0xFFEB455F),
                                                width: 2.0),
                                          ),
                                          labelText: "Dealer",
                                          // hintText: "Enter dealer mobile number"
                                        ),
                                      )
                                    : const SizedBox(height: 0.01)
                                : const SizedBox(height: 0.01),
                            const SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: visibilitydistributor,
                              child: SearchField(
                                controller: appointment_delear_name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select Delear';
                                  }
                                  return null;
                                },
                                suggestions: salespartner
                                    .map((String) => SearchFieldListItem(String,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 2, top: 10),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              String,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        )))
                                    .toList(),
                                suggestionState: Suggestion.expand,
                                textInputAction: TextInputAction.next,
                                marginColor: Colors.white,
                                hasOverlay: false,
                                searchStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                                searchInputDecoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFF808080)),
                                  ),
                                  counterText: "",
                                  // border: OutlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(
                                    // borderRadius: BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: Color(0xFFEB455F), width: 2.0),
                                  ),
                                  labelText: "Distributor",
                                  // hintText: "Enter dealer mobile number"
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DateTimeFormField(
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFF808080)),
                                ),
                                counterText: "",
                                // border: OutlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEB455F), width: 2.0),
                                ),
                                labelText: " Date/Time ",
                                // hintText: "Enter dealer mobile number"
                              ),
                              // initialValue: DateTime.now().add(const Duration(days: 0)),
                              // autovalidateMode: AutovalidateMode.always,
                              // validator: (DateTime e) =>
                              //     (e.day ?? 0) == 1 ? 'Select Date and Time' : null,
                              onDateSelected: (DateTime datetime_value) {
                                datetime = datetime_value;
                                print(datetime);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: appointment_emailid,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email id';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFF808080)),
                                ),
                                counterText: "",
                                // border: OutlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEB455F), width: 2.0),
                                ),
                                labelText: " Email ",
                                // hintText: "Enter dealer mobile number"
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SearchField(
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
                                        padding: const EdgeInsets.only(
                                            left: 2, top: 10),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            String,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      )))
                                  .toList(),
                              suggestionState: Suggestion.expand,
                              textInputAction: TextInputAction.next,
                              marginColor: Colors.white,
                              hasOverlay: false,
                              searchStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.8),
                              ),
                              onSuggestionTap: (x) {
                                TextInputAction.next;
                                distributornameappoint.clear();
                              },
                              searchInputDecoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFF808080)),
                                ),
                                counterText: "",
                                // border: OutlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEB455F), width: 2.0),
                                ),
                                labelText: "Dealer",
                                // hintText: "Enter dealer mobile number"
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DateTimeFormField(
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFF808080)),
                                ),
                                counterText: "",
                                // border: OutlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEB455F), width: 2.0),
                                ),
                                labelText: " Date/Time ",
                                // hintText: "Enter dealer mobile number"
                              ),
                              // initialValue: DateTime.now().add(const Duration(days: 0)),
                              // autovalidateMode: AutovalidateMode.always,
                              // validator: (DateTime e) =>
                              //     (e.day ?? 0) == 1 ? 'Select Date and Time' : null,
                              onDateSelected: (DateTime datetime_value) {
                                datetime = datetime_value;
                                print(datetime);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: appointment_emailid,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email id';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFF808080)),
                                ),
                                counterText: "",
                                // border: OutlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEB455F), width: 2.0),
                                ),
                                labelText: " Email ",
                                // hintText: "Enter dealer mobile number"
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  AnimatedButton(
                    text: 'Submit',
                    color: Color(0xFFEB455F),
                    pressEvent: () {
                      appointment_creation(
                          usertype,
                          appointment_delear_name.text,
                          datetime,
                          appointment_emailid.text,
                          salesexcutivenameappoint.text);
                    },
                  ),
                ]))));
  }

  Future<void> customer_delear_list() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    customer_list = [];
    try {
      final response = await Dio().get(
          '${dotenv.env['API_URL']}/api/method/oxo.custom.api.customer_list',
          options: Options(
            headers: {'Authorization': token.getString("token") ?? ""},
          ));
      print(response.statusCode);
      print(response.data);
      print('qqqqqqqqqqqqqqqqqqqqqqqqqqqq');
      if (response.statusCode == 200) {
        setState(() {
          for (var i = 0; i < response.data['Dealer'].length; i++) {
            customer_list.add(response.data['Dealer'][i]);
          }
          for (var i = 0; i < response.data['User'].length; i++) {
            userlist.add(response.data['User'][i]);
          }
          for (var i = 0; i < response.data['sales_partner'].length; i++) {
            salespartner.add(response.data['sales_partner'][i]);
          }
        });
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> appointment_creation(String usertype, String dealerName,
      dateTime, String email, String salesexecutive) async {
    print(dateTime);
    print(dealerName);
    SharedPreferences token = await SharedPreferences.getInstance();

    print(token.getString("token"));
    print("++++++++++++++++++++++++++++++++++++++++++++++++++");
    print(token.getString("roll"));

    Dio dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? "",
      headers: {
        "Authorization": token.getString("token") ?? "",
      },
    ));

    try {
      Response response = await dio.get(
          "/api/method/oxo.custom.api.Appointment_creation",
          queryParameters: {
            "customer_name": dealerName,
            "date_time": dateTime,
            "email": email,
            "sales_executive": salesexecutive,
            "user": roles,
            "usertype": usertype
          });
      print("check");
      print(response);
      print(response.statusCode);
      // print(json.decode(response.data)['message']);
      // print(response.data);
      var responseData = response.data;
      print(responseData);
      if (response.statusCode == 200) {
        clear();
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          AwesomeDialog(
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            title: (responseData['message']),
            btnOkOnPress: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const home_page()));
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
          title: (responseData['message']),
          btnOkOnPress: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => home_page()));
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {},
        ).show();
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response!.data);
      } else {
        print(e.message);
      }
    } catch (e) {
      print(e);
    }
  }

  clear() {
    typecontroller.clear();
    salesexcutivenameappoint.clear();
    appointment_delear_name.clear();
    appointment_emailid.clear();
    datetime = "";
  }
}
