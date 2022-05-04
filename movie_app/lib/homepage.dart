import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/screens/userScreen.dart';
import 'widget/MovieReviewList.dart';
import 'package:google_fonts/google_fonts.dart';

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
              title: Text("MOVIE APP",
                  style: GoogleFonts.libreBarcode39ExtendedText(
                    color: Colors.white,
                    fontSize: 48,
                  )),
              // centerTitle: true,
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text("Login"))
              ],
            ),
            body: const MovieReviewList(),
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
