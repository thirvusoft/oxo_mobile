import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:oxo/constants.dart';
import 'package:oxo/screens/sales/home_page.dart';
import 'package:oxo/screens/sales/order.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var login_loading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xFF21899C),
        body: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              height: size.height,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    bottom: 20.0,
                    child: Column(
                      children: <Widget>[
                        buildCard(size),
                        buildFooter(size),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildCard(Size size) {
    return Container(
      alignment: Alignment.center,
      width: size.width * 0.9,
      height: size.height * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //logo & text
          logo(size.height / 8, size.height / 8),
          SizedBox(
            height: size.height * 0.03,
          ),
          richText(24),
          SizedBox(
            height: size.height * 0.05,
          ),

          //email & password textField
          mobileTextField(size),
          SizedBox(
            height: size.height * 0.02,
          ),
          passwordTextField(size),
          SizedBox(
            height: size.height * 0.03,
          ),

          //sign in button
          LogInButton(size),
        ],
      ),
    );
  }

  Widget buildFooter(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          height: size.height * 0.04,
        ),
        SizedBox(
          width: size.width * 0.6,
          height: 44.0,
        ),
      ],
    );
  }

  Widget logo(double height_, double width_) {
    return SvgPicture.asset(
      'assets/logo.svg',
      height: height_,
      width: width_,
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: const Color(0xFF21899C),
          letterSpacing: 2.000000061035156,
        ),
        children: const [
          TextSpan(
            text: 'LOGIN',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: 'PAGE',
            style: TextStyle(
              color: Color(0xFFFE9879),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget mobileTextField(Size size) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          height: size.height / 12,
          child: Form(
            key: formkey_mobile,
            child: TextFormField(
              controller: mobilenumcontroller,
              style: GoogleFonts.inter(
                fontSize: 18.0,
                color: const Color(0xFF151624),
              ),
              maxLines: 1,
              maxLength: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter mobile number';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              cursorColor: const Color(0xFF151624),
              decoration: InputDecoration(
                counterText: "",
                hintText: 'Enter mobile number',
                hintStyle: GoogleFonts.inter(
                  fontSize: 16.0,
                  color: const Color(0xFF151624).withOpacity(0.5),
                ),
                filled: true,
                fillColor: mobilenumcontroller.text.isEmpty
                    ? const Color.fromRGBO(248, 247, 251, 1)
                    : Colors.transparent,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(
                      color: mobilenumcontroller.text.isEmpty
                          ? Colors.transparent
                          : const Color.fromRGBO(44, 185, 176, 1),
                    )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(44, 185, 176, 1),
                    )),
                prefixIcon: Icon(
                  Icons.phone,
                  color: mobilenumcontroller.text.isEmpty
                      ? const Color(0xFF151624).withOpacity(0.5)
                      : const Color.fromRGBO(44, 185, 176, 1),
                  size: 16,
                ),
                suffix: Container(
                  alignment: Alignment.center,
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: const Color.fromRGBO(44, 185, 176, 1),
                  ),
                  child: mobilenumcontroller.text.isEmpty
                      ? const Center()
                      : const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 13,
                        ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget passwordTextField(Size size) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          height: size.height / 12,
          child: Form(
            key: formkey_pass,
            child: TextFormField(
              controller: passController,
              style: GoogleFonts.inter(
                fontSize: 16.0,
                color: const Color(0xFF151624),
              ),
              cursorColor: const Color(0xFF151624),
              obscureText: false,
              keyboardType: TextInputType.visiblePassword,
              validator: (value) {
                focusedBorder:
                OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(44, 185, 176, 1),
                    ));
                if (value == null || value.isEmpty) {
                  return 'Please enter Password';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Enter your password',
                hintStyle: GoogleFonts.inter(
                  fontSize: 16.0,
                  color: const Color(0xFF151624).withOpacity(0.5),
                ),
                filled: true,
                fillColor: passController.text.isEmpty
                    ? const Color.fromRGBO(248, 247, 251, 1)
                    : Colors.transparent,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(
                      color: passController.text.isEmpty
                          ? Colors.transparent
                          : const Color.fromRGBO(44, 185, 176, 1),
                    )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(44, 185, 176, 1),
                    )),
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  color: passController.text.isEmpty
                      ? const Color(0xFF151624).withOpacity(0.5)
                      : const Color.fromRGBO(44, 185, 176, 1),
                  size: 16,
                ),
                suffix: Container(
                  alignment: Alignment.center,
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: const Color.fromRGBO(44, 185, 176, 1),
                  ),
                  child: passController.text.isEmpty
                      ? const Center()
                      : const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 13,
                        ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget LogInButton(Size size) {
    return Container(
      height: size.height / 13,
      width: size.width * 0.7,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            login_loading = true;
          });

          if (formkey_mobile.currentState!.validate() &&
              (formkey_pass.currentState!.validate())) {
            ;
            loginup(mobilenumcontroller.text, passController.text);
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
          primary: Color(0xFF21899C),
          shape: StadiumBorder(),
        ),
        child: (login_loading)
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 1.5,
                ))
            : Text(
                "Log In",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
      ),
    );
  }

// if (formkey_mobile.currentState!.validate() && (formkey_pass.currentState!.validate()));

  loginup(mobilenum, password) async {
    print('object');
    var response = await http.get(
        Uri.parse(
            """https://demo14prime.thirvusoft.co.in/api/method/oxo.custom.api.login?mobile=${mobilenum}&password=${password}"""),
        headers: {"Authorization": 'token ddc841db67d4231:bad77ffd922973a'});
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      user_name = json.decode(response.body)['full_name'];
      print(user_name);
      setState(() {
        login_loading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => home_page(),
        ),
        // (route) => false,
      );
      Fluttertoast.showToast(
          msg: (json.decode(response.body)['message']),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Color.fromARGB(255, 15, 194, 62),
          textColor: Colors.white,
          fontSize: 15.0);
    } else if (response.statusCode == 500) {
      setState(() {
        login_loading = false;
      });
      Fluttertoast.showToast(
          msg: (json.decode(response.body)['message']),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Color.fromARGB(255, 234, 10, 10),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
