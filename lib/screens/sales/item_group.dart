import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:oxo/screens/sales/order.dart';

import '../../constants.dart';

class item_group extends StatefulWidget {

  @override
  State<item_group> createState() => _item_groupState();
}

class _item_groupState extends State<item_group> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(44, 185, 176, 1),
        title: Text(
          item,
          style: GoogleFonts.poppins(
            textStyle:
                TextStyle(fontSize: 20, letterSpacing: .2, color: Colors.white),
          ),
        ),
        actions: [
         ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => order()),
              );
              values_dict = [];
              values.forEach((key, value) {
                values_dict.add({'name': key, 'qty': value});
              });
            },
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(44, 185, 176, 1),
            ),
            icon: Icon(
              Icons.add,
              size: 24.0,
            ),
            label: Text('Add item'),
          ),
       
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            child: Stack(children: <Widget>[
              Column(
                children: <Widget>[item_varients(size)],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget item_varients(Size size) {
    return Container(
      height: size.height * 0.9,
      child: itemlist(),
    );
  }

  Widget itemlist() {
     return AnimationLimiter(
    child: Container(
      child: ListView.builder(
          itemCount: item_list_mens.length,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            list.add(TextEditingController());

            int count = index + 1;
            return AnimationConfiguration.staggeredList(position: index,
              duration:  Duration(milliseconds: 300),
            child:SlideAnimation( verticalOffset: 50.0,child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: FadeInAnimation(child:Container(
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
                            item_list_mens[index]["item_code"],
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  letterSpacing: .1, color: Color(0xff19183e)),
                            ),
                          ),
                          subtitle: Text(
                            item_list_mens[index]["standard_rate"].toString(),
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  letterSpacing: .1, color: Color(0xff19183e)),
                            ),
                          ),
                          // controller: list[index],
                          trailing: Wrap(spacing: 12, children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 1.0),
                              child: SizedBox(
                                height: 65,
                                width: 70,
                                child: TextFormField(
                                  controller: list[index],
                                  style: GoogleFonts.inter(
                                    fontSize: 15.0,
                                    color: const Color(0xFF151624),
                                  ),
                                  maxLines: 1,
                                  keyboardType: TextInputType.number,
                                   onChanged: ((qty) {
                        

                                      var item_name =
                                          item_list_mens[index]["item_code"];
                                      if (qty != '') {
                                        
                                        values[item_name]=qty;

                                      } else {
                                        values[item_name] = 0;
                                      }
                                      item_list_mens[index]["item_qty"] = qty;
    
                                     
                                    }),
                                  
                          
                                  cursorColor: const Color(0xFF151624),
                                  decoration: InputDecoration(
                                    counterText: "",
                                    hintText: 'QTY',
                                    hintStyle: GoogleFonts.inter(
                                      fontSize: 15.0,
                                      color: const Color(0xFF151624)
                                          .withOpacity(0.5),
                                    ),
                                    filled: true,
                                    fillColor: list[index].text.isEmpty
                                        ? const Color.fromRGBO(248, 247, 251, 1)
                                        : Colors.transparent,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: list[index].text.isEmpty
                                              ? Colors.transparent
                                              : const Color.fromRGBO(
                                                  44, 185, 176, 1),
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(44, 185, 176, 1),
                                        )),
                                        
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        )))))));
          }),
    ));
  }

  Future all_item() async {
    var response = await http.get(
        Uri.parse(
            """https://demo14prime.thirvusoft.co.in/api/method/frappe.client.get_list?doctype=Item&fields=["name","standard_rate"]"""),
        headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    // );
    print("itemm_pageeee4565");
    print(response.runtimeType);
    print("itemm_pageeee");
    print(response.statusCode);
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message1'].length; i++) {
          item_list_mens.add((json.decode(response.body)['message1'][i]));
        }
      });
      print(item_list_mens);
    } else {
      return json.decode(response.body)['message'];
    }
  }
}
