import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oxo/screens/Orders/Orderlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

Widget myListView(
  bool value,
  List item,
) {
  return ListView.builder(
    itemCount: item.length,
    itemBuilder: (BuildContext context, int index) {
      var index_value = index + 1;

      return Card(
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            radius: 12.5,
            backgroundColor: const Color(0xFF2B3467),
            child: Text(
              index_value.toString(),
              style: const TextStyle(
                fontSize: 15.0,
                color: Color(0xFFffffff),
              ),
            ),
          ),
          trailing: Visibility(
            visible: value,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF2B3467), // background (button) color
                    foregroundColor: Colors.white, // foreground (text) colorR
                  ),
                  onPressed: () {
                    String name = item[index]["name"];
                    _dispatch(context, name);
                  },
                  child: const Text('Dispatch'),
                ),
              ],
            ),
          ),
          title: Text(item[index]["name"].toString()),
        ),
      );
    },
  );
}

void _dispatch(BuildContext context, String name) {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Form(
            key: order_list,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2.8,
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                TextFormField(
                  controller: invoice_no,
                  validator: (x) {
                    if (x!.isEmpty) {
                      return " Invoice no can't be empty";
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
                      //                           // borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide:
                          BorderSide(color: Color(0xFFEB455F), width: 2.0),
                    ),
                    labelText: "Invoice No",
                    // hintText: "Pincode"
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: dispatch_date,
                  validator: (x) {
                    if (x!.isEmpty) {
                      return " Date can't be empty";
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
                      //                           // borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide:
                          BorderSide(color: Color(0xFFEB455F), width: 2.0),
                    ),
                    labelText: "Dispatch date",
                    // hintText: "Pincode"
                  ),
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
                            colorScheme: const ColorScheme.dark(
                                primary: Color(0xff19183e),
                                surface: Color(0xff19183e))),
                        child: child,
                      );
                    };
                    dispatch_date.text = date.toString().substring(0, 10);
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                AnimatedButton(
                  text: 'Submit',
                  color: const Color.fromARGB(255, 49, 47, 92),
                  pressEvent: () async {
                    if (order_list.currentState!.validate()) {
                      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>2");

                      print(name);
                      submit_(name, context);
                    }
                  },
                ),
              ]),
            ),
          );
        }));
      });
}

Future submit_(name, context) async {
  print(name);
  print("object");
  try {
    final SharedPreferences token = await SharedPreferences.getInstance();
    final Dio dio = Dio();

    final Map<String, dynamic> data = {
      'name': name,
      'user': token.getString('full_name'),
      "distributor_invoice_no": invoice_no.text,
      "dispatch_date": dispatch_date.text
    };

    final String url =
        '${dotenv.env['API_URL']}/api/method/oxo.custom.api.dispatched';

    final Options options =
        Options(headers: {'Authorization': token.getString('token') ?? ''});

    final Response response = await dio.post(
      url,
      queryParameters: data,
      options: options,
    );
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>2");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      // item.remove(name);

      final dynamic responseData = response.data;
      print(responseData);

      Fluttertoast.showToast(
          msg: responseData["Dispatched"].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Color.fromARGB(255, 43, 52, 103),
          textColor: Colors.white,
          fontSize: 15.0);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TabLayoutExample()),
      );
      dispatch_date.clear();
      invoice_no.clear();
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  } on DioError catch (e) {
    if (e.response != null) {
      print(e.response!.data);
    } else {
      print(e.message);
    }
  } catch (e) {
    print(e);
    print("ppppppppppppppppppppp");
  }
}
