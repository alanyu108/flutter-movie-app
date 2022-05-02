import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/screens/addReviewScreen.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/provider/googleProvider.dart';

class userScreen extends StatelessWidget {
  userScreen({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: Consumer<GoogleSignInProvider>(
            builder: (context, value, child) => Scaffold(
                  appBar: AppBar(
                    title: const Text("Movie App"),
                    centerTitle: true,
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            provider.googleLogout();
                          },
                          child: const Text("Logout"))
                    ],
                  ),
                  body: Center(
                      child: Column(children: [
                    Text("User: ${user?.displayName!} "),
                    Text("Email: ${user?.email!}"),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/review");
                      },
                      child: const Text('Add review'),
                    )
                  ])),
                )));
  }
}
