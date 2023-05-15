import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';

import 'package:oxo/constants.dart';
import 'package:oxo/constants.dart';
import 'package:oxo/constants.dart';
import 'package:oxo/screens/Home%20Page/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:sqflite/sqflite.dart';
import '../../Widget /apiservice.dart';
import 'package:get/get.dart' as GET;

class dealer extends StatefulWidget {
  const dealer({super.key});

  @override
  State<dealer> createState() => _dealerState();
}

class _dealerState extends State<dealer> {
  @override
  final LocationController locationController =
      GET.Get.put(LocationController());

  File? _image;
  bool name_ = false;
  bool newnumber = false;
  var contactid;
  List existing_customer_details = [];
  late File imageFile;
  bool existingcustomer_ = false;
  var responseData;
  var address;
  final ImagePicker _picker = ImagePicker();
  var currentAddress;
  List hive_state = [];
  GlobalKey<FormState> dealerkey_ = GlobalKey<FormState>();

  void determinateIndicator() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (value == 1) {
          timer.cancel();
        } else {
          value = value + 0.3;
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // territory_list();

    // final location = Hive.box('customer_details');
    // hive_state = location.toMap().values.toList();
    district_list();
    dealerdoorno.text = "N/A";
    print(locationController.latitude.toString());
    print(locationController.longitude.toString());
    print(locationController.address.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffEB455F),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const home_page()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        // backgroundColor: const Color(0xFFEB455F),
        title: Text(
          'Dealer Creation',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 20, letterSpacing: .2, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: dealerkey_,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Dealer type",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 17,
                              letterSpacing: .2,
                              color: Color(0xFF21232c)),
                        ),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                            child: CheckboxListTile(
                          title: const Text('New Dealer'),
                          value: newdealer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onChanged: (value) {
                            setState(() {
                              existingdealer = false;
                              newdealer = value!;
                              print(newdealer);
                            });
                          },
                        )),
                        Expanded(
                            child: CheckboxListTile(
                          title: const Text('Existing Dealer'),
                          shape: const CircleBorder(),
                          value: existingdealer,
                          onChanged: (value) {
                            setState(() {
                              existingdealer = value!;
                              newdealer = false;
                              print(existingdealer);
                            });
                          },
                        )),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: dealermobile,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    onChanged: (String str) {
                      setState(() {
                        existingcustomer_ = true;
                        singlenumber = dealermobile.text;
                        if (dealermobile.text.length <= 10) {
                          existing_customer_details = [];
                        }

                        if (dealermobile.text.length == 10) {
                          existingcustomer(dealermobile.text);
                        } else {
                          setState(() {
                            newnumber = false;
                          });
                        }
                      });
                    },
                    validator: (value) {
                      if (dealermobile.text.isEmpty) {
                        return 'Please enter mobile number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffix: (existingcustomer_) &&
                              (dealermobile.text.isNotEmpty)
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                // backgroundColor: Color(0xFF2B3467),
                                valueColor:
                                    AlwaysStoppedAnimation(Color(0xFF2B3467)),
                                strokeWidth: 3.5,
                              ),
                            )
                          : null,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),

                      // border: OutlineInputBorder(),
                      focusedBorder: const UnderlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),

                      labelText: "Mobile Number",
                    ),
                  ),

                  for (int j = 0; j < existing_customer_details.length; j++)
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                          (name_)
                              ? existing_customer_details[j].toString()
                              : "",
                          style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: .2,
                              color: Color(0xFF2B3467))),
                    ),
                  (newnumber)
                      ? TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          controller: newnumber_,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter dealer name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(
                                PhosphorIcons.plus_circle_bold,
                                color: Color(0xFF2B3467),
                              ),
                              onPressed: () {
                                add_number(contactid, newnumber_.text);
                                print(contactid);
                              },
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Color(0xFF808080)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                  color: Color(0xFFEB455F), width: 2.0),
                            ),
                            labelText: "Add Mobile Number",
                            // hintText: "Enter dealer name"
                          ),
                        )
                      : const SizedBox(),
                  TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    controller: dealername,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter dealer name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "Dealer Name",
                      // hintText: "Enter dealer name"
                    ),
                  ),

                  // Visibility(
                  //     visible: mobile_errortext,
                  //     child: const Align(
                  //       alignment: Alignment.bottomLeft,
                  //       child: Text(
                  //           "Mobile number must be greater than 10 digits.",
                  //           style: TextStyle(
                  //               color: Color.fromARGB(255, 189, 34, 23),
                  //               fontSize: 12)),
                  //     )),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: Landline,

                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter doorno';
                    //   }
                    //   return null;
                    // },
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "Landline Number",
                      // hintText: "Enter door no"
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Add Dealer Address",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF2B3467)),
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    controller: dealerdoorno,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter doorno';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "Door No",
                      // hintText: "Enter door no"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    controller: dealercity,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter street';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 66, 65, 65)),
                      ),
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "Street",
                      // hintText: "Enter street"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SearchField(
                    controller: dealerstate,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select State';
                      }
                      if (!state.contains(value)) {
                        return 'State not found';
                      }
                      return null;
                    },
                    suggestions: state
                        .map((String) => SearchFieldListItem(String))
                        .toList(),
                    suggestionState: Suggestion.expand,
                    textInputAction: TextInputAction.next,
                    hasOverlay: false,
                    marginColor: Colors.white,
                    searchStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    onSuggestionTap: (x) {
                      FocusScope.of(context).unfocus();
                      territory_list(dealerstate.text);
                    },
                    searchInputDecoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "State",
                      // hintText: "State"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SearchField(
                    controller: districts,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select district';
                      }
                      if (!districts_list.contains(value)) {
                        return 'districts not found';
                      }
                      return null;
                    },
                    suggestions: districts_list
                        .map((String) => SearchFieldListItem(String))
                        .toList(),
                    suggestionState: Suggestion.expand,
                    marginColor: Colors.white,
                    onSuggestionTap: (x) {
                      FocusScope.of(context).unfocus();
                      for (int g = 0; g < arealist_.length; g++) {
                        print(arealist_[g][districts.text]);
                        setState(() {
                          areafinallist_ = (arealist_[g][districts.text]);
                        });
                      }
                      // print(districts.text);
                    },
                    textInputAction: TextInputAction.next,
                    hasOverlay: false,
                    searchStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    searchInputDecoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "District",
                      // hintText: "Select District"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SearchField(
                    controller: dealerarea,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select area';
                      }
                      if (!areafinallist_.contains(value)) {
                        return 'Area not found';
                      }
                      return null;
                    },
                    suggestions: areafinallist_
                        .map((String) => SearchFieldListItem(String))
                        .toList(),
                    suggestionState: Suggestion.expand,
                    marginColor: Colors.white,
                    onSuggestionTap: (x) {
                      FocusScope.of(context).unfocus();
                      pincode_text.text = dealerarea.text.split("-").last;
                    },
                    textInputAction: TextInputAction.next,
                    hasOverlay: false,
                    searchStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    searchInputDecoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "Area",
                      // hintText: "Select Area"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: pincode_text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select pincode';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF808080)),
                      ),
                      // border: OutlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        //                           // borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Color(0xFFEB455F), width: 2.0),
                      ),
                      labelText: "Pincode",
                      // hintText: "Pincode"
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  (image_temp)
                      ? DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          color: const Color(0xFF2B3467),
                          strokeWidth: 2,
                          strokeCap: StrokeCap.round,
                          dashPattern: const [
                            5,
                            5,
                            5,
                          ],
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(11)),
                            child: GestureDetector(
                                onTap: () {
                                  print(",,,...,.,>>>.");
                                  showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) => bottomSheet()),
                                  );
                                },
                                child: Container(
                                    width: 333,
                                    height: 75,
                                    color: const Color(0xffe8effc),
                                    child: Column(
                                      children: const [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Icon(
                                          PhosphorIcons.cloud_arrow_up_light,
                                          color: Color(0xFF2B3467),
                                          size: 30,
                                        ),
                                        Text("Click to upload")
                                      ],
                                    ))),
                          ))
                      : Column(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Selected File",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: .2,
                                        fontSize: 18,
                                        color: Color(0xff818cca)))),
                            Card(
                                elevation: 4,
                                color: const Color(0xffe8effc),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Image.file(_image!),
                                      title: Text(pathttt),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        width: 325,
                                        // height: 20,
                                        child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            child: LinearProgressIndicator(
                                              backgroundColor:
                                                  const Color(0xffe8effc),
                                              color: const Color(0xFF2B3467),
                                              value: value,
                                              minHeight: 7,
                                            )))
                                  ],
                                )),
                          ],
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  AnimatedButton(
                      text: 'Submit',
                      color: const Color(0xFFEB455F),
                      pressEvent: () {
                        if (dealerkey_.currentState!.validate()) {
                          customer_creation(
                            dealername.text,
                            dealermobile.text,
                            dealerdoorno.text,
                            dealercity.text,
                            dealerarea.text,
                            dealerstate.text,
                            districts.text,
                            pincode_text.text,
                            Landline.text,
                          );
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future customer_creation(
    fullName,
    mobilenumber,
    dealerdoorno,
    dealercity,
    tity,
    state,
    districts,
    pincode,
    landline_number,
  ) async {
    SharedPreferences token = await SharedPreferences.getInstance();
    setState(() {
      username = token.getString('full_name');
    });
    print(locationController.latitude.toString());
    print(locationController.longitude.toString());
    print(locationController.address.toString());

    var response = await http.get(
        Uri.parse(
            """${dotenv.env['API_URL']}/api/method/oxo.custom.api.new_customer?&full_name=${fullName}&phone_number=${mobilenumber}&landline_number=${landline_number}&doorno=${dealerdoorno}&address=${dealercity}&districts=${districts}&territory=${tity}&customer_group=${newdealer ? "New Dealer" : "Existing Dealer"}&state=${state}&latitude=${locationController.latitude.value}&longitude=${locationController.longitude.value}&auto_pincode=${locationController.address.value}&user=${username}&pincode=${pincode}"""),
        headers: {"Authorization": token.getString("token") ?? ""});

    if (response.statusCode == 200) {
      celar_text();

      var docName = json.decode(response.body)['customer'];
      setState(() {
        AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          title: (json.decode(response.body)['message']),
          btnOkOnPress: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const home_page()));
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {},
        ).show();
        if (pathttt != null && pathttt.isNotEmpty) {
          uploadimage(imageFile, docName);
        }
      });
    } else if ((response.statusCode == 408)) {
      Fluttertoast.showToast(
          msg: (json.decode(response.body)['message']),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: const Color.fromARGB(255, 234, 10, 10),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  celar_text() {
    districts.clear();
    dealername.clear();
    dealermobile.clear();
    dealerdoorno.clear();
    dealercity.clear();
    dealerstate.clear();
    dealerarea.clear();
    dealerpincode.clear();
    pincode_text.clear();
    Manualdata_.clear();
    mobilenumber.clear();
    Landline.clear();
    newdealer = false;
    existingdealer = false;
  }

  Future territory_list(String state) async {
    districts_list = [];
    var response = await http.get(Uri.parse(
        """${dotenv.env['API_URL']}/api/method/oxo.custom.api.territory?state=$state"""));
    if (response.statusCode == 200) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['State'].length; i++) {
          districts_list.add((json.decode(response.body)['State'][i]));
        }

        for (var j = 0; j < json.decode(response.body)['Area'].length; j++) {
          arealist_.add(json.decode(response.body)['Area'][j]);
        }
      });
    }
  }

  Future pickImage(ImageSource source) async {
    String dir;
    String pdfName;

    File file;

    try {
      final file = await ImagePicker()
          .pickImage(source: source, maxWidth: 500, maxHeight: 500);

      final paths = await getApplicationDocumentsDirectory();
      if (file == null) return;
      setState(() {
        _image = File(file.path);

        // print(File(file.path));
        imageFile = File(file.path);
        pathttt = imageFile.path.split("/").last;

        // print(",,,,.........................");
        // print(pathttt);

        image_temp = false;

        // uploadimage(imageFile);
      });
      determinateIndicator();
      // _cropImage(file.path);

      Navigator.pop(context);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future uploadimage(paths, docName) async {
    final token = await SharedPreferences.getInstance();
    // print(docName);
    // print("working");
    var length = await paths.length();
    Dio dio = new Dio();
    try {
      String filename = paths.path.split("/").last;
      print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      print(filename);
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(paths.path, filename: filename),
        "docname": docName,
        "doctype": 'Customer',
        "attached_to_name": docName,
        "is_private": 0,
        "folder": "Home/Attachments"
      });

      var dio = Dio();

      dio.options.headers["Authorization"] =
          token.getString('token').toString();

      var response = await dio.post(
        "https://oxo.thirvusoft.co.in/api/method/upload_file",
        data: formData,
      );
      if (response.statusCode == 200) {
        setState(() {
          image_temp = true;
          imageFile.delete();
        });
        print(imageFile.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  Future district_list() async {
    district_lists = [];
    state = [];
    SharedPreferences token = await SharedPreferences.getInstance();
    // print('ppppppppppppppppp');

    var response = await http.get(
        Uri.parse(
            """${dotenv.env['API_URL']}/api/method/oxo.custom.api.state_list"""),
        headers: {"Authorization": token.getString("token") ?? ""});

    if (response.statusCode == 200) {
      setState(() async {
        for (var i = 0; i < json.decode(response.body)['state'].length; i++) {
          state.add((json.decode(response.body)['state'][i]));
        }
        final location = Hive.box('customer_details');
        state.sort();
        for (var i in state) {
          await location.add(i);
        }
      });
    }
  }

  Future existingcustomer(mobile_number) async {
    contactid = "";
    existing_customer_details = [];
    SharedPreferences token = await SharedPreferences.getInstance();
    print(
        "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++===");
    final dio = Dio();
    dio.options.headers = {"Authorization": token.getString('token') ?? ''};

    final response = await dio.get(
        '${dotenv.env['API_URL']}/api/method/oxo.custom.api.existing_customer',
        queryParameters: {'mobile_number': mobile_number});
    print(
        "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++===");
    print(response.statusCode);
    print(response.data);
    if (response.statusCode == 200) {
      setState(() {
        existingcustomer_ = false;
      });
      responseData = response.data;
      var des = {};

      print(responseData["address"]);

      var Doorno = responseData["address"][0]['address_line1'];
      var Street = responseData["address"][0]['address_line2'];
      var State = responseData["address"][0]['state'];
      var District = responseData["address"][0]['city'];

      var Dealer_group = responseData["customer"][0]['customer_group'];
      var Area = responseData["customer"][0]['territory'];
      var Dealername = responseData["customer"][0]['customer_name'];
      existing_customer_details.add("Dealername : $Dealername");
      existing_customer_details.add("Dealergroup : $Dealer_group");
      existing_customer_details.add("Doorno : $Doorno");
      existing_customer_details.add("Street : $Street");
      existing_customer_details.add("State : $State");
      existing_customer_details.add("District : $District");
      existing_customer_details.add("Area : $Area");
      if (existing_customer_details.isNotEmpty) {
        setState(() {
          contactid = responseData["customer"][0]['name'];
          name_ = true;
          newnumber = true;
        });
      }
      print("ddddddddddddddddddddddddddddddddddd");
      print(contactid);
      print("ddddddddddddddddddddddddddddddddddd");
      print(existing_customer_details);
    } else {
      print('Request failed with status code ${response.statusCode}');
    }
  }

  Future add_number(customerid, mobilenumber) async {
    existing_customer_details = [];
    SharedPreferences token = await SharedPreferences.getInstance();
    print(
        "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++===");
    final dio = Dio();
    dio.options.headers = {"Authorization": token.getString('token') ?? ''};

    final response = await dio.get(
        '${dotenv.env['API_URL']}/api/method/oxo.custom.api.add_phone_number',
        queryParameters: {
          'contact_id': customerid,
          "new_number": mobilenumber,
          "user": token.getString('full_name')
        });
    print(
        "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++===");
    print(response.statusCode);
    print(response.data);
    if (response.statusCode == 200) {
      var responseData = response.data;
      Fluttertoast.showToast(
          msg: responseData['Message'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: const Color(0xFF2B3467),
          textColor: Colors.white,
          fontSize: 16.0);
      newnumber_.clear();

      print(response);
    } else {
      print('Request failed with status code ${response.statusCode}');
    }
  }

  Widget bottomSheet() {
    return Container(
      height: 150.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            ("Choose the media"),
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(
                PhosphorIcons.camera,
              ),
              onPressed: () {
                pickImage(ImageSource.camera);
              },
              label: const Text("Camera"),
            ),
            const SizedBox(
              width: 12,
            ),
            ElevatedButton.icon(
              icon: const Icon(PhosphorIcons.image),
              onPressed: () {
                print("hello");
                pickImage(ImageSource.gallery);
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }
}
