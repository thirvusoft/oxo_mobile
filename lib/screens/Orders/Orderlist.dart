import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oxo/constants.dart';
import 'package:oxo/screens/notification/notificationservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabLayoutExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabLayoutExampleState();
  }
}

class _TabLayoutExampleState extends State<TabLayoutExample>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    orderList();
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.animateTo(2);
  }

  static const List<Tab> _tabs = [
    Tab(icon: Icon(PhosphorIcons.shopping_bag_light), child: Text('Order')),
    Tab(icon: Icon(PhosphorIcons.package_light), text: 'Dispatched'),
  ];

  List<Widget> _views = [];
  void _dispatchedCallback(dynamic responseData) {
    // update the state of the widget using setState
    setState(() {
      // update the _items list or any other state variables
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            // unselectedLabelStyle: const TextStyle(fontStyle: FontStyle.italic),
            overlayColor:
                MaterialStateColor.resolveWith((Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.blue;
              }
              if (states.contains(MaterialState.focused)) {
                return Colors.orange;
              } else if (states.contains(MaterialState.hovered)) {
                return Colors.pinkAccent;
              }

              return Colors.transparent;
            }),
            // indicatorWeight: 10,

            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            // indicatorPadding: const EdgeInsets.all(5),
            // indicator: BoxDecoration(
            //   border: Border.all(color: Colors.red),
            //   borderRadius: BorderRadius.circular(10),
            //   color: Colors.pinkAccent,
            // ),
            // isScrollable: true,
            physics: BouncingScrollPhysics(),
            onTap: (int index) {
              print('Tab $index is tapped');
            },
            // enableFeedback: true,
            // Uncomment the line below and remove DefaultTabController if you want to use a custom TabController
            // controller: _tabController,
            tabs: _tabs,
          ),
          title: const Text('Order List'),
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          // Uncomment the line below and remove DefaultTabController if you want to use a custom TabController
          // controller: _tabController,
          children: _views,
        ),
      ),
    );
  }

  Future<void> orderList() async {
    final SharedPreferences token = await SharedPreferences.getInstance();
    final Dio dio = Dio();
    print("tttttttttttttttttttttttt");
    print(token.getString('full_name'));
    final Map<String, dynamic> data = {
      'distributor': token.getString('full_name')
    };
    final String url =
        '${dotenv.env['API_URL']}/api/method/oxo.custom.api.sales_order_list';

    final Options options =
        Options(headers: {'Authorization': token.getString('token') ?? ''});

    try {
      final Response response =
          await dio.get(url, queryParameters: data, options: options);

      if (response.statusCode == 200) {
        final dynamic responseData = response.data;
        print("object");
        print(responseData);
        setState(() {
          orderLists = responseData['Order'] ?? [];
          dispatched = responseData['Dispatched'] ?? [];

          _views = [
            (orderLists.isNotEmpty)
                ? myListView(true, orderLists)
                : const Center(
                    child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("You did not create any order.",
                        style:
                            TextStyle(fontSize: 18, color: Color(0xFF2B3467))),
                  )),
            (dispatched.isNotEmpty)
                ? myListView(false, dispatched)
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          "Orders are not being accepted by the distributor.",
                          style: TextStyle(
                              fontSize: 18, color: Color(0xFF2B3467))),
                    ),
                  ),
          ];
        });
        print(dispatched);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
