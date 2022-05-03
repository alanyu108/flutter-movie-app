import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_app/screens/signInScreen.dart';
import 'homepage.dart';
import 'firebase_options.dart'; // generated via `flutterfire` CLI
import 'screens/addReviewScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(),
        "/login": (context) => const SignInScreen(),
        "/review": (context) => reviewScreen(),
      },
    );
  }
}
