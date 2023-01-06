import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:oxo/screens/sales/item_group.dart';
import 'package:oxo/screens/sales/order.dart';
import 'package:oxo/screens/sales/sales_order.dart';

import '../../constants.dart';

class category_group extends StatefulWidget {
  @override
  State<category_group> createState() => _category_groupState();
}

class _category_groupState extends State<category_group> {
  @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: Color.fromRGBO(44, 185, 176, 1),
        title: Text(
          category_name,
          style: GoogleFonts.poppins(
            textStyle:
                TextStyle(fontSize: 20, letterSpacing: .2, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            child: Stack(children: <Widget>[
              Column(
                children: <Widget>[item_template(size)],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget item_template(Size size) {
    return Column(children: [
      Container(
        padding: EdgeInsets.all(15),
        child: Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.white),
          child: Container(
              height: 48.0,
              alignment: Alignment.center,
              child: TextField(
                controller: searchcontroller_category,
                onChanged: (value) {
                  setState(() {
                    value.trimLeft();
                    icon_nameOnSearch_category = [];
                    for (var i = 0; i < category_item_list.length; i++) {
                      var des_vari = {};
                      des_vari["item_code"] =
                          category_item_list[i]["item_code"];
                      item_search_list_category.add(des_vari);
                      if ((item_search_list_category[i]["item_code"]
                          .toLowerCase()
                          .contains(value.trim().toLowerCase()))) {
                        var d_va = {};
                        d_va["item_code"] =
                            item_search_list_category[i]["item_code"];
                        icon_nameOnSearch_category.add(d_va);
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
        // height: size.height*2,
        child: itemlist(),
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
                  values_dict.add({'item_code': key, 'qty': value[1]});
                });
                values_dict.removeAt(index_value);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
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
    ]);
  }

  Widget itemlist() {
    return AnimationLimiter(
        child: Container(
      child: ListView.builder(
          itemCount: searchcontroller_category.text.isNotEmpty
              ? icon_nameOnSearch_category.length
              : category_item_list.length,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            var row_template = [];
            if (icon_nameOnSearch_category.length != 0) {
              row_template = icon_nameOnSearch_category;
            } else {
              row_template = category_item_list;
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
                                        searchcontroller_category.text.isEmpty
                                            ? row_template[index]['item_code']
                                            : row_template[index]['item_code'],
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              letterSpacing: .1,
                                              color: Color(0xff19183e)),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          item_name =
                                              row_template[index]["item_code"];
                                        });
                                        varient_list(item_name);
                                      },
                                    )))))));
          }),
    ));
  }

  Future varient_list(item_name) async {
    print("object");
    print(item_name);
    varient_item_list = [];
    var response = await http.get(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.varient_list?item=${item_name}"""),
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => item_group()),
      );
    }
  }
}