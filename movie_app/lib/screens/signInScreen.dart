import 'package:flutter/material.dart';
import '../widget/SignInWidget.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Movie App"),
        ),
        body: Center(
          child: Column(
            children: [const Text("This is the sign in page"), SignInWidget()],
          ),
        ));
  }
}
