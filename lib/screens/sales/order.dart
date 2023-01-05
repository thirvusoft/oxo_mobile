import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                // backgroundColor: Color.fromRGBO(44, 185, 176, 1),
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
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(icon: Icon(Icons.person), text: "MEN'S RANGE"),
                    Tab(icon: Icon(Icons.person_outline), text: "WOMEN RANGE"),
                    Tab(icon: Icon(Icons.person_pin), text: "KID'S RANGE"),
                    Tab(
                        icon: Icon(Icons.person_pin_sharp),
                        text: "PREMIUM RANGE"),
                  ],
                ),
              ),
              body: Container(
                child: TabBarView(
                  children: [
                    mens(size),
                    women(size),
                    kids(size),
                    primium(size),
                  ],
                ),
              ),
            )));
  }

  Widget mens(Size size) {
    return Column(
      children: <Widget>[
        Stack(children: [
          // padding: EdgeInsets.all(15),
          Container(
              height: 48.0,
              alignment: Alignment.center,
              child: TextField(
                controller: searchcontroller_men,
                onChanged: (value) {
                  setState(() {
                    value.trimLeft();
                    icon_nameOnSearch_men = [];
                    for (var i = 0; i < item_list_mens.length; i++) {
                      var des = {};
                      des["item_code"] = item_list_mens[i]["item_code"];
                      item_search_list_men.add(des);
                      if ((item_search_list_men[i]["item_code"]
                          .toLowerCase()
                          .contains(value.trim().toLowerCase()))) {
                        var d = {};
                        d["item_code"] = item_search_list_men[i]["item_code"];
                        icon_nameOnSearch_men.add(d);
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
        ]),
        Container(
          child: ListView.builder(
              itemCount: searchcontroller_men.text.isNotEmpty
                  ? icon_nameOnSearch_men.length
                  : item_list_mens.length,
              shrinkWrap: true,
              itemBuilder: (context, int index) {
                var row = [];
                if (icon_nameOnSearch_men.length != 0) {
                  row = icon_nameOnSearch_men;
                } else {
                  row = item_list_mens;
                }
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
                                      searchcontroller_men.text.isEmpty
                                          ? row[index]['item_code']
                                          : row[index]['item_code'],
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            letterSpacing: .1,
                                            color: Color(0xff19183e)),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        item = row[index]["item_code"];
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
        ),
        Container(
          child: Padding(
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
                    values_dict.add(
                        {'item_code': key, 'qty': value[1], 'rate': value[0]});
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
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
        )
      ],
    );
  }

  Widget itemlist() {
    return AnimationLimiter(
        child: Container(
            height: 250,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ListView.builder(
                  itemCount: searchcontroller_men.text.isNotEmpty
                      ? icon_nameOnSearch_men.length
                      : item_list_mens.length,
                  shrinkWrap: true,
                  itemBuilder: (context, int index) {
                    var row = [];
                    if (icon_nameOnSearch_men.length != 0) {
                      row = icon_nameOnSearch_men;
                    } else {
                      row = item_list_mens;
                    }
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
                                          searchcontroller_men.text.isEmpty
                                              ? row[index]['item_code']
                                              : row[index]['item_code'],
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                letterSpacing: .1,
                                                color: Color(0xff19183e)),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            item = row[index]["item_code"];
                                          });
                                          varient_item(item);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    item_group()),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ))));
                  }),
            )));
  }

  Widget women(Size size) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.white),
            child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: TextField(
                  controller: searchcontroller_women,
                  onChanged: (value) {
                    setState(() {
                      value.trimLeft();
                      icon_nameOnSearch_women = [];
                      for (var i = 0; i < item_list_womens.length; i++) {
                        var des2 = {};
                        des2["item_code"] = item_list_womens[i]["item_code"];
                        item_search_list_women.add(des2);
                        if ((item_search_list_women[i]["item_code"]
                            .toLowerCase()
                            .contains(value.trim().toLowerCase()))) {
                          var d2 = {};
                          d2["item_code"] =
                              item_search_list_women[i]["item_code"];
                          icon_nameOnSearch_women.add(d2);
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
        Expanded(
            child: Container(
          child: itemlist2(),
        )),
        Container(
          child: Padding(
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
                    values_dict.add(
                        {'item_code': key, 'qty': value[1], 'rate': value[0]});
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
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
        )
      ],
    );
  }

  Widget kids(Size size) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.white),
            child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: TextField(
                  controller: searchcontroller_kids,
                  onChanged: (value) {
                    setState(() {
                      value.trimLeft();
                      icon_nameOnSearch_kids = [];
                      for (var i = 0; i < item_list_kids.length; i++) {
                        var des3 = {};
                        des3["item_code"] = item_list_kids[i]["item_code"];
                        item_search_list_kid.add(des3);
                        if ((item_search_list_kid[i]["item_code"]
                            .toLowerCase()
                            .contains(value.trim().toLowerCase()))) {
                          var d3 = {};
                          d3["item_code"] =
                              item_search_list_kid[i]["item_code"];
                          icon_nameOnSearch_kids.add(d3);
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
        Expanded(
            child: Container(
          child: itemlist3(),
        )),
        Container(
          child: Padding(
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
                    values_dict.add(
                        {'item_code': key, 'qty': value[1], 'rate': value[0]});
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
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
        )
      ],
    );
  }

  Widget primium(Size size) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.white),
            child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: TextField(
                  controller: searchcontroller_premimum,
                  onChanged: (value) {
                    setState(() {
                      value.trimLeft();
                      icon_nameOnSearch_premimum = [];
                      for (var i = 0; i < item_list_premimum.length; i++) {
                        var des4 = {};
                        des4["item_code"] = item_list_premimum[i]["item_code"];
                        item_search_list_premimum.add(des4);
                        if ((item_search_list_premimum[i]["item_code"]
                            .toLowerCase()
                            .contains(value.trim().toLowerCase()))) {
                          var d4 = {};
                          d4["item_code"] =
                              item_search_list_premimum[i]["item_code"];
                          icon_nameOnSearch_premimum.add(d4);
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
        Expanded(
            child: Container(
          child: itemlist4(),
        )),
        Container(
          child: Padding(
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
                    values_dict.add(
                        {'item_code': key, 'qty': value[1], 'rate': value[0]});
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
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
        )
      ],
    );
  }

  Widget itemlist2() {
    return AnimationLimiter(
        child: Container(
      child: ListView.builder(
          itemCount: searchcontroller_women.text.isNotEmpty
              ? icon_nameOnSearch_women.length
              : item_list_womens.length,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            var row = [];
            if (icon_nameOnSearch_women.length != 0) {
              row = icon_nameOnSearch_women;
            } else {
              row = item_list_womens;
            }
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
                                  searchcontroller_women.text.isEmpty
                                      ? row[index]['item_code']
                                      : row[index]['item_code'],
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        letterSpacing: .1,
                                        color: Color(0xff19183e)),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    item = row[index]["item_code"];
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
          itemCount: searchcontroller_kids.text.isNotEmpty
              ? icon_nameOnSearch_kids.length
              : item_list_kids.length,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            var row = [];
            if (icon_nameOnSearch_kids.length != 0) {
              row = icon_nameOnSearch_kids;
            } else {
              row = item_list_kids;
            }
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
                                  searchcontroller_kids.text.isEmpty
                                      ? row[index]['item_code']
                                      : row[index]['item_code'],
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        letterSpacing: .1,
                                        color: Color(0xff19183e)),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    item = row[index]["item_code"];
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
          itemCount: searchcontroller_premimum.text.isNotEmpty
              ? icon_nameOnSearch_premimum.length
              : item_list_premimum.length,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            var row = [];
            if (icon_nameOnSearch_premimum.length != 0) {
              row = icon_nameOnSearch_premimum;
            } else {
              row = item_list_premimum;
            }
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
                                  searchcontroller_premimum.text.isEmpty
                                      ? row[index]['item_code']
                                      : row[index]['item_code'],
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        letterSpacing: .1,
                                        color: Color(0xff19183e)),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    item = row[index]["item_code"];
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
            """${dotenv.env['API_URL']}/api/method/oxo.custom.api.template_list"""),
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
      });
      ;
    } else {
      return json.decode(response.body)['message'];
    }
  }

  Future varient_item(item) async {
    print("object");
    varient_item_list = [];
    row_varient = [];
    icon_nameOnSearch_varient = [];
    var response = await http.get(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.varient_list?template_name=${item}"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          varient_item_list.add((json.decode(response.body)['message'][i]));
        }
      });
    }
  }
}
