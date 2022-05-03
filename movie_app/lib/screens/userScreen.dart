import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/widget/MovieReviewList.dart';
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
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("User: ${user?.displayName!} "),
                  Text("Email: ${user?.email!}"),
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
