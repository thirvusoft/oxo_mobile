import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    const Tab(icon: Icon(Icons.looks_one), child: Text('         Order    ')),
    const Tab(icon: Icon(Icons.looks_two), text: '       Dispatched      '),
  ];

  List<Widget> _views = [];

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
            myListView(false, orderLists),
            myListView(true, dispatched),
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
