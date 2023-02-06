// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:dio/dio.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:oxo/constants.dart';
// import 'package:searchfield/searchfield.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../sales/home_page.dart';
// import 'package:path_provider/path_provider.dart';

// class dealer_creation extends StatefulWidget {
//   const dealer_creation({super.key});

//   @override
//   State<dealer_creation> createState() => _dealer_creationState();
// }

// class _dealer_creationState extends State<dealer_creation> {
//   @override
//   File? _image;
//   late File imageFile;
//   final ImagePicker _picker = ImagePicker();
//   var currentAddress;
//   GlobalKey<FormState> dealer_form = GlobalKey<FormState>();
//   FocusNode mobilenumber_ = FocusNode();
//   FocusNode dealername_ = FocusNode();
//   FocusNode doornumber_ = FocusNode();
//   FocusNode street_ = FocusNode();
//   FocusNode district_ = FocusNode();
//   FocusNode state_ = FocusNode();
//   FocusNode pincode_ = FocusNode();
//   FocusNode maunalpincode_ = FocusNode();
//   bool showbtn = false;
//   void initState() {
//     territory_list();
//     _getCurrentLocation();
//     district_list();
//     mobilenumber_ = FocusNode();
//     dealername_ = FocusNode();
//     doornumber_ = FocusNode();
//     street_ = FocusNode();
//     district_ = FocusNode();
//     state_ = FocusNode();
//     pincode_ = FocusNode();
//     super.initState();
//   }

