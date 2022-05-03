import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/screens/userScreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapsnot) {
        //if the user sucessfully logs in
        if (snapsnot.hasData) {
          return userScreen();
        } else if (snapsnot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapsnot.hasError) {
          return const Center(child: Text("We have an error"));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Movie App"),
              centerTitle: true,
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text("Login"))
              ],
            ),
            body: const Center(child: Text("This is the homepage")),
          );
        }
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Movie App"),
  //       centerTitle: true,
  //       actions: [
  //         ElevatedButton(
  //             onPressed: () {
  //               Navigator.pushNamed(context, '/login');
  //             },
  //             child: const Text("Login"))
  //       ],
  //     ),
  //     body: Center(child: Text("This is the homepage")),
  //   );
  // }
}
