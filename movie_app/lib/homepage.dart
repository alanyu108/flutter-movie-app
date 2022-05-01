import 'package:flutter/material.dart';
import 'widget/sign_in.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Movie App"),
            ),
            body: Center(
              child: Column(
                children: [const Text("This is the homepage"), SignInWidget()],
              ),
            )));
  }
}
