import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/Widget%20/api.dart';
import 'package:oxo/screens/Appointment/appointment.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../Home Page/home_page.dart';

class RoutePlan extends StatefulWidget {
  const RoutePlan({super.key});

  @override
  State<RoutePlan> createState() => _RoutePlanState();
}

class _RoutePlanState extends State<RoutePlan> {
  @override
  void initState() {
    super.initState();
  }

  final DistrictController DistrictControllers = Get.put(DistrictController());

  bool _isChecked = false;
  bool _isChecked_1 = false;
  var customer_name;
  List area_list = [];
  List district = [];
  var items = [];
  List row = [];
  TextEditingController areatext = TextEditingController();
  TextEditingController reason = TextEditingController();

  TextEditingController territort_area = TextEditingController();
  TextEditingController editingController = TextEditingController();
  void filterSearchResults(String query) {
    setState(() {
      items = route_dealer_name
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffEB455F),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const home_page()),
              );
              row = [];
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
              icon: Icon(PhosphorIcons.faders),
              tooltip: 'Filters',
              onPressed: () {
                setState(() {
                  district = DistrictControllers.products;
                });
                _territory(context);
              },
            ),
          ],
          // backgroundColor: const Color(0xFFEB455F),
          title: Text(
            'Route Plan',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontSize: 20, letterSpacing: .2, color: Colors.white),
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: 'Search Dealer',
                    ),
                    onChanged: (value) {
                      filterSearchResults(value);
                    },
                    controller: editingController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.3,
                      child: (route_dealer_name.isEmpty)
                          ? const Column(children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "No Data",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xffE19183E)),
                                ),
                              )
                            ])
                          : ListView.builder(
                              itemCount: (editingController.text.isNotEmpty)
                                  ? items.length
                                  : route_dealer_name.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                print(items);
                                int count = index + 1;

                                if (editingController.text.isNotEmpty) {
                                  row = items;
                                } else {
                                  row = route_dealer_name;
                                }

                                return Container(
                                    child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.white70, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ListTile(
                                    title: Text(row[index].toString()),
                                    onTap: () {
                                      customer_name = row[index].toString();
                                      visited(context);
                                    },
                                    leading: CircleAvatar(
                                        radius: 12.5,
                                        backgroundColor:
                                            const Color(0xFF2B3467),
                                        child: Text(
                                          count.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        )),
                                  ),
                                ));
                              }),
                    ),
                  ])
                ]))));
  }

  Future district_list(district) async {
    area_list = [];
    SharedPreferences token = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.parse(
            """${dotenv.env['API_URL']}/api/method/oxo.custom.api.territory_area_list?district=$district"""),
        headers: {"Authorization": token.getString("token") ?? ""});
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        for (var i = 0; i < json.decode(response.body)['area'].length; i++) {
          area_list.add((json.decode(response.body)['area'][i]));
        }
        area_list.sort();
      });
    }
  }

  Future distributor_list(list) async {
    route_dealer_name = [];
    var response = await http.get(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.dealer_list?area=$list"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    if (response.statusCode == 200) {
      setState(() {
        for (var j = 0; j < json.decode(response.body)['dealer'].length; j++) {
          setState(() {
            route_dealer_name.add((json.decode(response.body)['dealer'][j]));
          });
        }
        route_dealer_name.sort();
      });
    }
  }

  void _territory(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
              scrollable: true,
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Form(
                    key: sales_order_key,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 3.3,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            SearchField(
                              controller: territory_district,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select District';
                                }
                                if (!district.contains(value)) {
                                  return 'District not found';
                                }
                                return null;
                              },
                              suggestions: district
                                  .map((String) => SearchFieldListItem(String))
                                  .toList(),
                              suggestionState: Suggestion.expand,
                              textInputAction: TextInputAction.next,
                              hasOverlay: false,
                              marginColor: Colors.white,
                              searchStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.8),
                              ),
                              onSuggestionTap: (x) {
                                FocusScope.of(context).unfocus();
                                district_list(territory_district.text);
                              },
                              searchInputDecoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFF808080)),
                                ),
                                // border: OutlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEB455F), width: 2.0),
                                ),
                                labelText: "District",
                                // hintText: "State"
                              ),
                            ),
                            SearchField(
                              controller: territort_area,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select Area';
                                }
                                if (!area_list.contains(value)) {
                                  return 'Area not found';
                                }
                                return null;
                              },
                              suggestions: area_list
                                  .map((String) => SearchFieldListItem(String))
                                  .toList(),
                              suggestionState: Suggestion.expand,
                              textInputAction: TextInputAction.next,
                              hasOverlay: false,
                              marginColor: Colors.white,
                              searchStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.8),
                              ),
                              onSuggestionTap: (x) {
                                FocusScope.of(context).unfocus();
                              },
                              searchInputDecoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFF808080)),
                                ),
                                // border: OutlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEB455F), width: 2.0),
                                ),
                                labelText: "Area",
                                // hintText: "State"
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            AnimatedButton(
                              text: 'Submit',
                              color: const Color.fromARGB(255, 49, 47, 92),
                              pressEvent: () {
                                if (sales_order_key.currentState!.validate()) {
                                  distributor_list(territort_area.text);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ));
              }));
        });
  }

  void visited(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
              scrollable: true,
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Form(
                    key: visited_key,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 2.3,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            CheckboxListTile(
                              title: const Text('Visited'),
                              value: _isChecked,
                              onChanged: (newValue) {
                                setState(() {
                                  _isChecked = newValue!;
                                  if (newValue == true) {
                                    _isChecked_1 = false;
                                  }
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CheckboxListTile(
                              title: const Text(' Not Visited'),
                              value: _isChecked_1,
                              onChanged: (newValue) {
                                setState(() {
                                  _isChecked_1 = newValue!;
                                  if (newValue == true) {
                                    _isChecked = false;
                                  }
                                });
                              },
                            ),
                            TextFormField(
                              controller: reason,
                              validator: (x) {
                                if (x!.isEmpty) {
                                  return " Date can't be empty";
                                }

                                return null;
                              },
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFF808080)),
                                ),
                                // border: OutlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  //                           // borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEB455F), width: 2.0),
                                ),
                                labelText: "Reason",
                                // hintText: "Pincode"
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            AnimatedButton(
                              text: 'Fix Appointment',
                              color: const Color.fromARGB(255, 49, 47, 92),
                              pressEvent: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => appointment()),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            AnimatedButton(
                              text: 'Submit',
                              color: const Color.fromARGB(255, 49, 47, 92),
                              pressEvent: () {
                                var value = _isChecked ? 1 : 0;
                                var value1 = _isChecked ? 1 : 0;
                                print('object');

                                route_plan(customer_name, territort_area.text,
                                    value, value1, reason.text);
                              },
                            ),
                          ],
                        ),
                      ),
                    ));
              }));
        });
  }

  Future route_plan(dealer_name, territory, visted, not_visited, reason) async {
    print(dealer_name);
    print(territory);
    print(visted);
    print(not_visited);

    SharedPreferences token = await SharedPreferences.getInstance();
    var salesperson = token.getString("full_name");

    var response = await http.post(
      Uri.parse(
          '${dotenv.env['API_URL']}/api/method/oxo.custom.api.route_plan'),
      headers: {"Authorization": token.getString("token") ?? ""},
      body: {
        'sales_preson': salesperson,
        'dealer_name': dealer_name,
        'territory': territory,
        'visted': visted.toString(),
        'not_visited': not_visited.toString(),
        'reason': reason,
      },
    );
    print(response.statusCode);
    print(token.getString("full_name"));

    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        setState(() {
          AwesomeDialog(
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            title: 'Success',
            btnOkOnPress: () {
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => const ()));
            },
            btnOkIcon: Icons.check_circle,
            onDismissCallback: (type) {},
          ).show();
        });
      });
    }
  }
}
