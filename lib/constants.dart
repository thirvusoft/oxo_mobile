import 'package:flutter/material.dart';
import 'package:oxo/screens/sales/sales_order.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passController = TextEditingController();
GlobalKey<FormState> formkey_mobile = GlobalKey<FormState>();
GlobalKey<FormState> formkey_pass = GlobalKey<FormState>();


// sales order

GlobalKey<FormState> formkey_customer_name = GlobalKey<FormState>();
GlobalKey<FormState> formkey_delivery_date = GlobalKey<FormState>();

TextEditingController customer_name = TextEditingController();
TextEditingController delivery_date = TextEditingController();

List cus_name=['Barath','Ram','vig'];


// child table

  late EmployeeDataSource employeeDataSource;
  List dataGridRows = [];

  var values={};
  List values_dict=[];
  


  // order page
  List item_list=[];
  

var list = <TextEditingController>[];