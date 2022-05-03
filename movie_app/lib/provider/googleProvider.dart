import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String? name;
  final String? email;
  final String? photoUrl;

  User(this.name, this.email, this.photoUrl);
}

class GoogleSignInProvider extends ChangeNotifier {
  User? _user;
  User get user => _user!;
  final googleSignIn = GoogleSignIn();

  Future googleLogin() async {
    //opens sign-in screen
    final googleUser = await googleSignIn.signIn();

    //if user does not select any account
    if (googleUser == null) return;

    //add user to our provider
    _user = User(googleUser.displayName, googleUser.email, googleUser.photoUrl);

    final googleAuth = await googleUser.authentication;

    //store the user in the authenication database on firebase
    final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credentials);
    notifyListeners();
  }

  Future googleLogout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
