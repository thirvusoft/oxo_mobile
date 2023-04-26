import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
    setState(() {
      searchcontroller_varient.text = "";
      rowVarient.clear();
      icon_nameOnSearch_varient = [];
      item_search_list_varient = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEB455F),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            icon_nameOnSearch_varient.clear();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        // backgroundColor: const Color(0xFFEB455F),
        title: Text(
          item_name_list,
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 20, letterSpacing: .2, color: Colors.white),
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              list.clear();
              print(values_dict);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const category()),
              );
              values_dict = [];
              values.forEach((key, value) {
                values_dict.add({
                  'item_code': key,
                  'qty': value[1],
                  'item_group': value[0],
                  'item_name': value[2]
                });
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEB455F),
            ),
            icon: const Icon(
              Icons.add,
              size: 24.0,
            ),
            label: const Text('Add item'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[item_varients(size)],
        ),
      ),
    );
  }

  Widget item_varients(Size size) {
    return Column(children: [
      const SizedBox(
        height: 10,
      ),
      Container(
        padding: const EdgeInsets.all(15),
        child: Theme(
          data: Theme.of(context).copyWith(
              colorScheme:
                  ColorScheme.fromSwatch().copyWith(secondary: Colors.white)),
          child: Container(
              height: 48.0,
              alignment: Alignment.center,
              child: TextField(
                cursorColor: const Color(0xFFEB455F),
                controller: searchcontroller_varient,
                onChanged: (value) {
                  setState(() {
                    value.trimLeft();
                    icon_nameOnSearch_varient = [];
                    for (var i = 0; i < varient_item_list.length; i++) {
                      var desVari = {};
                      desVari["item_name"] = varient_item_list[i]["item_name"];
                      item_search_list_varient.add(desVari);
                      if ((item_search_list_varient[i]["item_name"]
                          .toLowerCase()
                          .contains(value.trim().toLowerCase()))) {
                        var dVa = {};
                        dVa["item_name"] =
                            item_search_list_varient[i]["item_name"];
                        icon_nameOnSearch_varient.add(dVa);
                        print(icon_nameOnSearch_varient);

                        icon_nameOnSearch_varient.sort((a, b) {
                          int comparison = a['item_name']
                              .split('(')[1]
                              .split(')')[0]
                              .compareTo(
                                  b['item_name'].split('(')[1].split(')')[0]);
                          if (comparison == 0) {
                            comparison = a['item_name']
                                .split('-')
                                .last
                                .compareTo(b['item_name'].split('-').last);
                          }
                          return comparison;
                        });

                        icon_nameOnSearch_varient.sort((a, b) {
                          String aSize =
                              a["item_name"].split("-").last.toLowerCase();
                          String bSize =
                              b["item_name"].split("-").last.toLowerCase();
                          List<String> sizes = [
                            "s",
                            "m",
                            "l",
                            "xl",
                            "2xl",
                            "3xl"
                          ];
                          int aIndex = sizes.indexOf(aSize);
                          int bIndex = sizes.indexOf(bSize);
                          return aIndex.compareTo(bIndex);
                        });
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
      ),
      SizedBox(
        height: size.height * .73,
        child: itemlist(),
      )
    ]);
  }

  Widget itemlist() {
    return AnimationLimiter(
        child: (varient_item_list.isEmpty)
            ? Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: const Color(0xFFEB455F),
                  size: 70,
                ),
              )
            : ListView.builder(
                itemCount: searchcontroller_varient.text.isNotEmpty
                    ? icon_nameOnSearch_varient.length
                    : varient_item_list.length,
                shrinkWrap: true,
                itemBuilder: (context, int index) {
                  if (icon_nameOnSearch_varient.isNotEmpty) {
                    rowVarient = icon_nameOnSearch_varient;
                  } else {
                    rowVarient = varient_item_list;
                  }
                  list.add(TextEditingController());

                  int count = index + 1;
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 300),
                      child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: FadeInAnimation(
                                  child: SizedBox(
                                      width: 50,
                                      height: 80,
                                      child: Card(
                                          color: const Color(0xffffffff),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Color(0xfff7f7f7),
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 5,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                                radius:
                                                    (count > 99) ? 14 : 12.5,
                                                backgroundColor:
                                                    const Color(0xFF2B3467),
                                                child: Text(
                                                  count.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                )),
                                            title: Text(
                                              searchcontroller_varient
                                                      .text.isEmpty
                                                  ? rowVarient[index]
                                                      ['item_name']
                                                  // +
                                                  // "   "
                                                  // +
                                                  // row_varient[index]
                                                  //     ['item_code']
                                                  : rowVarient[index]
                                                      ['item_name']
                                              // +
                                              // "   "
                                              //  +
                                              // row_varient[index]
                                              //     ['item_code']
                                              ,
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    letterSpacing: .1,
                                                    fontSize:
                                                        (MediaQuery.of(context)
                                                                    .size
                                                                    .width >=
                                                                360)
                                                            ? 12
                                                            : 14,
                                                    color: const Color(
                                                        0xff19183e)),
                                              ),
                                            ),
                                            // subtitle: Text(
                                            //   varient_item_list[index]
                                            //           ["standard_rate"]
                                            //       .toString(),
                                            //   style: GoogleFonts.poppins(
                                            //     textStyle: TextStyle(
                                            //         letterSpacing: .1,
                                            //         color:const Color(0xFFEB455F)),
                                            //   ),
                                            // ),
                                            // controller: list[index],
                                            trailing:
                                                Wrap(spacing: 12, children: <
                                                    Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 1.0),
                                                child: SizedBox(
                                                  height: 45,
                                                  width: 70,
                                                  child: TextFormField(
                                                    cursorColor:
                                                        const Color(0xFFEB455F),
                                                    controller: list[index],
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15.0,
                                                      color: const Color(
                                                          0xFF151624),
                                                    ),
                                                    maxLines: 1,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onChanged: ((qty) {
                                                      var itemName =
                                                          varient_item_list[
                                                                  index]
                                                              ["item_code"];
                                                      var itemGroup =
                                                          varient_item_list[
                                                                  index]
                                                              ["item_group"];
                                                      var itemNameList =
                                                          varient_item_list[
                                                                  index]
                                                              ["item_name"];

                                                      if (qty != '') {
                                                        List<String> test = [];
                                                        test.add(itemGroup
                                                            .toString());

                                                        test.add(
                                                            qty.toString());

                                                        test.add(itemNameList
                                                            .toString());
                                                        values[itemName] = test;
                                                        // values[item_name] =
                                                        //     test;
                                                      } else {
                                                        values[itemName] = 0;
                                                      }
                                                      varient_item_list[index]
                                                          ["qty"] = qty;
                                                    }),
                                                    decoration: InputDecoration(
                                                      counterText: "",
                                                      hintText: 'QTY',
                                                      hintStyle:
                                                          GoogleFonts.inter(
                                                        fontSize: 15.0,
                                                        color: const Color(
                                                                0xFF151624)
                                                            .withOpacity(0.5),
                                                      ),
                                                      filled: true,
                                                      fillColor: list[index]
                                                              .text
                                                              .isEmpty
                                                          ? const Color
                                                                  .fromRGBO(
                                                              248, 247, 251, 1)
                                                          : Colors.transparent,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  BorderSide(
                                                                color: list[index]
                                                                        .text
                                                                        .isEmpty
                                                                    ? Colors
                                                                        .transparent
                                                                    : const Color(
                                                                        0xFFEB455F),
                                                              )),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Color(
                                                                    0xFFEB455F),
                                                              )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          )))))));
                }));
  }
}
