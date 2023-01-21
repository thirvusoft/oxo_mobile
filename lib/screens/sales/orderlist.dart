import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class order_list extends StatefulWidget {
  const order_list({super.key});

  @override
  State<order_list> createState() => _order_listState();
}

class _order_listState extends State<order_list> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: const Color(0xffEB455F),

        appBar: AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_outlined),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xffEB455F),
      elevation: 0,
      title: Text("Order List"),
      centerTitle: true,
    ));
  }
}
