import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:oxo/constants.dart';
import 'package:oxo/screens/Home%20Page/home_page.dart';
import 'package:oxo/screens/Sales%20Order/item_category_list.dart';

import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;

class sales_order extends StatefulWidget {
  const sales_order({super.key});

  @override
  State<sales_order> createState() => _sales_orderState();
}

class _sales_orderState extends State<sales_order> {
  @override
  final ScrollController controller = ScrollController();

  List districts = [];
  List distributorname = [];
  TextEditingController district_list_text = TextEditingController();
  TextEditingController Competitors = TextEditingController();

  void initState() {
    district();
    super.initState();
    total_qty = 0.0;
    for (var i = 0; i < values_dict.length; i++) {
      total_qty += double.parse(values_dict[i]['qty']);
    }
    // values_dict.sort((a, b) => (a['item_group']).compareTo(b['item_group']));
    // values_dict.sort((a, b) {
    //   int aNum = int.parse(a['item_name'].split('-').last);
    //   int bNum = int.parse(b['item_name'].split('-').last);
    //   return aNum.compareTo(bNum);
    // });
    values_dict.sort((a, b) => a["item_group"].compareTo(b["item_group"]));
    employeeDataSource = EmployeeDataSource(employeeData: values_dict);
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
              Get.to(const home_page());
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          // backgroundColor: Colors(O),
          title: Text(
            'ORDER FORMS',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontSize: 20, letterSpacing: .2, color: Colors.white),
            ),
          ),
        ),
        body: Scrollbar(
            controller: controller,
            trackVisibility: true,
            thickness: 8,
            radius: const Radius.circular(20),
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                child: SafeArea(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        // bottom: 20.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: <Widget>[
                              // customer_details(size),
                              SearchField(
                                controller: district_list_text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select District';
                                  }
                                  if (!districts.contains(value)) {
                                    return 'District not found';
                                  }
                                  return null;
                                },
                                suggestions: districts
                                    .map(
                                        (String) => SearchFieldListItem(String))
                                    .toList(),
                                suggestionState: Suggestion.expand,
                                textInputAction: TextInputAction.next,
                                hasOverlay: false,
                                marginColor: Colors.white,
                                searchStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                                onSuggestionTap: (x) {
                                  FocusScope.of(context).unfocus();
                                  distributor_list(district_list_text.text);
                                },
                                searchInputDecoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFF808080)),
                                  ),
                                  // border: OutlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(
                                    // borderRadius: BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: Color(0xFFEB455F), width: 2.0),
                                  ),
                                  labelText: "District",
                                  // hintText: "State"
                                ),
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: item(size))
                              // buildFooter(size),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget item(Size size) {
    return Container(
      child: Column(
        children: [
          SingleChildScrollView(child: itemtable(size)),
          SizedBox(
            height: size.height * 0.02,
          ),
          // addbutton(size),
          // SizedBox(
          //   height: size.height * 0.02,
          // ),
        ],
      ),
    );
  }

  Widget deliverydate(Size size) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          height: size.height / 12,
          child: TextFormField(
            textInputAction: TextInputAction.next,
            controller: delivery_date,
            validator: (x) {
              if (x!.isEmpty) {
                return " Date can't be empty";
              }

              return null;
            },
            decoration: InputDecoration(
              hintText: 'Delivery Date',
              hintStyle: GoogleFonts.inter(
                fontSize: 16.0,
                color: const Color(0xFF151624).withOpacity(0.5),
              ),
              filled: true,
              fillColor: delivery_date.text.isEmpty
                  ? const Color.fromRGBO(248, 247, 251, 1)
                  : Colors.transparent,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: delivery_date.text.isEmpty
                        ? Colors.transparent
                        : const Color(0xFFEB455F),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: const Color(0xFFEB455F),
                  )),
            ),
            style: const TextStyle(),
            readOnly: true,
            onTap: () async {
              var date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101));

              builder:
              (BuildContext context, Widget child) {
                return Theme(
                  data: ThemeData().copyWith(
                      colorScheme: const ColorScheme.dark(
                          primary: Color(0xff19183e),
                          surface: Color(0xff19183e))),
                  child: child,
                );
              };
              delivery_date.text = date.toString().substring(0, 10);
            },
          ),
        ));
  }

  Widget itemtable(Size size) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child:
            // Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //     child:
            SizedBox(
                height: size.height * 0.9,
                child: SfDataGridTheme(
                  data: SfDataGridThemeData(
                      headerColor: const Color.fromARGB(255, 248, 255, 254)),

                  child: SfDataGrid(
                    allowPullToRefresh: true,

                    source: employeeDataSource,
                    columnWidthMode: ColumnWidthMode.fill,

                    allowSorting: true,
                    // allowMultiColumnSorting: true,
                    startSwipeActionsBuilder:
                        (BuildContext context, DataGridRow row, int rowIndex) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const category()),
                            );
                          },
                          child: Container(
                              color: const Color(0xFFEB455F),
                              child: const Center(
                                child: Icon(Icons.add),
                              )));
                    },
                    footerFrozenRowsCount: 1,
                    endSwipeActionsBuilder:
                        (BuildContext context, DataGridRow row, int rowIndex) {
                      return GestureDetector(
                          onTap: () {
                            employeeDataSource._employeeData.removeAt(rowIndex);

                            employeeDataSource.updateDataGridSource();
                            setState(() {
                              index_value = rowIndex;

                              total_qty -=
                                  double.parse(values_dict[index_value]['qty']);
                              values_dict.removeAt(index_value);
                            });
                          },
                          child: Container(
                              color: const Color(0xffe8effc),
                              child: const Center(
                                child: Icon(
                                  Icons.delete,
                                  color: Color(0xFFEB455F),
                                ),
                              )));
                    },
                    footerHeight: 100.0,
                    footer: Column(children: [
                      Container(
                          child: Row(
                        children: [
                          const Expanded(
                              child: Center(
                                  child: Text(
                            'TOTAL',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Center(
                                  child: Text(total_qty.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)))),
                        ],
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 15.0),
                                  backgroundColor: const Color(0xFF2B3467),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                icon: const Icon(
                                  Icons.add,
                                  size: 24.0,
                                ),
                                label: Text(
                                  'Add item',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        letterSpacing: .5,
                                        fontSize: 15,
                                        color: Color(0xFFffffff)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      )
                    ]),
                    allowSwiping: true,
                    isScrollbarAlwaysShown: true,

                    columns: <GridColumn>[
                      GridColumn(
                          columnName: 'name',
                          label: Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xffe8effc)),
                              child: Center(
                                child: Text(
                                  'Item Name',
                                  // overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        letterSpacing: .5,
                                        fontSize: 17,
                                        color: Color(0xFF2B3467)),
                                  ),
                                ),
                              ))),
                      // GridColumn(
                      //     columnName: 'item_group',
                      //     label: Container(
                      //         padding: EdgeInsets.all(20.0),
                      //         child: Text(
                      //           'Item Group',
                      //           overflow: TextOverflow.ellipsis,
                      //           style: TextStyle(fontWeight: FontWeight.bold),
                      //         ))),
                      GridColumn(
                        columnName: 'qty',
                        label: Container(
                            decoration:
                                const BoxDecoration(color: Color(0xffe8effc)),
                            child: Center(
                              child: Text(
                                'Quantity',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      letterSpacing: .5,
                                      fontSize: 17,
                                      color: Color(0xFF2B3467)),
                                ),
                              ),
                            )),
                      ),

                      // GridColumn(
                      //     columnName: 'designation',
                      //     label: Container(
                      //         padding: EdgeInsets.all(20.0),
                      //         child: Text(
                      //           'Designation',
                      //           overflow: TextOverflow.ellipsis,
                      //         ))),
                    ],
                  ),
                  // )
                )));
  }

  Future<void> _showMyDialog() async {
    final size = MediaQuery.of(context).size;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              scrollable: true,
              title: const Text("Dealer Details"),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Form(
                    key: sales_order_key,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 2.3,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            SearchField(
                              controller: distributor_name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select distributor name';
                                }
                                if (!distributorname.contains(value)) {
                                  return 'Distributor not found';
                                }
                                return null;
                              },
                              suggestions: distributorname
                                  .map((String) => SearchFieldListItem(String))
                                  .toList(),
                              suggestionState: Suggestion.expand,
                              textInputAction: TextInputAction.next,
                              hasOverlay: false,
                              searchStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.8),
                              ),
                              marginColor: Colors.white,
                              searchInputDecoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFF808080)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFEB455F), width: 2.0),
                                ),
                                labelText: "Distributor Name",
                              ),
                              maxSuggestionsInViewPort: 10,
                              suggestionsDecoration: null,
                              itemHeight: 50,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              // width: MediaQuery.of(context).size.width / 1.2,
                              child: SearchField(
                                controller: customer_name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select dealer name';
                                  }
                                  if (!dealer_name.contains(value)) {
                                    return 'Dealer name not found';
                                  }
                                  return null;
                                },
                                suggestions: dealer_name
                                    .map((String) => SearchFieldListItem(String,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              String,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        )))
                                    .toList(),
                                suggestionState: Suggestion.expand,
                                marginColor: Colors.white,
                                onSuggestionTap: (x) {},
                                textInputAction: TextInputAction.next,
                                hasOverlay: false,
                                searchStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                                searchInputDecoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFF808080)),
                                  ),
                                  // border: OutlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(
                                    // borderRadius: BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: Color(0xFFEB455F), width: 2.0),
                                  ),
                                  labelText: "Dealer name",
                                  // hintText: "State"
                                ),
                                maxSuggestionsInViewPort: 5,
                                suggestionsDecoration: null,
                                itemHeight: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: delivery_date,
                              validator: (x) {
                                if (x!.isEmpty) {
                                  return " Date can't be empty";
                                }

                                return null;
                              },
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFF808080)),
                                ),
                                // border: OutlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  //                           // borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEB455F), width: 2.0),
                                ),
                                labelText: "Delivery date",
                                // hintText: "Pincode"
                              ),
                              readOnly: true,
                              onTap: () async {
                                var date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101));

                                builder:
                                (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData().copyWith(
                                        colorScheme: const ColorScheme.dark(
                                            primary: Color(0xff19183e),
                                            surface: Color(0xff19183e))),
                                    child: child,
                                  );
                                };
                                delivery_date.text =
                                    date.toString().substring(0, 10);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: Competitors,
                              validator: (x) {
                                if (x!.isEmpty) {
                                  return " Date can't be empty";
                                }

                                return null;
                              },
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFF808080)),
                                ),
                                // border: OutlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  //                           // borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEB455F), width: 2.0),
                                ),
                                labelText: "Competitors",
                                // hintText: "Pincode"
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AnimatedButton(
                              text: 'Submit',
                              color: const Color.fromARGB(255, 49, 47, 92),
                              pressEvent: () {
                                if (sales_order_key.currentState!.validate()) {
                                  sales_order(
                                      customer_name.text,
                                      delivery_date.text,
                                      values_dict,
                                      distributor_name.text,
                                      username,
                                      Competitors.text);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ));
              }));
        });
  }

  Future distributor_list(list) async {
    distributorname = [];

    dealer_name = [];
    var response = await http.get(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.sales_partner?area=${list}"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    if (response.statusCode == 200) {
      setState(() {
        for (var i = 0;
            i < json.decode(response.body)['sales_partner'].length;
            i++) {
          setState(() {
            distributorname
                .add((json.decode(response.body)['sales_partner'][i]));
          });
          distributorname.sort();
        }
        distributorname.sort();
        for (var j = 0; j < json.decode(response.body)['Dealer'].length; j++) {
          setState(() {
            dealer_name.add((json.decode(response.body)['Dealer'][j]));
          });
          // distributor.add((json.decode(response.body)['message'][i]));
        }
        dealer_name.sort();
        _showMyDialog();
      });
    }
  }

  Future district() async {
    districts = [];
    SharedPreferences token = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.parse(
            """${dotenv.env['API_URL']}/api/method/oxo.custom.api.district_list"""),
        headers: {"Authorization": token.getString("token") ?? ""});

    if (response.statusCode == 200) {
      setState(() {
        for (var i = 0;
            i < json.decode(response.body)['district_list'].length;
            i++) {
          districts.add((json.decode(response.body)['district_list'][i]));
        }
        districts.sort();
      });
    }
  }

  Future sales_order(customerName, deliveryDate, valuesDict, distributorName,
      username, Competitors) async {
    valuesDict = Uri.encodeComponent(jsonEncode(valuesDict));
    SharedPreferences token = await SharedPreferences.getInstance();
    var user;
    setState(() {
      user = token.getString('full_name');
    });
    var response = await http.get(
        Uri.parse(
            """${dotenv.env['API_URL']}/api/method/oxo.custom.api.sales_order?cus_name=${customerName}&due_date=${deliveryDate}&items=${valuesDict}&distributor=${distributorName}&sales_person=${username}&Competitors=${Competitors}"""),
        headers: {"Authorization": token.getString("token") ?? ""});

    if (response.statusCode == 200) {
      setState(() {
        AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          title: 'Orderd Sucessfully',
          btnOkOnPress: () {
            valuesDict = [];
            values = {};

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const home_page()));
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {},
        ).show();
      });
      clear();
    } else {
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.error,
        title: (json.decode(response.body)['message']),
        btnOkOnPress: () {
          valuesDict = [];
          values = {};

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const home_page()),
          );
        },
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {},
      ).show();
    }
  }

  void clear() {
    district_list_text.clear();
    customer_name.clear();
    district_list_text.clear();
    distributor_name.clear();
    delivery_date.clear();
    Competitors.clear();
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(
                  columnName: 'name', value: e['item_name'].toString()),
              DataGridCell<String>(
                  columnName: 'qty', value: e['qty'].toString()),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            e.value.toString(),
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  letterSpacing: .5, fontSize: 12, color: Color(0xFF2B3467)),
            ),
          ));
    }).toList());
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
