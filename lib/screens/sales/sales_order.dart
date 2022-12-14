import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/constants.dart';
import 'package:oxo/screens/sales/order.dart';
import 'package:searchfield/searchfield.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'item_form.dart';

class sales_order extends StatefulWidget {
  const sales_order({super.key});

  @override
  State<sales_order> createState() => _sales_orderState();
}

class _sales_orderState extends State<sales_order> {
  @override
  void initState() {
    super.initState();

    employeeDataSource = EmployeeDataSource(employeeData: values_dict);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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

  // Widget customer_details(Size size) {
  //   return Container(
  //     child: Column(
  //       children: [
  //         SizedBox(
  //           height: size.height * 0.02,
  //         ),
  //         customername(size),
  //         SizedBox(
  //           height: size.height * 0.02,
  //         ),
  //         deliverydate(size),

  //       ],
  //     ),
  //   );
  // }

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

  Widget customername(Size size) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: SizedBox(
            height: size.height,
            child: Row(children: [
              Expanded(
                  child: SearchField(
                controller: customer_name,
                suggestions: cus_name
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
                  hintText: 'Select customer name',
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
              )),
              SizedBox(
                width: 10,
                height: 10,
              ),
            ])));
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
                          MaterialPageRoute(builder: (context) => order()),
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
                        padding:  EdgeInsets.only(left:8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => order()),
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
                        padding:  EdgeInsets.only(right:8.0),
        
            child:  AnimatedButton(
                  text: 'Submit',
                  color: Color.fromRGBO(44, 185, 176, 1),
                  
                  pressEvent: () {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.leftSlide,
                      headerAnimationLoop: false,
                      dialogType: DialogType.success,
                      title: 'Order Submited Sucessfully',
                      btnOkOnPress: () {
                        Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => order()),
                            );
                      },
                      btnOkIcon: Icons.check_circle,
                      onDismissCallback: (type) {
                        
                      },
                    ).show();
                  },
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
                          ))),
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


}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'name', value: e['name'].toString()),
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
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
