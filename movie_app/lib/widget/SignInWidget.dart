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
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.googleLogin();
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/", (Route<dynamic> route) => false);
                  },
                  child: const Text('Sign in with Google'),
                )));
  }
}
