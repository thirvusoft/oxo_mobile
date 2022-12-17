import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/screens/add_dealer.dart/dealer.dart';
import 'package:oxo/screens/sales/order.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromRGBO(44, 185, 176, 1),
            title: Center(
              child: Text(
                'Home Page',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 20, letterSpacing: .2, color: Colors.white),
                ),
              ),
            )),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(child: getCardItem()),
              Expanded(child: getCardItem2()),
            ],
          ),
        ));
  }

Widget getCardItem() {
  return Center(
      child: Padding(
    padding: const EdgeInsets.all(10),
    child: Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            spreadRadius: 10,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Expanded(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top:20)),
            Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
                Container(
                  child: Icon(Icons.supervisor_account,
                      size: 70, color:Color.fromRGBO(44, 185, 176, 1),),
                  // padding: const EdgeInsets.all(10),
                ),
                // Container(
                //   child: Text(
                //     "20",
                //     style: TextStyle(
                //       color: Colors.blueAccent,
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              // decoration: const BoxDecoration(
              //     color:Color.fromRGBO(44, 185, 176, 1),
              //     borderRadius: BorderRadius.only(
              //         bottomRight: Radius.circular(12),
              //         bottomLeft: Radius.circular(12))),
              child: ElevatedButton(
                child: Text('Add Dealer'),
                onPressed: () {Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => dealer()),
                        );},
                 style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0), backgroundColor: Color(0xFF21899C),
          shape: StadiumBorder(),
        ),
              ),
              padding: const EdgeInsets.all(12),
            )
          ],
        ),
      ),
    ),
  ));
}

Widget getCardItem2() {
   return Center(
      child: Padding(
    padding: const EdgeInsets.all(.0),
    child: Container(
      height: 200,
      width: 200,
      decoration:BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            spreadRadius: 10,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child:  Expanded(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top:30)),
            Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
                Container(
                  child: Icon(Icons.shopping_cart,
                      size: 70, color:Color.fromRGBO(44, 185, 176, 1),),
                  // padding: const EdgeInsets.all(10),
                ),
                // Container(
                //   child: Text(
                //     "20",
                //     style: TextStyle(
                //       color: Colors.blueAccent,
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              // decoration: const BoxDecoration(
              //     color:Color.fromRGBO(44, 185, 176, 1),
              //     borderRadius: BorderRadius.only(
              //         bottomRight: Radius.circular(12),
              //         bottomLeft: Radius.circular(12))),
              child: ElevatedButton(
                child: Text('Create Order'),
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => order()),
                        );},
                 style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0), backgroundColor: Color(0xFF21899C),
          shape: StadiumBorder(),
        ),
              ),
              padding: const EdgeInsets.all(12),
            )
          ],
        ),
      ),
    ),
  ));
}



}