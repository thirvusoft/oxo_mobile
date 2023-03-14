import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'screens/Sales Order/sales_order.dart';

TextEditingController mobilenumcontroller = TextEditingController();
TextEditingController passController = TextEditingController();
GlobalKey<FormState> formkey_mobile = GlobalKey<FormState>();
GlobalKey<FormState> formkey_pass = GlobalKey<FormState>();
var user_name;

// sales order

GlobalKey<FormState> sales_order_key = GlobalKey<FormState>();

TextEditingController customer_name = TextEditingController();
TextEditingController delivery_date = TextEditingController();
TextEditingController distributor_name = TextEditingController();

List cus_name = ['Barath', 'Ram', 'vig'];
List order_lists = [];

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
List arealist_ = [];
List state = [];
TextEditingController dealertype = TextEditingController();

TextEditingController dealername = TextEditingController();
TextEditingController dealermobile = TextEditingController();
TextEditingController dealeraddress = TextEditingController();
TextEditingController dealerterritory = TextEditingController();
TextEditingController dealerarea = TextEditingController();
TextEditingController dealercity = TextEditingController();
TextEditingController dealerstate = TextEditingController();
TextEditingController dealerpincode = TextEditingController();
TextEditingController dealerdoorno = TextEditingController();
TextEditingController Landline = TextEditingController();

GlobalKey<FormState> delear_type = GlobalKey<FormState>();

List deleartype = ["NEW DEALER", "EXISTING DEALER"];

TextEditingController status_search = TextEditingController();
List icon_nameOnSearch_status = [];
List item_search_list_status = [];
List sales_order_status = [];

TextEditingController customer_name_home_page = TextEditingController();
List distributor_home = [];
var distributorname;
List location = [];
Position? current_position;
bool status = true;

List customer_list = [];
List icon_nameOnSearch_customer = [];
List item_search_list_customer = [];
TextEditingController customer_search = TextEditingController();

List notification_list = [];

TextEditingController appointment_delear_name = TextEditingController();
TextEditingController typecontroller = TextEditingController();
GlobalKey<FormState> appointment_name_key = GlobalKey<FormState>();
TextEditingController appointment_emailid = TextEditingController();

List<String> appointment_notification = [];
List<String> time_ = [];

List notify_appointment = [];

var address1;

Position? positions;
Position? position1;

var currentAddress;
var auto_pincode;

var index_value;

// category list page
List inner_list = [];
List outer_list = [];
List shirt_list = [];
TextEditingController searchcontroller_shirt = TextEditingController();
TextEditingController searchcontroller_inner = TextEditingController();
TextEditingController searchcontroller_outer = TextEditingController();
TextEditingController districts = TextEditingController();

List icon_nameOnSearch_inner = [];
List item_search_list_inner = [];

List icon_nameOnSearch_shirt = [];
List item_search_list_shirt = [];

List icon_nameOnSearch_outer = [];
List item_search_list_outer = [];

var category_name;
var item_group_name;
List category_item_list = [];

List icon_nameOnSearch_category = [];

List item_search_list_category = [];

// template page

TextEditingController searchcontroller_category = TextEditingController();
TextEditingController pincode_text = TextEditingController();

var item_name;
var item_name_list;

var day_status;
var username;

var total_qty = 0.0;

List appointment_notification_list = [];
List appointment_notification_lists = [];

var counter;
bool notifi = true;
List temps = [];
var tokens;
late PickedFile _imageFile;
var pathttt;

double value = 0;
bool image_temp = true;
List pincode_list = [];
List district_lists = [];
List districts_ = [];
List districts_list = [];
TextEditingController district_list_text = TextEditingController();
TextEditingController Manualdata_ = TextEditingController();
int i = 1;
var data1 = "";
var check;

bool isVisible = true;
bool name_bool = false;
FocusNode mobilenumber_ = FocusNode();
FocusNode dealername_ = FocusNode();
FocusNode doornumber_ = FocusNode();
FocusNode street_ = FocusNode();
FocusNode district_ = FocusNode();
FocusNode state_ = FocusNode();
FocusNode pincode_ = FocusNode();
FocusNode maunalpincode_ = FocusNode();
bool showbtn = false;
List areafinallist_ = [];
var role_ = "";
String dropdownValue = '';
bool visibilitytype = false;
bool visibilitdealer = false;
bool visibilitydistributorsales = false;
bool visibilitydistributor = false;
TextEditingController distributornameappoint = TextEditingController();
TextEditingController salesexcutivenameappoint = TextEditingController();

List type = ["Dealer", "Distributor"];

List mobilenumber = [];
bool newdealer = false;
bool existingdealer = false;
var singlenumber;
bool mobile_errortext = false;
List orderLists = [];
List dispatched = [];
bool launchAnimation = true;
var address;

List locations = [];
double km = 0.0;

var test;