//   void dispose() {
//     // Clean up the focus node when the Form is disposed.
//     mobilenumber_.dispose();
//     dealername_.dispose();
//     doornumber_.dispose();
//     street_.dispose();
//     district_.dispose();
//     state_.dispose();
//     pincode_.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         backgroundColor: const Color(0xffEB455F),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const home_page()),
//             );
//           },
//           icon: const Icon(Icons.arrow_back_outlined),
//         ),
//         // backgroundColor: const Color(0xFFEB455F),
//         title: Text(
//           'Dealer Creation',
//           style: GoogleFonts.poppins(
//             textStyle: const TextStyle(
//                 fontSize: 20, letterSpacing: .2, color: Colors.white),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           child: Form(
//               key: dealer_form,
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       onChanged: ((value) {
//                         if (dealername.text.isNotEmpty) {
//                           setState(() {
//                             name_bool = true;
//                           });
//                         } else {
//                           setState(() {
//                             name_bool = false;
//                           });
//                         }
//                       }),
//                       // focusNode: dealername_,
//                       // textCapitalization: TextCapitalization.characters,
//                       controller: dealername,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           // dealername_.requestFocus();

//                           return 'Please enter dealer name';
//                         }
//                         return null;
//                       },
//                       decoration: InputDecoration(
//                           suffixIcon: name_bool
//                               ? IconButton(
//                                   icon: const Icon(
//                                     PhosphorIcons.x_fill,
//                                   ),
//                                   onPressed: () {
//                                     dealername.clear();
//                                     setState(() {
//                                       name_bool = false;
//                                     });
//                                   },
//                                 )
//                               : null,
//                           enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                               width: 1,
//                               color: Color(0xff787878),
//                             ),
//                           ),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Color(0xFFEB455F), width: 1.0),
//                           ),
//                           labelText: "Dealer Name",
//                           hintText: "Enter dealer name"),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     SizedBox(
//                         child: TextFormField(
//                       controller: dealermobile,
//                       maxLength: 10,
//                       keyboardType: TextInputType.number,
//                       focusNode: mobilenumber_,
//                       validator: (value) {
//                         if (value!.isEmpty ||
//                             !RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(value)) {
//                           mobilenumber_.requestFocus();
//                           return 'Please enter a valid mobile number.';
//                         }
//                         return null;
//                       },
//                       decoration: const InputDecoration(
//                           enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                               width: 1,
//                               color: Color(0xff787878),
//                             ),
//                           ),
//                           // counterText: "",
//                           // border: OutlineInputBorder(),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Color(0xFFEB455F), width: 1.0),
//                           ),
//                           labelText: "Mobile Number",
//                           hintText: "Enter dealer mobile number"),
//                     )),

//                     const Text(
//                       "Add Dealer Address",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: Color(0xFF2B3467)),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     TextFormField(
//                       textCapitalization: TextCapitalization.characters,
//                       controller: dealerdoorno,
//                       focusNode: doornumber_,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           doornumber_.requestFocus();
//                           return 'Please enter doorno';
//                         }
//                         return null;
//                       },
//                       decoration: const InputDecoration(
//                           // border: OutlineInputBorder(),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Color(0xFFEB455F), width: 1.0),
//                           ),
//                           labelText: "Door no",
//                           hintText: "Enter door no"),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                         child: TextFormField(
//                       textCapitalization: TextCapitalization.characters,
//                       controller: dealercity,
//                       focusNode: street_,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           street_.requestFocus();
//                           return 'Please enter street';
//                         }
//                         return null;
//                       },
//                       decoration: const InputDecoration(
//                           // border: OutlineInputBorder(),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Color(0xFFEB455F), width: 1.0),
//                           ),
//                           labelText: "Street",
//                           hintText: "Enter street"),
//                     )),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       child: SearchField(
//                         controller: dealerarea,
//                         validator: (value) {
//                           // if (value!.isEmpty) {
//                           //   setState(() {
//                           //     isVisible = true;
//                           //   });
//                           // }
//                           if (value!.isNotEmpty) {
//                             if (area_list.contains(dealerarea.text)) {
//                               return null;
//                             } else {
//                               return "Area not in the list";
//                             }
//                           }
//                         },
//                         suggestions: area_list
//                             .map(
//                               (String) => SearchFieldListItem(String,
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 10.0),
//                                     child: Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: Text(
//                                         String,
//                                         style: const TextStyle(
//                                             color: Colors.black),
//                                       ),
//                                     ),
//                                   )),
//                             )
//                             .toList(),
//                         // suggestionState: Suggestion.expand,

//                         onSuggestionTap: (x) {
//                           FocusScope.of(context).unfocus();

//                           for (int i = 0; i < territory.length; i++) {
//                             if (territory[i].contains(dealerarea.text)) {
//                               setState(() {
//                                 districts.text = territory[i][1];
//                                 dealerstate.text = territory[i][2];
//                               });
//                             }
//                           }
//                           postal_code(dealerarea.text, districts.text,
//                               dealerstate.text);
//                         },
//                         textInputAction: TextInputAction.next,
//                         hasOverlay: false,
//                         searchStyle: TextStyle(
//                           fontSize: 15,
//                           color: Colors.black.withOpacity(0.8),
//                         ),
//                         marginColor: Colors.white,
//                         emptyWidget: const Text(
//                           "Area not found",
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.red,
//                           ),
//                         ),
//                         searchInputDecoration: const InputDecoration(
//                             // border: OutlineInputBorder(),
//                             focusedBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Color(0xFFEB455F), width: 1.0),
//                             ),
//                             labelText: "Area",
//                             hintText: "Select Area"),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     // TextFormField(
//                     //   controller: districts,
//                     //   decoration: const InputDecoration(
//                     //       border: OutlineInputBorder(),
//                     //       focusedBorder: UnderlineInputBorder(
//                     //
//                     //         borderSide:
//                     //             BorderSide(color: Color(0xFFEB455F), width: 2.0),
//                     //       ),
//                     //       hintText: " District"),
//                     // ),

//                     SearchField(
//                       controller: districts,
//                       focusNode: district_,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           district_.requestFocus();
//                           return 'Please select district';
//                         }
//                         return null;
//                       },
//                       suggestions: district_lists
//                           .map(
//                             (String) => SearchFieldListItem(String,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 10.0),
//                                   child: Align(
//                                     alignment: Alignment.centerLeft,
//                                     child: Text(
//                                       String,
//                                       style:
//                                           const TextStyle(color: Colors.black),
//                                     ),
//                                   ),
//                                 )),
//                           )
//                           .toList(),
//                       suggestionState: Suggestion.expand,
//                       onSuggestionTap: (x) {},
//                       marginColor: Colors.white,
//                       emptyWidget: const Text(
//                         "District not found",
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.red,
//                         ),
//                       ),
//                       textInputAction: TextInputAction.next,
//                       hasOverlay: false,
//                       searchStyle: TextStyle(
//                         fontSize: 15,
//                         color: Colors.black.withOpacity(0.8),
//                       ),
//                       searchInputDecoration: const InputDecoration(
//                           // border: OutlineInputBorder(),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Color(0xFFEB455F), width: 1.0),
//                           ),
//                           labelText: "District",
//                           hintText: "Select District"),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     SearchField(
//                       controller: dealerstate,
//                       focusNode: state_,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           state_.requestFocus();
//                           return 'Please select State';
//                         }
//                         return null;
//                       },
//                       suggestions: state
//                           .map(
//                             (String) => SearchFieldListItem(String,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 10.0),
//                                   child: Align(
//                                     alignment: Alignment.centerLeft,
//                                     child: Text(
//                                       String,
//                                       style:
//                                           const TextStyle(color: Colors.black),
//                                     ),
//                                   ),
//                                 )),
//                           )
//                           .toList(),
//                       // suggestions: state
//                       //     .map((String) => SearchFieldListItem(String))
//                       //     .toList(),
//                       suggestionState: Suggestion.expand,
//                       textInputAction: TextInputAction.next,
//                       hasOverlay: false,
//                       marginColor: Colors.white,
//                       emptyWidget: const Text(
//                         "State not found",
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.red,
//                         ),
//                       ),
//                       searchStyle: TextStyle(
//                         fontSize: 15,
//                         color: Colors.black.withOpacity(0.8),
//                       ),
//                       searchInputDecoration: const InputDecoration(
//                           // border: OutlineInputBorder(),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Color(0xFFEB455F), width: 1.0),
//                           ),
//                           hintText: "State"),
//                     ),

//                     const SizedBox(
//                       height: 20,
//                     ),
//                     TextFormField(
//                       // readOnly: true,
//                       focusNode: pincode_,
//                       controller: pincode_text,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                           // border: OutlineInputBorder(),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Color(0xFFEB455F), width: 1.0),
//                           ),
//                           labelText: "Pincode",
//                           hintText: "Pincode"),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Visibility(
//                       visible: isVisible,
//                       child: TextFormField(
//                         controller: Manualdata_,
//                         decoration: const InputDecoration(
//                             // border: OutlineInputBorder(),
//                             focusedBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Color(0xFFEB455F), width: 1.0),
//                             ),
//                             labelText: " Area / Pincode",
//                             hintText: " Area / Pincode "),
//                       ),
//                     ),
//                     // Container(
//                     //     child: SearchField(
//                     //   controller: dealerstate,
//                     //   validator: (value) {
//                     //     if (value == null || value.isEmpty) {
//                     //       return 'Please Select state';
//                     //     }
//                     //     return null;
//                     //   },
//                     //   onSuggestionTap: (x) async {
//                     //     FocusScope.of(context).unfocus();
//                     //   },
//                     //   suggestions: state
//                     //       .map((String) => SearchFieldListItem(String))
//                     //       .toList(),
//                     //   suggestionState: Suggestion.expand,
//                     //   textInputAction: TextInputAction.next,
//                     //   hasOverlay: false,
//                     //   searchStyle: TextStyle(
//                     //     fontSize: 15,
//                     //     color: Colors.black.withOpacity(0.8),
//                     //   ),
//                     //   searchInputDecoration: const InputDecoration(
//                     //       border: OutlineInputBorder(),
//                     //       focusedBorder: UnderlineInputBorder(
//                     //
//                     //         borderSide:
//                     //             BorderSide(color: Color(0xFFEB455F), width: 2.0),
//                     //       ),
//                     //       hintText: "Select State"),
//                     // )),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     (image_temp)
//                         ? DottedBorder(
//                             borderType: BorderType.RRect,
//                             radius: const Radius.circular(12),
//                             color: const Color(0xFF2B3467),
//                             strokeWidth: 2,
//                             strokeCap: StrokeCap.round,
//                             dashPattern: const [
//                               5,
//                               5,
//                               5,
//                             ],
//                             child: ClipRRect(
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(11)),
//                               child: GestureDetector(
//                                   onTap: () {
//                                     showModalBottomSheet(
//                                       context: context,
//                                       builder: ((builder) => bottomSheet()),
//                                     );
//                                   },
//                                   child: Container(
//                                       width: 333,
//                                       height: 75,
//                                       color: const Color(0xffe8effc),
//                                       child: Column(
//                                         children: const [
//                                           SizedBox(
//                                             height: 10,
//                                           ),
//                                           Icon(
//                                             PhosphorIcons.cloud_arrow_up_light,
//                                             color: Color(0xFF2B3467),
//                                             size: 30,
//                                           ),
//                                           Text("Click to upload")
//                                         ],
//                                       ))),
//                             ))
//                         : Column(
//                             children: [
//                               const Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: Text("Selected File",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w400,
//                                           letterSpacing: .2,
//                                           fontSize: 18,
//                                           color: Color(0xff818cca)))),
//                               Card(
//                                   elevation: 4,
//                                   color: const Color(0xffe8effc),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       ListTile(
//                                         leading: Image.file(_image!),
//                                         title: Text(pathttt),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       Container(
//                                           margin: const EdgeInsets.symmetric(
//                                               vertical: 5),
//                                           width: 325,
//                                           // height: 20,
//                                           child: ClipRRect(
//                                               borderRadius:
//                                                   const BorderRadius.all(
//                                                       Radius.circular(10)),
//                                               child: LinearProgressIndicator(
//                                                 backgroundColor:
//                                                     const Color(0xffe8effc),
//                                                 color: const Color(0xFF2B3467),
//                                                 value: value,
//                                                 minHeight: 7,
//                                               )))
//                                     ],
//                                   )),
//                             ],
//                           ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: AnimatedButton(
//                           text: 'Submit',
//                           color: const Color(0xFFEB455F),
//                           pressEvent: () {
//                             FocusScope.of(context).requestFocus(FocusNode());
//                             if (dealer_form.currentState!.validate()) {
//                               _getCurrentLocation();
//                               customer_creation(
//                                 dealername.text,
//                                 dealermobile.text,
//                                 dealerdoorno.text,
//                                 dealercity.text,
//                                 dealerarea.text,
//                                 dealerstate.text,
//                                 districts.text,
//                                 pincode_text.text,
//                                 Manualdata_.text,
//                               );
//                             }
//                           }),
//                     ),
//                   ],
//                 ),
//               )),
//         ),
//       ),
//     );
//   }

