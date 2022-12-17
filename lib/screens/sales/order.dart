import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/constants.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:oxo/screens/sales/sales_order.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'item_group.dart';

class order extends StatefulWidget {
  const order({super.key});

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> {
  @override
  initState() {
    all_item();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Color.fromRGBO(44, 185, 176, 1),
              title: Center(
                child: Text(
                  'Sales Order',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 20, letterSpacing: .2, color: Colors.white),
                  ),
                ),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.person), text: "MEN'S RANGE"),
                  Tab(icon: Icon(Icons.person_outline), text: "WOMEN RANGE"),
                  Tab(icon: Icon(Icons.person_pin), text: "KID'S RANGE"),
                  Tab(icon: Icon(Icons.person_pin_sharp), text: "PREMIUM RANGE")
                ],
              ),
            ),
            body: TabBarView(
              children: [
                mens(size),
                women(size),
                kids(size),
                primium(size),
              ],
            ),
          ),
        ));
  }

  Widget mens(Size size) {
    return Stack(children: [
      Container(
        child: itemlist(),
      ),
      Padding(
        padding: EdgeInsets.only(right: 10, bottom: 7),
        child: Container(
          alignment: Alignment.bottomRight,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => sales_order()),
              );
              values_dict = [];
              values.forEach((key, value) {
                values_dict.add({'item_code': key, 'qty': value});
              });
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              primary: Color.fromRGBO(44, 185, 176, 1),
            ),
            icon: Icon(
              Icons.add,
              size: 24.0,
            ),
            label: Text('View order item'),
          ),
        ),
      ),
    ]);
  }

  Widget women(Size size) {
    return Stack(children: [
      Container(
        child: itemlist2(),
      ),
      Padding(
        padding: EdgeInsets.only(right: 10, bottom: 7),
        child: Container(
          alignment: Alignment.bottomRight,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => sales_order()),
              );
              values_dict = [];
              values.forEach((key, value) {
                values_dict.add({'name': key, 'qty': value});
              });
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              primary: Color.fromRGBO(44, 185, 176, 1),
            ),
            icon: Icon(
              Icons.add,
              size: 24.0,
            ),
            label: Text('View order item'),
          ),
        ),
      ),
    ]);
  }

  Widget kids(Size size) {
    return Stack(children: [
      Container(
        child: itemlist3(),
      ),
      Padding(
        padding: EdgeInsets.only(right: 10, bottom: 7),
        child: Container(
          alignment: Alignment.bottomRight,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => sales_order()),
              );
              values_dict = [];
              values.forEach((key, value) {
                values_dict.add({'name': key, 'qty': value});
              });
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              primary: Color.fromRGBO(44, 185, 176, 1),
            ),
            icon: Icon(
              Icons.add,
              size: 24.0,
            ),
            label: Text('View order item'),
          ),
        ),
      ),
    ]);
  }

  Widget primium(Size size) {
    return Stack(children: [
      Container(
        child: itemlist4(),
      ),
      Padding(
        padding: EdgeInsets.only(right: 10, bottom: 7),
        child: Container(
          alignment: Alignment.bottomRight,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => sales_order()),
              );
              values_dict = [];
              values.forEach((key, value) {
                values_dict.add({'name': key, 'qty': value});
              });
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              primary: Color.fromRGBO(44, 185, 176, 1),
            ),
            icon: Icon(
              Icons.add,
              size: 24.0,
            ),
            label: Text('View order item'),
          ),
        ),
      ),
    ]);
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
            return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: 500),
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
                                  item_list_mens[index]["item_code"],
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        letterSpacing: .1,
                                        color: Color(0xff19183e)),
                                  ),
                                ),
                                // subtitle: Text(
                                //   item_list_mens[index]["standard_rate"]
                                //       .toString(),
                                //   style: GoogleFonts.poppins(
                                //     textStyle: TextStyle(
                                //         letterSpacing: .1,
                                //         color: Color(0xff19183e)),
                                //   ),
                                // ),
                                onTap: () {
                                  setState(() {
                                    item = item_list_mens[index]["item_code"];
                                  });
                                  varient_item(item);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => item_group()),
                                  );
                                },
                              ),
                            ),
                          ),
                        ))));
          }),
    ));
  }


  Widget itemlist2() {
    return AnimationLimiter(
        child: Container(
      child: ListView.builder(
          itemCount: item_list_womens.length,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            list.add(TextEditingController());

            int count = index + 1;
            return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: 500),
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
                                  item_list_womens[index]["item_code"],
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        letterSpacing: .1,
                                        color: Color(0xff19183e)),
                                  ),
                                ),
                                // subtitle: Text(
                                //   item_list_womens[index]["standard_rate"]
                                //       .toString(),
                                //   style: GoogleFonts.poppins(
                                //     textStyle: TextStyle(
                                //         letterSpacing: .1,
                                //         color: Color(0xff19183e)),
                                //   ),
                                // ),
                                onTap: () {
                                  setState(() {
                                    item = item_list_womens[index]["item_code"];
                                  });
                                  varient_item(item);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => item_group()),
                                  );
                                },
                              ),
                            ),
                          ),
                        ))));
          }),
    ));
  }
    Widget itemlist3() {
    return AnimationLimiter(
        child: Container(
      child: ListView.builder(
          itemCount: item_list_kids.length,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            list.add(TextEditingController());

            int count = index + 1;
            return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: 500),
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
                                  item_list_kids[index]["item_code"],
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        letterSpacing: .1,
                                        color: Color(0xff19183e)),
                                  ),
                                ),
                                // subtitle: Text(
                                //   item_list_kids[index]["standard_rate"]
                                //       .toString(),
                                //   style: GoogleFonts.poppins(
                                //     textStyle: TextStyle(
                                //         letterSpacing: .1,
                                //         color: Color(0xff19183e)),
                                //   ),
                                // ),
                                onTap: () {
                                  setState(() {
                                    item = item_list_kids[index]["item_code"];
                                  });
                                  varient_item(item);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => item_group()),
                                  );
                                },
                              ),
                            ),
                          ),
                        ))));
          }),
    ));
  }
    Widget itemlist4() {
    return AnimationLimiter(
        child: Container(
      child: ListView.builder(
          itemCount: item_list_premimum.length,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            list.add(TextEditingController());

            int count = index + 1;
            return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: 500),
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
                                  item_list_premimum[index]["item_code"],
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        letterSpacing: .1,
                                        color: Color(0xff19183e)),
                                  ),
                                ),
                                // subtitle: Text(
                                //   item_list_premimum[index]["standard_rate"]
                                //       .toString(),
                                //   style: GoogleFonts.poppins(
                                //     textStyle: TextStyle(
                                //         letterSpacing: .1,
                                //         color: Color(0xff19183e)),
                                //   ),
                                // ),
                                onTap: () {
                                  
                                  setState(() {
                                    item = item_list_premimum[index]["item_code"];
                                    
                                  });
                                
                                  varient_item(item);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => item_group()),
                                  );
                                },
                              ),
                            ),
                          ),
                        ))));
          }),
    ));
  }

  Future all_item() async {
    item_list_mens = [];
    item_list_womens = [];
    item_list_kids = [];
    item_list_premimum = [];

    var response = await http.get(
        Uri.parse(
            """https://demo14prime.thirvusoft.co.in/api/method/oxo.custom.api.template_list"""),
        headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});

    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        for (var i = 0;
            i < json.decode(response.body)['message1'].length;
            i++) {
          item_list_mens.add((json.decode(response.body)['message1'][i]));
        }
        for (var i = 0;
            i < json.decode(response.body)['message2'].length;
            i++) {
          item_list_womens.add((json.decode(response.body)['message2'][i]));
        }
        for (var i = 0;
            i < json.decode(response.body)['message3'].length;
            i++) {
          item_list_kids.add((json.decode(response.body)['message3'][i]));
        }
        for (var i = 0;
            i < json.decode(response.body)['message4'].length;
            i++) {
          item_list_premimum.add((json.decode(response.body)['message4'][i]));
        }
      });;
    } else {
      return json.decode(response.body)['message'];
    }
  }





  Future varient_item(item) async{
    print("object");
  varient_item_list=[];
  var response =await http.get(
    Uri.parse(
      """https://demo14prime.thirvusoft.co.in/api/method/oxo.custom.api.varient_list?template_name=${item}"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        for (var i = 0;
            i < json.decode(response.body)['message'].length;
            i++) {
          varient_item_list.add((json.decode(response.body)['message'][i]));
        }
      });


    } 
  
}
}
