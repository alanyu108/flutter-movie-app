import 'package:flutter/material.dart';
import 'package:movie_app/provider/googleProvider.dart';
import 'package:provider/provider.dart';
import '../screens/userScreen.dart';

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
                  onPressed: () async {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.googleLogin();
                    // await GoogleSignInProvider().googleLogin();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => userScreen()));
                  },
                  child: const Text('Sign in with Google'),
                )));
  }
}
