import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oxo/screens/Sales%20Order/sales_order.dart';
import 'package:oxo/screens/Sales%20Order/variant.dart';
import '../../constants.dart';

class category_group extends StatefulWidget {
  @override
  State<category_group> createState() => _category_groupState();
}

class _category_groupState extends State<category_group> {
  void initState() {
    varient_item_list = [];
    setState(() {
      searchcontroller_category.text = "";
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
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),

        // backgroundColor: const Color(0xFFEB455F),
        title: Text(
          category_name,
          style: GoogleFonts.poppins(
            textStyle:
                TextStyle(fontSize: 20, letterSpacing: .2, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[item_template(size)],
        ),
      ),
    );
  }

  Widget item_template(Size size) {
    return Column(children: [
      const SizedBox(
        height: 10,
      ),
      Container(
        padding: EdgeInsets.all(15),
        child: Container(
            height: 48.0,
            alignment: Alignment.center,
            child: TextField(
              cursorColor: const Color(0xFFEB455F),
              controller: searchcontroller_category,
              onChanged: (value) {
                setState(() {
                  value.trimLeft();
                  icon_nameOnSearch_category = [];
                  for (var i = 0; i < category_item_list.length; i++) {
                    var des_vari = {};
                    des_vari["item_name"] = category_item_list[i]["item_name"];
                    item_search_list_category.add(des_vari);
                    if ((item_search_list_category[i]["item_name"]
                        .toLowerCase()
                        .contains(value.trim().toLowerCase()))) {
                      var d_va = {};
                      d_va["item_name"] =
                          item_search_list_category[i]["item_name"];
                      icon_nameOnSearch_category.add(d_va);
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
      SizedBox(
        height: size.height * .73,
        child: itemlist(size),
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
                values_dict.add(
                  {
                    'item_code': key,
                    'qty': value[1],
                    'item_group': value[0],
                    'item_name': value[2]
                  },
                );
              });
              values_dict
                  .sort((a, b) => (a['item_group']).compareTo(b['item_group']));
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
      )
    ]);
  }

  Widget itemlist(Size size) {
    return AnimationLimiter(
        child: (category_item_list.isEmpty)
            ? Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Color(0xFFEB455F),
                  size: 70,
                ),
              )
            : Container(
                child: ListView.builder(
                    itemCount: searchcontroller_category.text.isNotEmpty
                        ? icon_nameOnSearch_category.length
                        : category_item_list.length,
                    shrinkWrap: true,
                    itemBuilder: (context, int index) {
                      var row_template = [];
                      if (icon_nameOnSearch_category.isNotEmpty) {
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
                                                  searchcontroller_category
                                                          .text.isEmpty
                                                      ? row_template[index]
                                                              ['item_name'] +
                                                          "  "
                                                      // +
                                                      // row_template[index]
                                                      //     ['item_code']
                                                      : row_template[index]
                                                              ['item_name'] +
                                                          "  "
                                                  // +
                                                  // row_template[index]
                                                  //     ['item_code'],
                                                  ,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        letterSpacing: .1,
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff19183e)),
                                                  ),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    item_name =
                                                        row_template[index]
                                                            ["item_code"];
                                                    item_name_list =
                                                        row_template[index]
                                                            ["item_name"];
                                                  });
                                                  varient_item_list = [];
                                                  varient_list(item_name);
                                                },
                                              )))))));
                    }),
              ));
  }

  Future varient_list(item_name) async {
    setState(() {
      rowVarient.clear();

      varient_item_list = [];
      icon_nameOnSearch_varient = [];

      icon_nameOnSearch_varient = [];
    });

    var response = await http.get(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.varient_list?item=${Uri.encodeComponent(item_name)}"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );

    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          varient_item_list.add((json.decode(response.body)['message'][i]));
        }
        print(varient_item_list);
        List<String> sizes = ["s", "m", "l", "xl", "2xl", "3xl", "4xl", "5xl"];

        // Sorting based on whether the item code contains a letter or a number
        varient_item_list.sort((a, b) {
          String aItemCode = a['item_code'];
          String bItemCode = b['item_code'];

          bool aContainsLetter =
              RegExp(r'[a-zA-Z]').hasMatch(aItemCode.split('-').last);
          bool bContainsLetter =
              RegExp(r'[a-zA-Z]').hasMatch(bItemCode.split('-').last);

          if (aContainsLetter && bContainsLetter) {
            String aSize = aItemCode.split("-").last.toLowerCase();
            String bSize = bItemCode.split("-").last.toLowerCase();
            int aIndex = sizes.indexOf(aSize);
            int bIndex = sizes.indexOf(bSize);
            return aIndex.compareTo(bIndex);
          } else if (!aContainsLetter && !bContainsLetter) {
            int itemCodeA = int.parse(aItemCode.split('-')[1]);
            int itemCodeB = int.parse(bItemCode.split('-')[1]);
            return itemCodeA.compareTo(itemCodeB);
          } else {
            // If one item code contains a letter and the other contains a number, prioritize the one with the number.
            return aContainsLetter ? 1 : -1;
          }
        });

        
      });
      
      if (varient_item_list.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item_group()),
        );
      }
    }
  }
}
