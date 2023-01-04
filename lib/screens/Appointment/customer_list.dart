import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/constants.dart';
import 'package:http/http.dart' as http;

class customerlist extends StatefulWidget {
  @override
  State<customerlist> createState() => _customerlistState();
}

class _customerlistState extends State<customerlist> {
   initState(){
    }
  Widget build(BuildContext context) {
   
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(44, 185, 176, 1),
          title: Center(
            child: Text(
              'Delear List',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 20, letterSpacing: .2, color: Colors.white),
              ),
            ),
          )),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            child: Stack(children: <Widget>[
              Column(
                children: <Widget>[delear_list(size)],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget delear_list(Size size) {
    return Column(children: [
      Container(
        padding: EdgeInsets.all(15),
        child: Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.white),
          child: Container(
              height: 48.0,
              alignment: Alignment.center,
              child: TextField(
                controller: customer_search,
                onChanged: (value) {
                  setState(() {
                    value.trimLeft();
                    icon_nameOnSearch_customer = [];
                    for (var i = 0; i < customer_list.length; i++) {
                      var des_customer = {};
                      des_customer["name"] = customer_list[i]["name"];
                      item_search_list_customer.add(des_customer);
                      if ((item_search_list_customer[i]["name"]
                          .toLowerCase()
                          .contains(value.trim().toLowerCase()))) {
                        var d_cus = {};
                        d_cus["name"] = item_search_list_customer[i]["name"];
                        icon_nameOnSearch_customer.add(d_cus);
                      }
                    }
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(44, 185, 176, 1), width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(44, 185, 176, 1), width: 2.0),
                    ),
                    contentPadding: EdgeInsets.all(15),
                    hintText: "Search",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color.fromARGB(252, 4, 0, 0),
                    )),
              )),
        ),
      ),
      Container(
        height: size.height * 0.9,
        child: itemlist(),
      )
    ]);
  }

  Widget itemlist() {
    return AnimationLimiter(
        child: Container(
      child: ListView.builder(
          itemCount: customer_search.text.isNotEmpty
              ? icon_nameOnSearch_customer.length
              : customer_list.length,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            var row_status = [];
            if (icon_nameOnSearch_customer.length != 0) {
              row_status = icon_nameOnSearch_customer;
            } else {
              row_status = customer_list;
            }
            list.add(TextEditingController());

            int count = index + 1;
            return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: 300),
                child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: FadeInAnimation(
                            child: Container(
                          width: 50,
                          child: Card(
                            color: Color(0xffffffff),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color(0xfff7f7f7), width: 1),
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
                                customer_search.text.isEmpty
                                    ? row_status[index]['name'].toString()
                                    : row_status[index]['name'].toString(),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      letterSpacing: .1,
                                      color: Color(0xff19183e)),
                                ),
                              ),
               
                            ),
                          ),
                        )))));
          }),
    ));
  }




}
