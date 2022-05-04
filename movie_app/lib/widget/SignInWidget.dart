import 'package:flutter/material.dart';
import 'package:movie_app/provider/googleProvider.dart';
import 'package:provider/provider.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: Consumer<GoogleSignInProvider>(
            builder: (context, value, child) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                ),
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/", (Route<dynamic> route) => false);
                },
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Image.asset(
                      'assets/images/googleicon.png',
                      height: 20.0,
                    ),
                    new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: new Text(
                          "Sign in with Google",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        )),
                  ],

                  // const Text('Sign in with Google'),
                ))));
  }
}
