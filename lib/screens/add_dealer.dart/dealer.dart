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
import 'package:location/location.dart';
import 'package:oxo/constants.dart';
import 'package:oxo/screens/sales/home_page.dart';
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

class dealer extends StatefulWidget {
  const dealer({super.key});

  @override
  State<dealer> createState() => _dealerState();
}

class _dealerState extends State<dealer> {
  @override
  File? _image;

  late File imageFile;

  final ImagePicker _picker = ImagePicker();
  var currentAddress;
  GlobalKey<FormState> dealerkey_ = GlobalKey<FormState>();

  void determinateIndicator() {
    new Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (value == 1) {
          timer.cancel();
        } else {
          value = value + 0.3;
        }
      });
    });
  }

  void initState() {
    // TODO: implement initState
    // territory_list();
    // _getCurrentLocation();
    // district_list();
  }

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
          icon: const Icon(Icons.arrow_back_outlined),
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
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        // border: OutlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          // borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                              BorderSide(color: Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: "Enter dealer name"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: dealermobile,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter mobile number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        counterText: "",
                        // border: OutlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          // borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                              BorderSide(color: Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: "Enter dealer mobile number"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: TextFormField(
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
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        // border: OutlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          // borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                              BorderSide(color: Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: "Enter door no"),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: TextFormField(
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
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        // border: OutlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          // borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                              BorderSide(color: Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: "Enter street"),
                  )),
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
                  Container(
                      child: TextFormField(
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
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        // border: OutlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          // borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                              BorderSide(color: Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: "Enter door no"),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: TextFormField(
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
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        // border: OutlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          // borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                              BorderSide(color: Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: "Enter street"),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: SearchField(
                    controller: dealerarea,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please select Area';
                    //   }
                    //   return null;
                    // },
                    suggestions: area_list
                        .map((String) => SearchFieldListItem(String))
                        .toList(),
                    suggestionState: Suggestion.expand,
                    onSuggestionTap: (x) {
                      FocusScope.of(context).unfocus();
                      print(dealerarea.text);

                      for (int i = 0; i < territory.length; i++) {
                        if (territory[i].contains(dealerarea.text)) {
                          print(territory[i]);
                          print(territory[i][1]);
                          print(territory[i][2]);
                          setState(() {
                            districts.text = territory[i][1];
                            dealerstate.text = territory[i][2];
                          });
                        }
                      }
                      postal_code(
                          dealerarea.text, districts.text, dealerstate.text);
                    },
                    textInputAction: TextInputAction.next,
                    hasOverlay: false,
                    searchStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    searchInputDecoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        // border: OutlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          // borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                              BorderSide(color: Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: "Select Area"),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  SearchField(
                    controller: districts,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select district';
                      }
                      return null;
                    },
                    suggestions: district_lists
                        .map((String) => SearchFieldListItem(String))
                        .toList(),
                    suggestionState: Suggestion.expand,
                    onSuggestionTap: (x) {
                      print(districts.text);
                    },
                    textInputAction: TextInputAction.next,
                    hasOverlay: false,
                    searchStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    searchInputDecoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        // border: OutlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          // borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                              BorderSide(color: Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: "Select District"),
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
                      return null;
                    },
                    suggestions: state
                        .map((String) => SearchFieldListItem(String))
                        .toList(),
                    suggestionState: Suggestion.expand,
                    textInputAction: TextInputAction.next,
                    hasOverlay: false,
                    searchStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    searchInputDecoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        // border: OutlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          // borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                              BorderSide(color: Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: "State"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    // readOnly: true,
                    controller: pincode_text,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        // border: OutlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          //                           // borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                              BorderSide(color: Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: "Pincode"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: Manualdata_,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        //                          border: OutlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFEB455F), width: 2.0),
                        ),
                        hintText: " Area / Pincode "),
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
                                              minHeight: 10,
                                            )))
                                  ],
                                )),
                          ],
                        ),
                  AnimatedButton(
                      text: 'Submit',
                      color: const Color(0xFFEB455F),
                      pressEvent: () {
                        if (dealerkey_.currentState!.validate()) {
                          _getCurrentLocation();

                          customer_creation(
                            dealername.text,
                            dealermobile.text,
                            dealerdoorno.text,
                            dealercity.text,
                            dealerarea.text,
                            dealerstate.text,
                            districts.text,
                            pincode_text.text,
                            Manualdata_.text,
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
    phoneNumber,
    dealerdoorno,
    dealercity,
    tity,
    state,
    districts,
    pincode,
    manualCode,
  ) async {
    SharedPreferences token = await SharedPreferences.getInstance();
    setState(() {
      username = token.getString('full_name');
    });
    print("xxxxxx");
    print(username);
    print("lllll");
    print("lllll");
    print(manualCode);
    print('ppppppppppppppppp');

    print(dealertype);
    var response = await http.get(
        Uri.parse(
            """${dotenv.env['API_URL']}/api/method/oxo.custom.api.new_customer?&full_name=${fullName}&phone_number=${phoneNumber}&doorno=${dealerdoorno}&address=${dealercity}&districts=${districts}&territory=${tity}&state=${state}&latitude=${current_position!.latitude}&longitude=${current_position!.longitude}&auto_pincode=${auto_pincode}&Manual_Data=${manualCode}&user=${username}&pincode=${pincode}"""),
        headers: {"Authorization": token.getString("token") ?? ""});
    print(token.getString("token"));
    print(
        """${dotenv.env['API_URL']}/api/method/oxo.custom.api.new_customer?&full_name=${fullName}&phone_number=${phoneNumber}&doorno=${dealerdoorno}&address=${dealercity}&districts=${districts}&territory=${tity}&state=${state}&latitude=${current_position!.latitude}&longitude=${current_position!.longitude}&auto_pincode=${auto_pincode}&Manual_Data=${manualCode}&user=${username}&pincode=${pincode}""");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      celar_text();
      print(json.decode(response.body)['customer']);
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
        if (pathttt.isNotEmpty) {
          uploadimage(imageFile, docName);
        }
      });
    } else {
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
    print("teststetstete");
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
  }

  Future territory_list() async {
    territory = [];
    area_list = [];

    var response = await http.get(Uri.parse(
        """${dotenv.env['API_URL']}/api/method/oxo.custom.api.territory"""));
    print(response.statusCode);
    print("iiiiiiiiiiiiiiiiiii");
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        for (var i = 0; i < json.decode(response.body)['messege'].length; i++) {
          area_list.add((json.decode(response.body)['messege'][i][0]));
          territory.add((json.decode(response.body)['messege'][i]));
          print(territory[i][1]);
        }
        print(territory);

        print("hoihoihoi");
      });
    }
  }

  Position? _position;
  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    _getAddressFromLatLng(position);
    setState(() {
      _position = position;
      current_position = _position!;
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';

        auto_pincode = ' ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
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

        print(",,,,.........................");
        print(pathttt);

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
    print(docName);
    print("working");
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
        // "attached_to_field": "user_image",
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
        print("sucucucucucuc");
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
    print("object");
    district_lists = [];
    state = [];
    SharedPreferences token = await SharedPreferences.getInstance();
    print('ppppppppppppppppp');

    var response = await http.get(
        Uri.parse(
            """${dotenv.env['API_URL']}/api/method/oxo.custom.api.district_list"""),
        headers: {"Authorization": token.getString("token") ?? ""});

    print("statestate");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        for (var i = 0;
            i < json.decode(response.body)['district'].length;
            i++) {
          print("cccccccccccccc");
          print((json.decode(response.body)['district'][i]));
          district_lists.add((json.decode(response.body)['district'][i]));
        }
        for (var i = 0; i < json.decode(response.body)['state'].length; i++) {
          print("cccccccccccccc");
          print((json.decode(response.body)['state'][i]));
          state.add((json.decode(response.body)['state'][i]));
        }
      });
    }
  }

  Future postal_code(String area, String dis, String state) async {
    print(dis + " " + state);
    var response = await http
        .get(Uri.parse("https://api.postalpincode.in/postoffice/$area"));
    print("postal_code");
    print(
        "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
    print(response.statusCode);

    print(response.body);
    if (response.statusCode == 200) {
      print("cccccc");
      for (var i = 0; i < json.decode(response.body).length; i++) {
        // area_list.add((json.decode(response.body)['messege'][i][0]));
        // territory.add((json.decode(response.body)['messege'][i]));
        print(json.decode(response.body)[i]["PostOffice"]);
        pincode_list = (json.decode(response.body)[i]["PostOffice"]);
        for (var j = 0; j < pincode_list.length; j++) {
          print("object");
          print(dis.toLowerCase());
          print((pincode_list[j]["District"]));
          if (pincode_list[j]["District"].contains(dis) &&
              pincode_list[j]["State"].contains(state)) {
            print((pincode_list[j]["Pincode"]));
            print((pincode_list[j]["Pincode"].runtimeType));
            print((pincode_list[j]["District"]));
            print((pincode_list[j]["Name"].runtimeType));
            setState(() {
              pincode_text.text = pincode_list[j]["Pincode"];
            });
          }
        }
        // print(json.decode(response.body)[i]["PostOffice"]);
        print(pincode_list);
      }
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
                print("object");
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
