import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_app/screens/signInScreen.dart';
import 'homepage.dart';
import 'firebase_options.dart'; // generated via `flutterfire` CLI
import 'screens/addReviewScreen.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

const MaterialColor kPrimaryColor = const MaterialColor(
  0x0000000,
  const <int, Color>{
    50: const Color(0x0000000),
    100: const Color(0x0000000),
    200: const Color(0x0000000),
    300: const Color(0x0000000),
    400: const Color(0x0000000),
    500: const Color(0x0000000),
    600: const Color(0x0000000),
    700: const Color(0x0000000),
    800: const Color(0x0000000),
    900: const Color(0x0000000),
  },
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 0, 0, 0),
          primarySwatch: kPrimaryColor,
          textTheme: GoogleFonts.interTextTheme()
              .apply(bodyColor: Color.fromARGB(255, 91, 91, 91))),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(),
        "/login": (context) => const SignInScreen(),
        "/review": (context) => reviewScreen(),
      },
    );
  }
}
