import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxo/screens/sales/home_page.dart';

class dealer extends StatefulWidget {
  const dealer({super.key});

  @override
  State<dealer> createState() => _dealerState();
}

class _dealerState extends State<dealer> {
  @override
  Widget build(BuildContext context) {
        final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromRGBO(44, 185, 176, 1),
            title: Center(
              child: Text(
                'Dealer Creation',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 20, letterSpacing: .2, color: Colors.white),
                ),
              ),
            )),
        body: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    // bottom: 20.0,
                    child: Column(
                      children: <Widget>[
                        dealer_name(size),
                        dealer_mobile(size),
                        dealer_address(size),
                        dealer_submit(size)
                        // buildFooter(size),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget dealer_name(Size size) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: SizedBox(
      
        child: TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color:  Color.fromRGBO(44, 185, 176, 1), width: 2.0),
          ),
          hintText: "Enter dealer name"),
     
    )),
    
    );
  }


    Widget dealer_mobile(Size size) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: SizedBox(
      
        child: TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color:  Color.fromRGBO(44, 185, 176, 1), width: 2.0),
          ),
          hintText: "Enter dealer mobile number"),
     
    )),
    
    );
  }


      Widget dealer_address(Size size) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 40),
        child: SizedBox(
         
      
        child: Column(children: [Container(
          child:Text("Add Dealer Address",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          ),
             SizedBox(height: 20,),
    Container(child:
          
         
        TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color:  Color.fromRGBO(44, 185, 176, 1), width: 2.0),
          ),
          hintText: "Enter address"),
     
    )),
    SizedBox(height: 20,),
    Container(child:
        TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color:  Color.fromRGBO(44, 185, 176, 1), width: 2.0),
          ),
          hintText: "Enter city"),
     
    )),
      SizedBox(height: 20,),
    Container(child:
        TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color:  Color.fromRGBO(44, 185, 176, 1), width: 2.0),
          ),
          hintText: "Enter state"),
     
    )),
     SizedBox(height: 20,),
     Container(child:
        TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color:  Color.fromRGBO(44, 185, 176, 1), width: 2.0),
          ),
          hintText: "Enter postal code"),
     
    )),
    ],
    )),
    
    );
  }




    Widget dealer_submit(Size size) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: SizedBox(
      
        child: AnimatedButton(
                          text: 'Submit',
                          color: Color.fromRGBO(44, 185, 176, 1),
                          pressEvent: () {
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.leftSlide,
                              headerAnimationLoop: false,
                              dialogType: DialogType.success,
                              title: 'Dealer Added Sucessfully',
                              btnOkOnPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => home_page()),
                                );
                              },
                              btnOkIcon: Icons.check_circle,
                              onDismissCallback: (type) {},
                            ).show();
                          },
                        ),),
    
    );
  }
}
