import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/screens/Dealer%20Creaction/dealer.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../Home Page/home_page.dart';

class Visitlog extends StatefulWidget {
  const Visitlog({super.key});

  @override
  State<Visitlog> createState() => _VisitlogState();
}

class _VisitlogState extends State<Visitlog> {
  TextEditingController sreachtext = TextEditingController();

  List districtslist_ = [];
  List searchResults = [];
  var sort_ = [];

  @override
  void initState() {
    district();
  }

  TextEditingController ditstrict = TextEditingController();

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
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: TextField(
          controller: sreachtext,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            List temp = serach(value);
            print("temp");
            print(temp);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchField(
                controller: ditstrict,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select District';
                  }
                  if (!districtslist_.contains(value)) {
                    return 'District not found';
                  }
                  return null;
                },
                suggestions: districtslist_
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
                  distributor_list(ditstrict.text);
                },
                searchInputDecoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xFF808080)),
                  ),
                  // border: OutlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide:
                        BorderSide(color: Color(0xFFEB455F), width: 2.0),
                  ),
                  labelText: "District",
                  // hintText: "State"
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: (dealer_name.isEmpty)
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.30),
                          child: const Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    PhosphorIcons.info,
                                    size: 35,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  )),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Please select the district to fetch the dealer name.',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2B3467)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: (sreachtext.text.isEmpty)
                            ? dealer_name.length
                            : searchResults.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                              child: ListTile(
                                  title: Text((sreachtext.text.isEmpty)
                                      ? dealer_name[index]
                                      : searchResults[index]),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF2B3467),
                                        ),
                                        onPressed: () {
                                          checkin((sreachtext.text.isEmpty)
                                              ? dealer_name[index]
                                              : searchResults[index]);
                                        },
                                        child: const Text('In'),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            side: const BorderSide(
                                                color: Color(0xFF2B3467)),
                                          ),
                                          onPressed: () {
                                            checkout((sreachtext.text.isEmpty)
                                                ? dealer_name[index]
                                                : searchResults[index]);
                                          },
                                          child: const Text('Out',
                                              style: TextStyle(
                                                color: Color(0xFF2B3467),
                                              ))),
                                    ],
                                  )));
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future district() async {
    districtslist_ = [];
    SharedPreferences token = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.parse(
            """${dotenv.env['API_URL']}/api/method/oxo.custom.api.district_list"""),
        headers: {"Authorization": token.getString("token") ?? ""});

    if (response.statusCode == 200) {
      setState(() {
        for (var i = 0;
            i < json.decode(response.body)['district_list'].length;
            i++) {
          districtslist_.add((json.decode(response.body)['district_list'][i]));
        }
        districtslist_.sort();
      });
    }
  }

  Future distributor_list(list) async {
    distributorname = [];

    dealer_name = [];
    var response = await http.get(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.sales_partner?area=$list"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    if (response.statusCode == 200) {
      setState(() {
        for (var j = 0; j < json.decode(response.body)['Dealer'].length; j++) {
          setState(() {
            dealer_name.add((json.decode(response.body)['Dealer'][j]));
          });
          // distributor.add((json.decode(response.body)['message'][i]));
        }
        dealer_name.sort();
        print(dealer_name);
      });
    }
  }

  serach(value) {
    setState(() {
      searchResults = dealer_name
          .where((name) => name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });

    return searchResults;
  }

  checkin(dealername) async {
    distributorname = [];
    SharedPreferences token = await SharedPreferences.getInstance();

    dealer_name = [];
    var response = await http.post(
      Uri.parse(
          '${dotenv.env['API_URL']}/api/method/oxo.custom.api.dealer_visit_log'),
      headers: {"Authorization": token.getString("token") ?? ""},
      body: {
        'dealer': dealername,
        'username': token.getString('full_name'),
        'check_in': DateTime.now().toString(),
      },
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: (json.decode(response.body)['message']),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Color.fromARGB(255, 43, 52, 103),
          textColor: Colors.white,
          fontSize: 15.0);
      print(json.decode(response.body)["message"]);
      token.setString('log_docname', json.decode(response.body)['name'] ?? "");
    }
  }

  checkout(dealername) async {
    SharedPreferences token = await SharedPreferences.getInstance();
    print(token.getString('log_docname'));
    var response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/api/method/oxo.custom.api.check'),
      headers: {"Authorization": token.getString("token") ?? ""},
      body: {
        'doc_name': token.getString('log_docname'),
        'check_out': DateTime.now().toString(),
      },
    );
    if (response.statusCode == 200) {
      token.remove("log_docname");

      Fluttertoast.showToast(
          msg: (json.decode(response.body)['message']),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Color.fromARGB(255, 43, 52, 103),
          textColor: Colors.white,
          fontSize: 15.0);
      print(json.decode(response.body)["message"]);
    }
  }
}
