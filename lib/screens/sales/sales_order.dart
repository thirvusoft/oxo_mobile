import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/constants.dart';
import 'package:oxo/screens/sales/home_page.dart';
import 'package:oxo/screens/sales/order.dart';
import 'package:searchfield/searchfield.dart';
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
    distributor_list();
    super.initState();
    print(
        '00000000000000000000000000000000000000000000000000000000000000000000000000000');
    print(values_dict);
    employeeDataSource = EmployeeDataSource(employeeData: values_dict);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            // backgroundColor: Colors(O),
            title: Center(
              child: Text(
                'Sales Order',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 20, letterSpacing: .2, color: Colors.white),
                ),
              ),
            )),
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
                        item(size)
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
                        : const Color.fromRGBO(44, 185, 176, 1),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(44, 185, 176, 1),
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
    return
        // Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //     child:
        SizedBox(
            height: size.height * 0.9,
            child: SfDataGridTheme(
              data: SfDataGridThemeData(
                  headerColor: Color.fromARGB(255, 248, 255, 254)),

              child: SfDataGrid(
                source: employeeDataSource,
                startSwipeActionsBuilder:
                    (BuildContext context, DataGridRow row, int rowIndex) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => category_group()),
                        );
                      },
                      child: Container(
                          color: Color.fromRGBO(44, 185, 176, 1),
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
                          print( values_dict);
                          index_value=rowIndex;
                           values_dict.removeAt(index_value);
                           print(values_dict);
                         });

                      },
                      child: Container(
                          color: Colors.redAccent,
                          child: Center(
                            child: Icon(Icons.delete),
                          )));
                },
                footerHeight: 80.0,
                footer: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => category_group()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 15.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            primary: Color.fromRGBO(44, 185, 176, 1),
                          ),
                          icon: Icon(
                            Icons.add,
                            size: 24.0,
                          ),
                          label: Text('Add item'),
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
                            customer_creation();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 15.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            primary: Color.fromRGBO(44, 185, 176, 1),
                          ),
                          icon: Icon(
                            Icons.check,
                            size: 24.0,
                          ),
                          label: Text('Submit'),
                        ),
                      ),
                    ),
                  ],
                ),

                // Expanded(child:    ElevatedButton.icon(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => order()),
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     padding:
                //         EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10.0)),
                //     primary: Color.fromRGBO(44, 185, 176, 1),
                //   ),
                //   icon: Icon(
                //     Icons.add,
                //     size: 24.0,
                //   ),
                //   label: Text('Add item'),
                // ),),

                allowSwiping: true,
                isScrollbarAlwaysShown: true,
                columnWidthMode: ColumnWidthMode.fill,
                columns: <GridColumn>[
                  GridColumn(
                      columnName: 'name',
                      label: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'Item name',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))),
                  GridColumn(
                    columnName: 'qty',
                    label: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Quantity',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ),
                  // GridColumn(
                  //     columnName: 'rate',
                  //     label: Container(
                  //         padding: EdgeInsets.all(20.0),
                  //         child: Text(
                  //           '₹ / Item',
                  //           overflow: TextOverflow.ellipsis,
                  //           style: TextStyle(fontWeight: FontWeight.bold),
                  //         )))
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

  // Widget alert(Size size) {
  //   return Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
  //       child:
  //   );
  // }

  Future customer_creation() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Dealer Details'),
        actions: <Widget>[
          SearchField(
            controller: customer_name,
            suggestions: dealer_name
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
              hintText: 'Select Dealer name',
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
                        : const Color.fromRGBO(44, 185, 176, 1),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(44, 185, 176, 1),
                  )),
            ),
          ),
          SizedBox(
            height: 10,
            width: 10,
          ),
          SearchField(
            controller: distributor_name,
            suggestions: distributor
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
                color: const Color(0xFF151624).withOpacity(0.5),
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
                        : const Color.fromRGBO(44, 185, 176, 1),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(44, 185, 176, 1),
                  )),
            ),
          ),
          SizedBox(
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
                        : const Color.fromRGBO(44, 185, 176, 1),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(44, 185, 176, 1),
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
          SizedBox(
            height: 10,
          ),
          AnimatedButton(
            text: 'Submit',
            color: Color.fromRGBO(44, 185, 176, 1),
            pressEvent: () {
              sales_order(customer_name.text, delivery_date.text, values_dict,
                  distributor_name.text, user_name);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
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

  Future distributor_list() async {
    print("object");
    distributor = [];
    var response = await http.get(
      Uri.parse(
          """${dotenv.env['API_URL']}/api/method/oxo.custom.api.distributor"""),
      // headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
          distributor.add((json.decode(response.body)['message'][i]));
        }
      });
    }
  }

  Future sales_order(customer_name, delivery_date, values_dict,
      distributor_name, user_name) async {
    print("object");
    print(values_dict);
    values_dict = jsonEncode(values_dict);
    print(values_dict);
    var response = await http.get(
        Uri.parse(
            """${dotenv.env['API_URL']}/api/method/oxo.custom.api.sales_order?cus_name=${customer_name}&due_date=${delivery_date}&items=${values_dict}&distributor=${distributor_name}&sales_person=${user_name}"""));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          title: 'Orderd Sucessfully',
          btnOkOnPress: () {
            values_dict = [];
            values = {};

            print(values_dict);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => home_page()),
            );
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
          values_dict = [];
          values = {};
          print(values_dict);
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
                  columnName: 'name', value: e['item_code'].toString()),
              DataGridCell<String>(
                  columnName: 'qty', value: e['qty'].toString()),
              // DataGridCell<String>(
              //     columnName: 'rate', value: e['rate'].toString()),
            ]))
        .toList();
    print('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm');
  }

  List<DataGridRow>  _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