//   Future customer_creation(
//     fullName,
//     phoneNumber,
//     dealerdoorno,
//     dealercity,
//     tity,
//     state,
//     districts,
//     pincode,
//     manualCode,
//   ) async {
//     SharedPreferences token = await SharedPreferences.getInstance();
//     setState(() {
//       username = token.getString('full_name');
//     });

//     var response = await http.get(
//         Uri.parse(
//             """${dotenv.env['API_URL']}/api/method/oxo.custom.api.new_customer?&full_name=${fullName}&phone_number=${phoneNumber}&doorno=${dealerdoorno}&address=${dealercity}&districts=${districts}&territory=${tity}&state=${state}&latitude=${current_position!.latitude}&longitude=${current_position!.longitude}&auto_pincode=${auto_pincode}&Manual_Data=${manualCode}&user=${username}&pincode=${pincode}"""),
//         headers: {"Authorization": token.getString("token") ?? ""});

//     if (response.statusCode == 200) {
//       celar_text();
//       var docName = json.decode(response.body)['customer'];
//       setState(() {
//         AwesomeDialog(
//           context: context,
//           animType: AnimType.leftSlide,
//           headerAnimationLoop: false,
//           dialogType: DialogType.success,
//           title: (json.decode(response.body)['message']),
//           btnOkOnPress: () {
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) => const home_page()));
//           },
//           btnOkIcon: Icons.check_circle,
//           onDismissCallback: (type) {},
//         ).show();
//         if (pathttt.isNotEmpty) {
//           uploadimage(imageFile, docName);
//         }
//       });
//     } else {
//       Fluttertoast.showToast(
//           msg: (json.decode(response.body)['message']),
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 2,
//           backgroundColor: const Color.fromARGB(255, 234, 10, 10),
//           textColor: Colors.white,
//           fontSize: 16.0);
//     }
//   }

