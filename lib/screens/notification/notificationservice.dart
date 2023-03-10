import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oxo/screens/Orders/Orderlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  onPressed: () async {
                    print(item[index]["name"]);

                    try {
                      final SharedPreferences token =
                          await SharedPreferences.getInstance();
                      final Dio dio = Dio();
                      final Map<String, dynamic> data = {
                        'name': item[index]["name"],
                        'user': token.getString('full_name')
                      };
                      final String url =
                          '${dotenv.env['API_URL']}/api/method/oxo.custom.api.dispatched';

                      final Options options = Options(headers: {
                        'Authorization': token.getString('token') ?? ''
                      });

                      final Response response = await dio.post(
                        url,
                        queryParameters: data,
                        options: options,
                      );

                      if (response.statusCode == 200) {
                        item.remove(item[index]["name"]);

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
                          MaterialPageRoute(
                              builder: (context) => TabLayoutExample()),
                        );
                      } else {
                        print(
                            'Request failed with status: ${response.statusCode}.');
                      }
                    } on DioError catch (e) {
                      if (e.response != null) {
                        print(e.response!.data);
                      } else {
                        print(e.message);
                      }
                    } catch (e) {
                      print(e);
                    }
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
