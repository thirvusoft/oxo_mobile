import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/constants.dart';
import 'package:http/http.dart' as http;


class order_status extends StatefulWidget {
  @override
  State<order_status> createState() => _order_statusState();
}

class _order_statusState extends State<order_status> {
  late Timer timer;

  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => orderstatus());

    
  }
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromRGBO(44, 185, 176, 1),
            title: Center(
              child: Text(
                'Order Status',
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
                children: <Widget>[salesorder_status(size)],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget salesorder_status(Size size) {
    return Column(children: [
      Container(
        padding: EdgeInsets.all(15),
        child: Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.white),
          child: Container(
              height: 48.0,
              alignment: Alignment.center,
              child: TextField(
                controller: status_search,
                onChanged: (value) {
                  setState(() {
                    value.trimLeft();
                    icon_nameOnSearch_status = [];
                    for (var i = 0; i < sales_order_status.length; i++) {
                      var des_status = {};
                      des_status["Name"] =
                          sales_order_status[i]["Name"];
                      item_search_list_status.add(des_status);
                      if ((item_search_list_status[i]["Name"]
                          .toLowerCase()
                          .contains(value.trim().toLowerCase()))) {
                        var d_status = {};
                        d_status["Name"] =
                            item_search_list_status[i]["Name"];
                        icon_nameOnSearch_status.add(d_status);
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
          itemCount: status_search.text.isNotEmpty
              ? icon_nameOnSearch_status.length
              : sales_order_status.length,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            var row_status = [];
            if (icon_nameOnSearch_status.length != 0) {
              row_status = icon_nameOnSearch_status;
            } else {
              row_status = sales_order_status;
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
                                status_search.text.isEmpty
                                    ? row_status[index]['Name'].toString()
                                    : row_status[index]['Name'].toString(),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      letterSpacing: .1,
                                      color: Color(0xff19183e)),
                                ),
                              ),
                              trailing: Wrap(spacing: 12, children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 1.0),
                                    child: SizedBox(
                                      // height: 65,
                                      // width: 70,
                                      child: ElevatedButton(
                                        child: Text('Delivered'),
                                        onPressed: () {
                                          var doc_name= row_status[index]['Name'].toString();
                                          orderstatus_change(doc_name);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 5.0),
                                          backgroundColor: Color(0xFF21899C),
                                        ),
                                      ),
                                    )),
                              ]),
                            ),
                          ),
                        )))));
          }),
    ));
  }




  Future orderstatus() async {
    sales_order_status = [];


    var response = await http.get(
        Uri.parse(
            """https://demo14prime.thirvusoft.co.in/api/method/oxo.custom.api.sales_order_list"""),
        headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});

    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        for (var i = 0;
            i < json.decode(response.body)['message'].length;
            i++) {
          sales_order_status.add((json.decode(response.body)['message'][i]));
        }
      });
      ;
    } else {
      return json.decode(response.body)['message'];
    }
  }


    Future orderstatus_change(doc_name) async {


    var response = await http.get(
        Uri.parse(
            """https://demo14prime.thirvusoft.co.in/api/method/oxo.custom.api.sales_order?doc_name=${doc_name}"""),
        headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});

    if (response.statusCode == 200) {
    } else {
      return json.decode(response.body)['message'];
    }
  }

}
