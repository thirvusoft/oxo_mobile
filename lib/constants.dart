import 'package:flutter/material.dart';
import 'package:oxo/screens/sales/sales_order.dart';

TextEditingController mobilenumcontroller = TextEditingController();
TextEditingController passController = TextEditingController();
GlobalKey<FormState> formkey_mobile = GlobalKey<FormState>();
GlobalKey<FormState> formkey_pass = GlobalKey<FormState>();


// sales order

GlobalKey<FormState> formkey_customer_name = GlobalKey<FormState>();


GlobalKey<FormState> formkey_delivery_date = GlobalKey<FormState>();

TextEditingController customer_name = TextEditingController();
TextEditingController delivery_date = TextEditingController();
TextEditingController distributor_name = TextEditingController();




List cus_name=['Barath','Ram','vig'];


// child table

  late EmployeeDataSource employeeDataSource;
  List dataGridRows = [];

  var values={};
  List values_dict=[];
  


  // order page
  List item_list_mens=[];
  List item_list_womens=[];
  List item_list_kids=[];
  List item_list_premimum=[];
  

var list = <TextEditingController>[];


var item;
// submit
GlobalKey<FormState> formkey_salesorder = GlobalKey<FormState>();
TextEditingController name = TextEditingController();
List dealer_name=["barath","ram",];