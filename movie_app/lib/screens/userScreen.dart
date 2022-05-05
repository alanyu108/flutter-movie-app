import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/widget/MovieReviewList.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/provider/googleProvider.dart';
import '../screens/userPostScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class userScreen extends StatelessWidget {
  userScreen({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(context: context),
        child: Consumer<GoogleSignInProvider>(
          builder: (googleContext, value, child) => Scaffold(
            appBar: AppBar(
              title: Text("MOVIE APP",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.libreBarcode39ExtendedText(
                    color: Colors.white,
                    fontSize: 48,
                  )),
              // centerTitle: true,
              actions: [
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Log out"),
                            content:
                                const Text("Are you sure you want to logout?"),
                            actions: [
                              TextButton(
                                child: const Text(
                                  "No",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  final provider =
                                      Provider.of<GoogleSignInProvider>(
                                          googleContext,
                                          listen: false);
                                  provider.googleLogout();
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      "/", (Route<dynamic> route) => false);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text("Logout"))
              ],
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("User: ${user?.displayName!} "),
                  Text("Email: ${user?.email!}"),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => userPostScreen(
                                user: "${user?.displayName!}",
                                uid: "${user?.uid}"),
                          ),
                        );
                      },
                      child: const Text("See my posts")),
                  const Expanded(
                      child: SizedBox(
                    height: 200,
                    child: MovieReviewList(),
                  )),
                ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Add your onPressed code here!
                Navigator.pushNamed(context, "/review");
              },
              child: const Icon(Icons.add),
            ),
          ),
        ));
  }
}
