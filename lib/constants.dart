import 'package:flutter/material.dart';
import 'package:oxo/screens/sales/sales_order.dart';

TextEditingController mobilenumcontroller = TextEditingController();
TextEditingController passController = TextEditingController();
GlobalKey<FormState> formkey_mobile = GlobalKey<FormState>();
GlobalKey<FormState> formkey_pass = GlobalKey<FormState>();
var user_name;

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
 List varient_item_list=[];


var list = <TextEditingController>[];


var item;
// submit
GlobalKey<FormState> formkey_salesorder = GlobalKey<FormState>();
TextEditingController name = TextEditingController();
List dealer_name=[];
List distributor=[];

// dealer

List territory=[];
List state=[];
TextEditingController dealername = TextEditingController();
TextEditingController dealermobile = TextEditingController();
TextEditingController dealeraddress = TextEditingController();
TextEditingController dealerterritory = TextEditingController();
TextEditingController dealercity = TextEditingController();
TextEditingController dealerstate = TextEditingController();
TextEditingController dealerpincode = TextEditingController();
GlobalKey<FormState> address_key = GlobalKey<FormState>();
GlobalKey<FormState> mobile_key = GlobalKey<FormState>();
GlobalKey<FormState> name_key = GlobalKey<FormState>();

