import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:oxo/screens/add_dealer.dart/dealer.dart';
import 'package:oxo/screens/sales/order.dart';
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

List cus_name = ['Barath', 'Ram', 'vig'];

// child table

late EmployeeDataSource employeeDataSource;
List dataGridRows = [];

var values = {};
List values_dict = [];

// order page
List item_list_mens = [];
List item_list_womens = [];
List item_list_kids = [];
List item_list_premimum = [];
List varient_item_list = [];
List item_search_list_men = [];
List item_search_list_women = [];
List item_search_list_kid = [];
List item_search_list_premimum = [];

List icon_nameOnSearch_men = [];
List icon_nameOnSearch_women = [];

List icon_nameOnSearch_kids = [];

List icon_nameOnSearch_premimum = [];
// List search=[];
//  var all_template_search=item_list_mens+item_list_womens+item_list_kids+item_list_premimum;
TextEditingController searchcontroller_men = TextEditingController();
TextEditingController searchcontroller_women = TextEditingController();
TextEditingController searchcontroller_kids = TextEditingController();

TextEditingController searchcontroller_premimum = TextEditingController();

var list = <TextEditingController>[];

var item;
TextEditingController searchcontroller_varient = TextEditingController();
List icon_nameOnSearch_varient = [];
List item_search_list_varient = [];

// submit
GlobalKey<FormState> formkey_salesorder = GlobalKey<FormState>();
TextEditingController name = TextEditingController();
List dealer_name = [];
List distributor = [];
List row_varient = [];

// dealer

List territory = [];
List state = [];
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
TextEditingController status_search = TextEditingController();
List icon_nameOnSearch_status=[];
List item_search_list_status =[];
List sales_order_status=[];


TextEditingController customer_name_home_page = TextEditingController();
List distributor_home=[];
var distributorname;
