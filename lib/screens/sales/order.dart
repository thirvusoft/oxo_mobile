import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/constants.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:oxo/screens/sales/sales_order.dart';

import 'item_group.dart';

class order extends StatefulWidget {
  const order({super.key});

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Color.fromRGBO(44, 185, 176, 1),
                title: Text(
                  'Sales Order',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 20, letterSpacing: .2, color: Colors.white),
                  ),
                ),
                      actions: [
          ElevatedButton.icon(
            onPressed: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => sales_order()),
                );
                values_dict.add(values);
                print(values);
                print(values_dict);
            },
            style: ElevatedButton.styleFrom(
             
              primary: Color(0xFF21899C),
              
            ),
            icon: Icon(
              Icons.add,
              size: 24.0,
            ),
            label: Text('View order item'),
          ),
        ],
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.person), text: "MEN'S RANGE"),
                    Tab(icon: Icon(Icons.person_outline), text: "WOMEN RANGE"),
                    Tab(icon: Icon(Icons.person_pin), text: "KID'S RANGE"),
                    Tab(
                        icon: Icon(Icons.person_pin_sharp),
                        text: "PRIMIUM RANGE")
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  mens(),
                  women(),
                  kids(),
                  primium(),
                ],
              ),
            )));
  }

  Widget mens() {
    return Container(
      child: Center(
          child: ElevatedButton(
        onPressed: () {
          all_item();
        },
        child: Text(
          'item',
          style: TextStyle(fontSize: 35.0),
        ),
      )),
    );
  }

  Widget women() {
    return Container(
      child: Center(
        child: Text(
          'It is a second layout tab, which is responsible for taking pictures from your mobile.22222222',
          style: TextStyle(fontSize: 35.0),
        ),
      ),
    );
  }

  Widget kids() {
    return Container(
      child: Center(child: itemlist()),
    );
  }

  Widget primium() {
    return Container(
      child: Center(
        child: Text(
          'It is a second layout tab, which is responsible for taking pictures from your mobile.444444444',
          style: TextStyle(fontSize: 35.0),
        ),
      ),
    );
  }

  Widget itemlist() {

    return Container(
      child: ListView.builder(
          itemCount:item_list.length ,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            list.add(TextEditingController());

            int count = index + 1;
            return Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                width: 50,
                child: Card(
                  color: Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xfff7f7f7), width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                        radius: 12.5,
                        backgroundColor: Color(0xff628E90),
                        child: Text(
                          count.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                    title: Text(
                      item_list[index]["name"],
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            letterSpacing: .1, color: Color(0xff19183e)),
                      ),
                    ),
                    subtitle: Text(
                      item_list[index]["standard_rate"].toString(),
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            letterSpacing: .1, color: Color(0xff19183e)),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => item_group()),
                      );
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future all_item() async {
   item_list=[];
    var response = await http.get(
        Uri.parse(
            """https://demo14prime.thirvusoft.co.in/api/method/frappe.client.get_list?doctype=Item&fields=["name","standard_rate"]"""),
        headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});

    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          item_list.add((json.decode(response.body)['message'][i]));
        }
      });
      print(item_list);
    } else {
      return json.decode(response.body)['message'];
    }
  }
}
