import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import '../Home Page/home_page.dart';

class Itemreport extends StatefulWidget {
  const Itemreport({super.key});

  @override
  State<Itemreport> createState() => _ItemreportState();
}

class _ItemreportState extends State<Itemreport> {
  late String _startDate, _endDate;
  List item = [];
  bool temp = true;
  double total = 0;
  var invoicecount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                PhosphorIcons.calendar,
                color: Colors.white,
              ),
              onPressed: () {
                _showMyDialog();
              },
            )
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const home_page()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          automaticallyImplyLeading: false,
          title: Text(
            'Report',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontSize: 20, letterSpacing: .2, color: Colors.white),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: (temp)
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.30),
                    child: const Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              PhosphorIcons.info,
                              size: 35,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Please select the date',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2B3467)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 1.2,
                        child: ListView.builder(
                          itemCount: item.length,
                          itemBuilder: (BuildContext context, int index) {
                            var itemGroup = item[index];
                            var groupName = itemGroup['item_group'];

                            List<Widget> templateTiles = [];

                            for (var itemTemplate
                                in itemGroup['item_template']) {
                              var templateName = itemTemplate['item_template'];
                              List<Widget> itemTiles = [];

                              for (var item in itemTemplate['item_list']) {
                                var itemCode = item['item_code'];
                                var qty = item['qty'].toString();
                                itemTiles.add(
                                  ListTile(
                                      title: Text("Item Name: $itemCode"),
                                      trailing: Text(" Qty: $qty")),
                                );
                              }

                              var templateTile = ExpansionTile(
                                title: Text(" $templateName"),
                                children: itemTiles,
                              );
                              templateTiles.add(templateTile);
                            }

                            return Card(
                                child: ExpansionTile(
                              leading: CircleAvatar(
                                  radius: 12.5,
                                  backgroundColor: const Color(0xFF2B3467),
                                  child: Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                              title: Text("Item Group : $groupName"),
                              children: templateTiles,
                            ));
                          },
                        )),
                    (item.isEmpty)
                        ? const SizedBox()
                        : SizedBox(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "  Order Count: ${invoicecount[0]['count']}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  Expanded(
                                      child: Text(
                                    "  Item Total : $total",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          )
                  ],
                ),
        ));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SizedBox(
          height: 500,
          child: AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: SfDateRangePicker(
                      view: DateRangePickerView.month,
                      selectionMode: DateRangePickerSelectionMode.range,
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        setState(() {
                          _startDate = DateFormat('yyyy-MM-dd')
                              .format(args.value.startDate)
                              .toString();
                          _endDate = DateFormat('yyyy-MM-dd')
                              .format(
                                  args.value.endDate ?? args.value.startDate)
                              .toString();
                        });
                      },
                      minDate: DateTime(2020, 02, 05),
                      maxDate: DateTime.now(),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop();
                  print(_startDate);
                  print(_endDate);
                  itemsummary(_startDate, _endDate, setState);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> itemsummary(String formdate, String todate, setState) async {
    SharedPreferences token = await SharedPreferences.getInstance();
    Dio dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? "",
      headers: {
        "Authorization": token.getString("token") ?? "",
      },
    ));

    try {
      Response response = await dio
          .get("/api/method/oxo.custom.api.item_summary", queryParameters: {
        "sales_person": token.getString('full_name'),
        "from_date": formdate,
        "to_date": todate,
      });

      if (response.statusCode == 200) {
        print("xxxxxxxxxxxxxxxx");
        print(response.data);
        print(response.data["item_list"]);
        setState(() {
          temp = false;
          invoicecount = response.data["order_count"];
          item = response.data["item_list"];
          for (var item in item) {
            for (var template in item["item_template"]) {
              for (var detail in template["item_list"]) {
                total += detail["qty"];
              }
            }
          }
          // total = 0;
          // for (int i = 0; i < item.length; i++) {
          //   total = total + item[i]["qty"] ?? 0;
          // }
        });
        print(item);
        print(temp);
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
  }
}