//   celar_text() {
//     districts.clear();
//     dealername.clear();
//     dealermobile.clear();
//     dealerdoorno.clear();
//     dealercity.clear();
//     dealerstate.clear();
//     dealerarea.clear();
//     dealerpincode.clear();
//     pincode_text.clear();
//     Manualdata_.clear();
//   }

// // /api/method/frappe.client.get_list?

//   Future territory_list() async {
//     territory = [];
//     area_list = [];

//     var response = await http.get(Uri.parse(
//         """${dotenv.env['API_URL']}/api/method/oxo.custom.api.territory"""));

//     if (response.statusCode == 200) {
//       await Future.delayed(const Duration(milliseconds: 500));
//       setState(() {
//         for (var i = 0; i < json.decode(response.body)['messege'].length; i++) {
//           area_list.add((json.decode(response.body)['messege'][i][0]));
//           territory.add((json.decode(response.body)['messege'][i]));
//         }
//       });
//     }
//   }

//   // Future state_list() async {
//   //   state = [];

//   //   var response = await http.get(Uri.parse(
//   //       """${dotenv.env['API_URL']}/api/method/oxo.custom.api.state"""));

//   //   if (response.statusCode == 200) {
//   //     await Future.delayed(const Duration(milliseconds: 500));
//   //     setState(() {
//   //       for (var i = 0; i < json.decode(response.body)['message'].length; i++) {
//   //         state.add((json.decode(response.body)['message'][i]));
//   //       }
//   //     });
//   //   }
//   // }

