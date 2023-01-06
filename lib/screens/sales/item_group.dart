import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oxo/screens/sales/order.dart';

import '../../constants.dart';
import 'item_category_list.dart';

class item_group extends StatefulWidget {
  @override
  State<item_group> createState() => _item_groupState();
}

class _item_groupState extends State<item_group> {
  @override
  void initState() {
    values_dict = [];
    print('wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww');
    print(varient_item_list);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: Color.fromRGBO(44, 185, 176, 1),
        title: Text(
          item_name,
          style: GoogleFonts.poppins(
            textStyle:
                TextStyle(fontSize: 20, letterSpacing: .2, color: Colors.white),
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              list.clear();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => category()),
              );
              values_dict = [];
              values.forEach((key, value) {
                values_dict
                    .add({'item_code': key, 'qty': value[1], 'rate': value[0]});
                print(values_dict);
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
    return Column(children: [
      Container(
        padding: EdgeInsets.all(15),
        child: Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.white),
          child: Container(
              height: 48.0,
              alignment: Alignment.center,
              child: TextField(
                controller: searchcontroller_varient,
                onChanged: (value) {
                  setState(() {
                    value.trimLeft();
                    icon_nameOnSearch_varient = [];
                    for (var i = 0; i < varient_item_list.length; i++) {
                      var des_vari = {};
                      des_vari["item_code"] = varient_item_list[i]["item_code"];
                      item_search_list_varient.add(des_vari);
                      if ((item_search_list_varient[i]["item_code"]
                          .toLowerCase()
                          .contains(value.trim().toLowerCase()))) {
                        var d_va = {};
                        d_va["item_code"] =
                            item_search_list_varient[i]["item_code"];
                        icon_nameOnSearch_varient.add(d_va);
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
             child:(varient_item_list.length==0)?Center(child:LoadingAnimationWidget.fourRotatingDots(
          color: Color(0xFFEB455F),
          size: 70,
        ),): Container(
      child: ListView.builder(
          itemCount: searchcontroller_varient.text.isNotEmpty
              ? icon_nameOnSearch_varient.length
              : varient_item_list.length,
              
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            var row_varient = [];
            if (icon_nameOnSearch_varient.length != 0) {
              row_varient = icon_nameOnSearch_varient;
            } else {
              row_varient = varient_item_list;
              print('pppppppppppppppppppppppppppppppppppp');
              print(varient_item_list);
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
                                        searchcontroller_varient.text.isEmpty
                                            ? row_varient[index]['item_code']
                                            : row_varient[index]['item_code'],
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              letterSpacing: .1,
                                              color: Color(0xff19183e)),
                                        ),
                                      ),
                                      // subtitle: Text(
                                      //   varient_item_list[index]
                                      //           ["standard_rate"]
                                      //       .toString(),
                                      //   style: GoogleFonts.poppins(
                                      //     textStyle: TextStyle(
                                      //         letterSpacing: .1,
                                      //         color:Color.fromRGBO(44, 185, 176, 1)),
                                      //   ),
                                      // ),
                                      // controller: list[index],
                                      trailing:
                                          Wrap(spacing: 12, children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 1.0),
                                          child: SizedBox(
                                            height: 45,
                                            width: 70,
                                            child: TextFormField(
                                              controller: list[index],
                                              style: GoogleFonts.inter(
                                                fontSize: 15.0,
                                                color: const Color(0xFF151624),
                                              ),
                                              maxLines: 1,
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: ((qty) {
                                                var item_name =
                                                    varient_item_list[index]
                                                        ["item_code"];
                                                var item_rate =
                                                    varient_item_list[index]
                                                        ["standard_rate"];
                                                print(item_rate);
                                                if (qty != '') {
                                                  List<String> test = [];
                                                  test.add(
                                                      item_rate.toString());
                                                  test.add(qty.toString());
                                                  values[item_name] = test;
                                                  values[item_name] = test;
                                                } else {
                                                  values[item_name] = 0;
                                                }
                                                varient_item_list[index]
                                                    ["qty"] = qty;
                                                print(
                                                    '111111111111111111111111111111111111111111111111111111111111111111111111111');
                                                print(values);
                                              }),
                                              cursorColor:
                                                  const Color(0xFF151624),
                                              decoration: InputDecoration(
                                                counterText: "",
                                                hintText: 'QTY',
                                                hintStyle: GoogleFonts.inter(
                                                  fontSize: 15.0,
                                                  color: const Color(0xFF151624)
                                                      .withOpacity(0.5),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    list[index].text.isEmpty
                                                        ? const Color.fromRGBO(
                                                            248, 247, 251, 1)
                                                        : Colors.transparent,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide: BorderSide(
                                                          color: list[index]
                                                                  .text
                                                                  .isEmpty
                                                              ? Colors
                                                                  .transparent
                                                              : const Color
                                                                      .fromRGBO(
                                                                  44,
                                                                  185,
                                                                  176,
                                                                  1),
                                                        )),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Color.fromRGBO(
                                                              44, 185, 176, 1),
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
}
