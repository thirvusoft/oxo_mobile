import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
  List districtslist_ = [];
  var sort_ = [];

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
          // controller: _searchController,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            serach(value);
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
                child: ListView.builder(
                  itemCount: dealer_name.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                            title: Text(dealer_name[index]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2B3467),
                                  ),
                                  onPressed: () {},
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
                                    onPressed: () {},
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
    print(dealer_name);
    sort_ = dealer_name
        .where((element) => element.toLowerCase().contains(dealer_name))
        .toList();
  }
}
