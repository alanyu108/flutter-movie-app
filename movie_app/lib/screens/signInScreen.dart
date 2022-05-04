import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/SignInWidget.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
              ),
              Image.asset(
                'assets/images/loginpic.jpeg',
              ),
              Padding(
                padding: EdgeInsets.all(15),
              ),
              Text("Welcome Back",
                  style: GoogleFonts.kaiseiTokumin(
                      color: Colors.white, fontSize: 35)),
              Padding(
                padding: EdgeInsets.all(15),
              ),
              SignInWidget(),
            ],
          ),
        ));
  }
}
