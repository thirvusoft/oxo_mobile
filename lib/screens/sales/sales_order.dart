import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/constants.dart';
import 'package:oxo/screens/sales/home_page.dart';
import 'package:oxo/screens/sales/item_category_list.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;

import 'order_page.dart';

class sales_order extends StatefulWidget {
  const sales_order({super.key});

  @override
  State<sales_order> createState() => _sales_orderState();
}

class _sales_orderState extends State<sales_order> {
  @override
  void initState() {
    dealername_list();
    district_list();
    super.initState();
    print(
        '00000000000000000000000000000000000000000000000000000000000000000000000000000');
    print(
        '00000000000000000000000000000000000000000000000000000000000000000000000000000');
    print(
        '00000000000000000000000000000000000000000000000000000000000000000000000000000');
    print(values_dict);
    total_qty = 0.0;
    for (var i = 0; i < values_dict.length; i++) {
      total_qty += double.parse(values_dict[i]['qty']);
      print(values_dict[i]['qty'].runtimeType);
      print(total_qty);
    }
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const home_page()),
              );
            },
            icon: const Icon(Icons.arrow_back_outlined),
          ),
          // backgroundColor: Colors(O),
          title: Text(
            'ORDER FORM',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 20, letterSpacing: .2, color: Colors.white),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    // bottom: 20.0,
                    child: Column(
                      children: <Widget>[
                        // customer_details(size),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: SearchField(
                            controller: district_list_text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select dealer name';
                              }
                              return null;
                            },
                            suggestions: districts_list
                                .map((String) => SearchFieldListItem(String,
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            String,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ))))
                                .toList(),
                            suggestionState: Suggestion.expand,
                            onSuggestionTap: (x) {
                              FocusScope.of(context).unfocus();

                              distributor_list(district_list_text.text);
                              // Navigator.pop(context);
                              // _showMyDialog();
                            },
                            textInputAction: TextInputAction.next,
                            hasOverlay: false,
                            searchStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.black.withOpacity(0.8),
                            ),
                            searchInputDecoration: InputDecoration(
                              hintText: 'Select District',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 16.0,
                                color: const Color(0xFF151624).withOpacity(0.5),
                              ),
                              filled: true,
                              fillColor: customer_name.text.isEmpty
                                  ? const Color.fromRGBO(248, 247, 251, 1)
                                  : Colors.transparent,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: customer_name.text.isEmpty
                                        ? Colors.transparent
                                        : const Color(0xff19183e),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: const Color(0xff19183e),
                                  )),
                            ),
                            maxSuggestionsInViewPort: 5,
                            itemHeight: 35,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: item(size))
                        // buildFooter(size),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget item(Size size) {
    return Container(
      child: Column(
        children: [
          itemtable(size),
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
            style: TextStyle(),
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
                      colorScheme: ColorScheme.dark(
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
    return
        // Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //     child:
        SizedBox(
            height: size.height * 0.9,
            child: SfDataGridTheme(
              data: SfDataGridThemeData(
                  headerColor: const Color.fromARGB(255, 248, 255, 254)),

              child: SfDataGrid(
                source: employeeDataSource,
                startSwipeActionsBuilder:
                    (BuildContext context, DataGridRow row, int rowIndex) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => category()),
                        );
                      },
                      child: Container(
                          color: const Color(0xFFEB455F),
                          child: Center(
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
                          print('lllllllllllllllllllllllllll');
                          print(values_dict);
                          index_value = rowIndex;
                          print(index_value);

                          print('12345676544');
                          print(values_dict[index_value]['qty']);

                          total_qty -=
                              double.parse(values_dict[index_value]['qty']);
                          values_dict.removeAt(index_value);

                          print(values_dict);
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
                      Expanded(
                          child: Center(
                              child: Text(
                        'TOTAL',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Center(
                              child: Text(total_qty.toString(),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                    ],
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => category()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 15.0),
                              backgroundColor: const Color(0xFF2B3467),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            icon: Icon(
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
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showMyDialog();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              primary: const Color(0xFF2B3467),
                            ),
                            icon: Icon(
                              Icons.check,
                              size: 24.0,
                            ),
                            label: Text(
                              'Submit',
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
                    ],
                  ))
                ]),
                allowSwiping: true,
                isScrollbarAlwaysShown: true,
                columnWidthMode: ColumnWidthMode.fill,
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
            ));
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
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width / 1,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                              width: 10,
                            ),
                            SizedBox(
                              // width: MediaQuery.of(context).size.width / 1.2,
                              child: SearchField(
                                controller: customer_name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select dealer name';
                                  }
                                  return null;
                                },
                                suggestions: dealer_name
                                    .map((String) => SearchFieldListItem(String,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              String,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        )))
                                    .toList(),
                                suggestionState: Suggestion.expand,
                                onSuggestionTap: (x) {},
                                textInputAction: TextInputAction.next,
                                hasOverlay: false,
                                searchStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                                searchInputDecoration: InputDecoration(
                                  hintText: 'Select Dealer name',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    color: const Color(0xFF151624)
                                        .withOpacity(0.5),
                                  ),
                                  filled: true,
                                  fillColor: customer_name.text.isEmpty
                                      ? const Color.fromRGBO(248, 247, 251, 1)
                                      : Colors.transparent,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: customer_name.text.isEmpty
                                            ? Colors.transparent
                                            : const Color(0xff19183e),
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: const Color(0xff19183e),
                                      )),
                                ),
                                maxSuggestionsInViewPort: 5,
                                suggestionsDecoration: null,
                                itemHeight: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                              width: 10,
                            ),
                            SearchField(
                              controller: distributor_name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select distributor name';
                                }
                                return null;
                              },
                              suggestions: districts_
                                  .map((String) => SearchFieldListItem(String))
                                  .toList(),
                              suggestionState: Suggestion.expand,
                              textInputAction: TextInputAction.next,
                              hasOverlay: false,
                              searchStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.8),
                              ),
                              searchInputDecoration: InputDecoration(
                                hintText: 'Select Distributor name',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 16.0,
                                  color:
                                      const Color(0xFF151624).withOpacity(0.5),
                                ),
                                filled: true,
                                fillColor: distributor_name.text.isEmpty
                                    ? const Color.fromRGBO(248, 247, 251, 1)
                                    : Colors.transparent,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: distributor_name.text.isEmpty
                                          ? Colors.transparent
                                          : const Color(0xff19183e),
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: const Color(0xff19183e),
                                    )),
                              ),
                              maxSuggestionsInViewPort: 5,
                              suggestionsDecoration: null,
                              itemHeight: 40,
                            ),
                            const SizedBox(
                              height: 10,
                              width: 10,
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
                              decoration: InputDecoration(
                                hintText: 'Delivery Date',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 16.0,
                                  color:
                                      const Color(0xFF151624).withOpacity(0.5),
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
                                          : const Color(0xff19183e),
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: const Color(0xff19183e),
                                    )),
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
                            AnimatedButton(
                              text: 'Submit',
                              color: Color.fromARGB(255, 49, 47, 92),
                              pressEvent: () {
                                if (sales_order_key.currentState!.validate()) {
                                  sales_order(
                                      customer_name.text,
                                      delivery_date.text,
                                      values_dict,
                                      distributor_name.text,
                                      username);
                                  Navigator.pop(context);
                                  customer_name.clear();
                                  district_list_text.clear();
                                  distributor_name.clear();
                                  delivery_date.clear();
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

  Future dealername_list() async {
    dealer_name = [];

    var response = await http.get(Uri.parse(
        """${dotenv.env['API_URL']}/api/method/oxo.custom.api.customer_list"""));
    // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          dealer_name.add((json.decode(response.body)['message'][i]));
        }
      });
    }
  }

  Future distributor_list(list) async {
    print("object");
    districts_ = [];
    print(list);
    var response = await http.get(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.sales_partner?area=${list}"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    print(
        """${dotenv.env['API_URL']}/api/method/oxo.custom.api.sales_partner?area=${list}""");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        for (var i = 0;
            i < json.decode(response.body)['messege_1'].length;
            i++) {
          print((json.decode(response.body)['messege_1'][i]));
          districts_.add((json.decode(response.body)['messege_1'][i]));
          // distributor.add((json.decode(response.body)['message'][i]));
        }
        print(districts_);
        print(districts_.length);
      });
    }
  }

  Future district_list() async {
    print("object");
    districts_list = [];
    SharedPreferences token = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.parse(
            """${dotenv.env['API_URL']}/api/method/oxo.custom.api.district_list"""),
        headers: {"Authorization": token.getString("token") ?? ""});

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        for (var i = 0;
            i < json.decode(response.body)['district'].length;
            i++) {
          // print((json.decode(response.body)['messege'][i]));
          districts_list.add((json.decode(response.body)['district'][i]));
        }
      });
    }
  }

  Future sales_order(
      customerName, deliveryDate, valuesDict, distributorName, username) async {
    print("object");
    print(user_name);
    print(valuesDict);
    valuesDict = jsonEncode(valuesDict);
    print(valuesDict);
    var response = await http.get(Uri.parse(
        """${dotenv.env['API_URL']}/api/method/oxo.custom.api.sales_order?cus_name=${customerName}&due_date=${deliveryDate}&items=${valuesDict}&distributor=${distributorName}&sales_person=${username}"""));
    print(response.statusCode);
    print(
        """${dotenv.env['API_URL']}/api/method/oxo.custom.api.sales_order?cus_name=${customerName}&due_date=${deliveryDate}&items=${valuesDict}&distributor=${distributorName}&sales_person=${username}""");
    print(response.body);
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

            print(valuesDict);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const home_page()));
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {},
        ).show();
      });
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
          print(valuesDict);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => home_page()),
          );
        },
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {},
      ).show();
    }
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List employeeData}) {
    print('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm');
    print(employeeData);
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(
                  columnName: 'name', value: e['item_name'].toString()),
              DataGridCell<String>(
                  columnName: 'qty', value: e['qty'].toString()),
            ]))
        .toList();
    print('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm');
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