//   Position? _position;
//   void _getCurrentLocation() async {
//     Position position = await _determinePosition();
//     _getAddressFromLatLng(position);
//     setState(() {
//       _position = position;
//       current_position = _position!;
//     });
//   }

//   Future<Position> _determinePosition() async {
//     LocationPermission permission;
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     return await Geolocator.getCurrentPosition();
//   }

//   Future<void> _getAddressFromLatLng(Position position) async {
//     await placemarkFromCoordinates(position.latitude, position.longitude)
//         .then((List<Placemark> placemarks) {
//       Placemark place = placemarks[0];
//       setState(() {
//         currentAddress =
//             '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';

//         auto_pincode = ' ${place.postalCode}';
//       });
//     }).catchError((e) {
//       debugPrint(e);
//     });
//   }

//   Widget bottomSheet() {
//     return Container(
//       height: 150.0,
//       width: MediaQuery.of(context).size.width,
//       margin: const EdgeInsets.symmetric(
//         horizontal: 20,
//         vertical: 20,
//       ),
//       child: Column(
//         children: <Widget>[
//           const Text(
//             ("Choose the media"),
//             style: TextStyle(
//               fontSize: 20.0,
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//             ElevatedButton.icon(
//               icon: const Icon(
//                 PhosphorIcons.camera,
//               ),
//               onPressed: () {
//                 pickImage(ImageSource.camera);
//               },
//               label: const Text("Camera"),
//             ),
//             const SizedBox(
//               width: 12,
//             ),
//             ElevatedButton.icon(
//               icon: const Icon(PhosphorIcons.image),
//               onPressed: () {
//                 pickImage(ImageSource.gallery);
//               },
//               label: const Text("Gallery"),
//             ),
//           ])
//         ],
//       ),
//     );
//   }

