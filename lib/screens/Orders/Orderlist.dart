import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oxo/screens/notification/notificationservice.dart';

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
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.animateTo(2);
  }

  static const List<Tab> _tabs = [
    const Tab(icon: Icon(Icons.looks_one), child: Text('         Order    ')),
    const Tab(icon: Icon(Icons.looks_two), text: '       Dispatched      '),
  ];

  static List<Widget> _views = [
    myListView(),
    myListView()
    // Center(child: Text('Content of Tab One')),
    // Center(child: Text('Content of Tab Two')),
  ];

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


  
}
