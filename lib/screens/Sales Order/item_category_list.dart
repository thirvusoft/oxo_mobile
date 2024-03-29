import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oxo/screens/Sales%20Order/sales_order.dart';

import 'template_page.dart';

class category extends StatefulWidget {
  const category({super.key});

  @override
  State<category> createState() => _categoryState();
}

class _categoryState extends State<category> with TickerProviderStateMixin {
  TabController? _tabController__;

  @override
  initState() {
    super.initState();
    categorieslist_();

    all_item();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: categorieslist__.length,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            automaticallyImplyLeading: true,
            backgroundColor: Color(0xFFEB455F),
            title: Text(
              'ORDER FORM',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 20, letterSpacing: .2, color: Colors.white),
              ),
            ),
            bottom: TabBar(
                controller: _tabController__,
                isScrollable: true,
                indicatorColor: Colors.white,
                tabs:
                    List<Widget>.generate(categorieslist__.length, (int index) {
                  return Tab(
                    text: categorieslist__[index],
                  );
                })
                //  [
                //   Tab(icon: Icon(Icons.person), text: "SHIRT DHOTI SEGMENT"),
                //   Tab(icon: Icon(Icons.person_outline), text: "INNER SEGMENT"),
                //   Tab(icon: Icon(Icons.person_pin), text: "OUTER SEGMENT"),
                //   // Tab(
                //   //     icon: Icon(Icons.person_pin_sharp),
                //   //     text: "PREMIUM RANGE"),
                // ],
                ),
          ),
          body: TabBarView(
            controller: _tabController__,
            children: [
              shirt(size),
              inner(size),
              outer(size),
              // primium(size),
            ],
          ),
        ));
  }

  Widget shirt(Size size) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: Container(
              height: 48.0,
              alignment: Alignment.center,
              child: TextField(
                controller: searchcontroller_shirt,
                onChanged: (value) {
                  setState(() {
                    value.trimLeft();
                    icon_nameOnSearch_shirt = [];
                    for (var i = 0; i < shirt_list.length; i++) {
                      var des = {};
                      des["name"] = shirt_list[i]["name"];
                      item_search_list_shirt.add(des);
                      if ((item_search_list_shirt[i]["name"]
                          .toLowerCase()
                          .contains(value.trim().toLowerCase()))) {
                        var d = {};
                        d["name"] = item_search_list_shirt[i]["name"];
                        icon_nameOnSearch_shirt.add(d);
                      }
                    }
                  });
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide:
                          BorderSide(color: Color(0xFFEB455F), width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide:
                          BorderSide(color: Color(0xFFEB455F), width: 2.0),
                    ),
                    contentPadding: EdgeInsets.all(15),
                    hintText: "Search",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color.fromARGB(252, 4, 0, 0),
                    )),
              )),
        ),
        Expanded(
            child: Container(
          child: itemlist(),
        )),
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
                  values_dict.add(
                    {
                      'item_code': key,
                      'qty': value[1],
                      'item_group': value[0],
                      'item_name': value[2]
                    },
                  );
                });
                values_dict.sort(
                    (a, b) => (a['item_group']).compareTo(b['item_group']));
                // values_dict.sort(
                //     (a, b) => (a['item_name']).compareTo(b['item_name']));

                values_dict.removeAt(index_value);
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
                backgroundColor: const Color(0xFFEB455F),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              icon: Icon(
                Icons.add,
                size: 24.0,
              ),
              label: Text('View order item'),
            ),
          ),
        )
      ],
    );
  }

  Widget itemlist() {
    return AnimationLimiter(
        child: (shirt_list.length == 0)
            ? Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Color(0xFFEB455F),
                  size: 70,
                ),
              )
            : Container(
                child: ListView.builder(
                    itemCount: searchcontroller_shirt.text.isNotEmpty
                        ? icon_nameOnSearch_shirt.length
                        : shirt_list.length,
                    shrinkWrap: true,
                    itemBuilder: (context, int index) {
                      var row = [];
                      if (icon_nameOnSearch_shirt.length != 0) {
                        row = icon_nameOnSearch_shirt;
                      } else {
                        row = shirt_list;
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
                                    child: SizedBox(
                                      width: 50,
                                      height: 75,
                                      child: Card(
                                        color: Color(0xffffffff),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xfff7f7f7),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 5,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                              radius: 12.5,
                                              backgroundColor:
                                                  const Color(0xFF2B3467),
                                              child: Text(
                                                count.toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )),
                                          title: Text(
                                            searchcontroller_shirt.text.isEmpty
                                                ? row[index]['name']
                                                : row[index]['name'],
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  letterSpacing: .1,
                                                  fontSize: 14,
                                                  color: Color(0xff19183e)),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              category_name =
                                                  row[index]["name"];
                                              item_group_name =
                                                  "SHIRT DHOTI SEGMENT";
                                            });

                                            template_list(
                                                category_name, item_group_name);
                                          },
                                        ),
                                      ),
                                    ),
                                  ))));
                    }),
              ));
  }

  Widget inner(Size size) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: Container(
              height: 48.0,
              alignment: Alignment.center,
              child: TextField(
                controller: searchcontroller_inner,
                onChanged: (value) {
                  setState(() {
                    value.trimLeft();
                    icon_nameOnSearch_inner = [];
                    for (var i = 0; i < inner_list.length; i++) {
                      var des2 = {};
                      des2["name"] = inner_list[i]["name"];
                      item_search_list_inner.add(des2);
                      if ((item_search_list_inner[i]["name"]
                          .toLowerCase()
                          .contains(value.trim().toLowerCase()))) {
                        var d2 = {};
                        d2["name"] = item_search_list_inner[i]["name"];
                        icon_nameOnSearch_inner.add(d2);
                      }
                    }
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide:
                          BorderSide(color: Color(0xFFEB455F), width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide:
                          BorderSide(color: Color(0xFFEB455F), width: 2.0),
                    ),
                    contentPadding: EdgeInsets.all(15),
                    hintText: "Search",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color.fromARGB(252, 4, 0, 0),
                    )),
              )),
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
                      {
                        'item_code': key,
                        'qty': value[1],
                        'item_group': value[0],
                        'item_name': value[2]
                      },
                    );
                  });
                  values_dict.sort(
                      (a, b) => (a['item_group']).compareTo(b['item_group']));
                  values_dict.removeAt(index_value);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  primary: Color(0xFFEB455F),
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

  Widget outer(Size size) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: Container(
              height: 48.0,
              alignment: Alignment.center,
              child: TextField(
                controller: searchcontroller_outer,
                onChanged: (value) {
                  setState(() {
                    value.trimLeft();
                    icon_nameOnSearch_outer = [];
                    for (var i = 0; i < outer_list.length; i++) {
                      var des3 = {};
                      des3["name"] = outer_list[i]["name"];
                      item_search_list_outer.add(des3);
                      if ((item_search_list_outer[i]["name"]
                          .toLowerCase()
                          .contains(value.trim().toLowerCase()))) {
                        var d3 = {};
                        d3["name"] = item_search_list_outer[i]["name"];
                        icon_nameOnSearch_outer.add(d3);
                      }
                    }
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide:
                          BorderSide(color: Color(0xFFEB455F), width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide:
                          BorderSide(color: Color(0xFFEB455F), width: 2.0),
                    ),
                    contentPadding: EdgeInsets.all(15),
                    hintText: "Search",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color.fromARGB(252, 4, 0, 0),
                    )),
              )),
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
                      {
                        'item_code': key,
                        'qty': value[1],
                        'item_group': value[0],
                        'item_name': value[2]
                      },
                    );
                  });
                  values_dict.sort(
                      (a, b) => (a['item_group']).compareTo(b['item_group']));
                  values_dict.removeAt(index_value);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  primary: Color(0xFFEB455F),
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
        child: (inner_list.length == 0)
            ? Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Color(0xFFEB455F),
                  size: 70,
                ),
              )
            : Container(
                child: ListView.builder(
                    itemCount: searchcontroller_inner.text.isNotEmpty
                        ? icon_nameOnSearch_inner.length
                        : inner_list.length,
                    shrinkWrap: true,
                    itemBuilder: (context, int index) {
                      var row = [];
                      if (icon_nameOnSearch_inner.length != 0) {
                        row = icon_nameOnSearch_inner;
                      } else {
                        row = inner_list;
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
                                    child: SizedBox(
                                      width: 50,
                                      height: 75,
                                      child: Card(
                                        color: Color(0xffffffff),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xfff7f7f7),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 5,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                              radius: 12.5,
                                              backgroundColor:
                                                  const Color(0xFF2B3467),
                                              child: Text(
                                                count.toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )),
                                          title: Text(
                                            searchcontroller_inner.text.isEmpty
                                                ? row[index]['name']
                                                : row[index]['name'],
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  letterSpacing: .1,
                                                  fontSize: 14,
                                                  color: Color(0xff19183e)),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              category_name =
                                                  row[index]["name"];
                                              item_group_name = "INNER SEGMENT";
                                            });
                                            template_list(
                                                category_name, item_group_name);
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
        child: (outer_list.length == 0)
            ? Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Color(0xFFEB455F),
                  size: 70,
                ),
              )
            : Container(
                child: ListView.builder(
                    itemCount: searchcontroller_outer.text.isNotEmpty
                        ? icon_nameOnSearch_outer.length
                        : outer_list.length,
                    shrinkWrap: true,
                    itemBuilder: (context, int index) {
                      var row = [];
                      if (icon_nameOnSearch_outer.length != 0) {
                        row = icon_nameOnSearch_outer;
                      } else {
                        row = outer_list;
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
                                    child: SizedBox(
                                      width: 50,
                                      height: 75,
                                      child: Card(
                                        color: Color(0xffffffff),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xfff7f7f7),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 5,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                              radius: 12.5,
                                              backgroundColor:
                                                  const Color(0xFF2B3467),
                                              child: Text(
                                                count.toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )),
                                          title: Text(
                                            searchcontroller_outer.text.isEmpty
                                                ? row[index]['name']
                                                : row[index]['name'],
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  letterSpacing: .1,
                                                  fontSize: 14,
                                                  color: Color(0xff19183e)),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              category_name =
                                                  row[index]["name"];
                                              item_group_name = "OUTER SEGMENT";
                                            });
                                            template_list(
                                                category_name, item_group_name);
                                          },
                                        ),
                                      ),
                                    ),
                                  ))));
                    }),
              ));
  }

  Future all_item() async {
    shirt_list = [];
    inner_list = [];
    outer_list = [];

    var response = await http.get(Uri.parse(
        """${dotenv.env['API_URL']}/api/method/oxo.custom.api.category_list"""));
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 1000));
      setState(() {
        for (var i = 0;
            i < json.decode(response.body)['message1'].length;
            i++) {
          shirt_list.add((json.decode(response.body)['message1'][i]));
        }
        shirt_list.sort((a, b) => a["name"].compareTo(b["name"]));

        for (var i = 0;
            i < json.decode(response.body)['message2'].length;
            i++) {
          inner_list.add((json.decode(response.body)['message2'][i]));
        }
        inner_list.sort((a, b) => a["name"].compareTo(b["name"]));
        for (var i = 0;
            i < json.decode(response.body)['message3'].length;
            i++) {
          outer_list.add((json.decode(response.body)['message3'][i]));
        }
        outer_list.sort((a, b) => a["name"].compareTo(b["name"]));
      });
    } else {
      return json.decode(response.body)['message'];
    }
  }

  Future template_list(category_name, item_group_name) async {
    print(category_name);
    print(item_group_name);
    category_item_list = [];
    var response = await http.get(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.item_price_list?name=$category_name"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    // var response = await http.get(
    //   Uri.parse(
    //       """${dotenv.env['API_URL']}/api/method/oxo.custom.api.template_list?category=$item_group_name&item_group=$category_name"""),
    //   // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    // );
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          category_item_list.add((json.decode(response.body)['message'][i]));
        }
      });
      if (category_item_list.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => category_group()),
        );
      }
    }
  }

  Future categorieslist_() async {
    categorieslist__ = [];

    var response = await http.get(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.categories_list"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    if (response.statusCode == 200) {
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          categorieslist__.add((json.decode(response.body)['message'][i]));
        }
        categorieslist__.sort();
        _tabController__ =
            TabController(length: categorieslist__.length, vsync: this);
      });
    }
  }
}
