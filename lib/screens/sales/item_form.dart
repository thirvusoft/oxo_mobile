import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/screens/sales/sales_order.dart';

import '../../constants.dart';

class form_child_table extends StatefulWidget {
  const form_child_table({super.key});

  @override
  State<form_child_table> createState() => _form_child_tableState();
}

var test1 = TextEditingController();
var test2 = TextEditingController();
var test3 = TextEditingController();
var test4 = TextEditingController();

class _form_child_tableState extends State<form_child_table> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form')),
      body: Column(children: [
        SizedBox(
          height: 10,
        ),
        Container(
          child: Padding(
              padding: EdgeInsets.only(right: 30, left: 30),
              child: TextFormField(
                controller: test1,
                keyboardType:TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'ID',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3),
                  ),
                ),
              )),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Padding(
              padding: EdgeInsets.only(right: 30, left: 30),
              child: TextFormField(
                controller: test2,
                 
                decoration: InputDecoration(
                  hintText: 'Name',
                 
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3),
                  ),
                ),
              )),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Padding(
              padding: EdgeInsets.only(right: 30, left: 30),
              child: TextFormField(
                controller: test3,
                decoration: InputDecoration(
                  hintText: 'Designation',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3),
                  ),
                ),
              )),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Padding(
              padding: EdgeInsets.only(right: 30, left: 30),
              child: TextFormField(
                controller: test4,
                keyboardType:TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Salary',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3),
                  ),
                ),
              )),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () {
              // employees.add(
              //   Employee((int.parse(test1.text)), test2.text, test3.text,
              //       (int.parse(test4.text))),
              // );
                     Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => sales_order()),
                );
              values_dict.add({
                'ID':test1.text,'Name':test2.text,'Designation':test3.text,'Salary':test4.text
              });
              print('111111111111111111111111111111');
              print(values_dict);

            },
            child: Text("Add"))
      ]),
    );
  }
}