//   Future pickImage(ImageSource source) async {
//     String dir;
//     String pdfName;

//     File file;

//     try {
//       final file = await ImagePicker()
//           .pickImage(source: source, maxWidth: 500, maxHeight: 500);

//       final paths = await getApplicationDocumentsDirectory();
//       if (file == null) return;
//       setState(() {
//         _image = File(file.path);

//         // print(File(file.path));
//         imageFile = File(file.path);
//         pathttt = imageFile.path.split("/").last;

//         image_temp = false;

//         // uploadimage(imageFile);
//       });
//       determinateIndicator();
//       // _cropImage(file.path);

//       Navigator.pop(context);
//     } on PlatformException catch (e) {
//       print('Failed to pick image: $e');
//     }
//   }

//   Future uploadimage(paths, docName) async {
//     final token = await SharedPreferences.getInstance();

//     var length = await paths.length();
//     Dio dio = new Dio();
//     try {
//       String filename = paths.path.split("/").last;

//       FormData formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(paths.path, filename: filename),
//         "docname": docName,
//         "doctype": 'Customer',
//         "attached_to_name": docName,
//         "is_private": 0,
//         // "attached_to_field": "user_image",
//         "folder": "Home/Attachments"
//       });

//       var dio = Dio();

//       dio.options.headers["Authorization"] =
//           token.getString('token').toString();

//       var response = await dio.post(
//         "https://oxo.thirvusoft.co.in/api/method/upload_file",
//         data: formData,
//       );
//       if (response.statusCode == 200) {
//         setState(() {
//           image_temp = true;
//           imageFile.delete();
//         });
//         print(imageFile.toString());
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future district_list() async {
//     district_lists = [];
//     state = [];
//     SharedPreferences token = await SharedPreferences.getInstance();
//     var response = await http.get(
//         Uri.parse(
//             """${dotenv.env['API_URL']}/api/method/oxo.custom.api.district_list"""),
//         headers: {"Authorization": token.getString("token") ?? ""});

//     if (response.statusCode == 200) {
//       setState(() {
//         for (var i = 0;
//             i < json.decode(response.body)['district'].length;
//             i++) {
//           district_lists.add((json.decode(response.body)['district'][i]));
//         }
//         for (var i = 0; i < json.decode(response.body)['state'].length; i++) {
//           state.add((json.decode(response.body)['state'][i]));
//         }
//       });
//     }
//   }

//   Future postal_code(String area, String dis, String state) async {
//     var response = await http
//         .get(Uri.parse("https://api.postalpincode.in/postoffice/$area"));

//     if (response.statusCode == 200) {
//       for (var i = 0; i < json.decode(response.body).length; i++) {
//         pincode_list = (json.decode(response.body)[i]["PostOffice"]);
//         for (var j = 0; j < pincode_list.length; j++) {
//           if (pincode_list[j]["District"].contains(dis) &&
//               pincode_list[j]["State"].contains(state)) {
//             setState(() {
//               pincode_text.text = pincode_list[j]["Pincode"];
//             });
//           }
//         }
//       }
//     }
//   }

//   void determinateIndicator() {
//     Timer.periodic(const Duration(seconds: 1), (Timer timer) {
//       setState(() {
//         if (value == 1) {
//           timer.cancel();
//         } else {
//           value = value + 0.3;
//         }
//       });
//     });
//   }
// }
