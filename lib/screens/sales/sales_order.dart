import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/constants.dart';
import 'package:searchfield/searchfield.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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
              height: size.height,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    // bottom: 20.0,
                    child: Column(
                      children: <Widget>[
                        customer_details(size),
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

  Widget customer_details(Size size) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.02,
          ),
          customername(size),
          SizedBox(
            height: size.height * 0.02,
          ),
          deliverydate(size),
          SizedBox(
            height: size.height * 0.02,
          ),
        ],
      ),
    );
  }

    Widget item(Size size) {
    return Container(
      child: Column(
        children: [
          itemtable(size),
          SizedBox(
            height: size.height * 0.02,
          ),
          addbutton(size),
          SizedBox(
            height: size.height * 0.02,
          ),
        ],
      ),
    );
  }

  Widget customername(Size size) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: SizedBox(
            // height: size.height / 10,
            child: Row(children: [
          Expanded(
              child: SearchField(
            controller: customer_name,
            suggestions:
                cus_name.map((String) => SearchFieldListItem(String)).toList(),
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
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          height: size.height /5,
          child: SfDataGrid(
            source: employeeDataSource,

            startSwipeActionsBuilder:
                (BuildContext context, DataGridRow row, int rowIndex) {
              return GestureDetector(
                  onTap: () {},
                  child: Container(
                      color: Colors.greenAccent,
                      child: Center(
                        child: Icon(Icons.add),
                      )));
            },
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

            allowSwiping: true,
            isScrollbarAlwaysShown: true,
            // swipeMaxOffset: 100.0,
            // columnWidthMode: ColumnWidthMode.fill,
            columns: <GridColumn>[
              GridColumn(
                  columnName: 'id',
                  label: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'ID',
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'name',
                  label: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Name',
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'designation',
                  label: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Designation',
                        overflow: TextOverflow.ellipsis,
                      ))),
            ],
          ),
        ));
  }

  Widget addbutton(Size size) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
            height: size.height / 12,
            child: Center(
                child: TextButton(
              child: Text(
                'Add',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => form_child_table()),
                );
              },
            ))));
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'id', value: e['ID'].toString()),
              DataGridCell<String>(
                  columnName: 'name', value: e['Name'].toString()),
              DataGridCell<String>(
                  columnName: 'designation',
                  value: e['Designation'].toString()),
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
