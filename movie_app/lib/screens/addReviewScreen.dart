import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class reviewScreen extends StatefulWidget {
  const reviewScreen({Key? key}) : super(key: key);

  @override
  _reviewScreenState createState() => _reviewScreenState();
}

class _reviewScreenState extends State<reviewScreen> {
  FirebaseDatabase database = FirebaseDatabase.instance;

  // Future<Map<String, dynamic>> _fetchMovieReivews() async {
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add a review"),
        centerTitle: true,
      ),
      body: Padding(
          padding:
              EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
          child: const MyCustomForm()),
    );
  }
}

enum ImageSourceType { gallery, camera }

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  //default rating in the option selector is 1
  String rating = "1";
  String movieName = "";
  String review = "";
  String picUrl = "";
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  String _generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  var _image;
  var imagePicker;
  var type;

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }

  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            style: TextStyle(fontSize: 18, color: Colors.white),
            decoration: const InputDecoration(
                icon: Icon(Icons.movie, color: Colors.white),
                hintText: "Movie Name",
                hintStyle: TextStyle(color: Colors.white)),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onChanged: (String? newValue) {
              setState(() {
                movieName = newValue!;
              });
            },
          ),
          TextFormField(
            style: TextStyle(fontSize: 18, color: Colors.white),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
                icon: Icon(Icons.edit, color: Colors.white),
                hintText: "Review",
                hintStyle: TextStyle(color: Colors.white)),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onChanged: (String? newValue) {
              setState(() {
                review = newValue!;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(Icons.star, color: Colors.white),
                    ),
                    TextSpan(
                      text: "Rating:",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(5, 0, 5, 0)),
              DropdownButton<String>(
                dropdownColor: Colors.black,
                value: rating,
                icon: const Icon(Icons.arrow_downward,
                    color: Color.fromARGB(255, 255, 255, 255)),
                elevation: 16,
                onChanged: (String? newValue) {
                  setState(() {
                    rating = newValue!;
                  });
                },
                items: <String>['1', '2', '3', '4', '5']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255))),
                  );
                }).toList(),
              )
            ],
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    var source = type == ImageSourceType.camera
                        ? ImageSource.camera
                        : ImageSource.gallery;
                    XFile image = await imagePicker.pickImage(
                        source: source,
                        imageQuality: 50,
                        preferredCameraDevice: CameraDevice.front);

                    setState(() {
                      _image = File(image.path);
                    });
                    await Firebase.initializeApp();

                    Reference reference = FirebaseStorage.instance
                        .ref()
                        .child('movieImages/${Path.basename(_image.path)}');
                    UploadTask uploadTask = reference.putFile(_image);
                    TaskSnapshot snapshot = await uploadTask;
                    picUrl = await snapshot.ref.getDownloadURL();
                    // picUrl = imageUrl;
                    // setState(() {
                    //   picUrl = imageUrl;
                    // });

                    print(picUrl);
                  },
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 230, 217, 217)),
                    child: _image != null
                        ? Image.file(
                            _image,
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.fitHeight,
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 220, 211, 211)),
                            width: 200,
                            height: 200,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 130.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 108, 3, 3),
                  onPrimary: Colors.white,
                  alignment: Alignment.center,
                  textStyle: GoogleFonts.sourceCodePro(
                      fontSize: 14, letterSpacing: 1.2)),
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );

                  String uid = _generateRandomString(16);

                  final reviewData = <String, dynamic>{
                    "user": user.displayName,
                    "uid": user.uid,
                    "rating": int.parse(rating),
                    "movie": movieName,
                    "review": review,
                    "url": picUrl
                  };

                  final userReview = <String, dynamic>{
                    "user": user.displayName,
                    "rating": int.parse(rating),
                    "movie": movieName,
                    "review": review,
                    "url": picUrl
                  };

                  final movieReview = <String, dynamic>{
                    "user": user.displayName,
                    "uid": user.uid,
                    "rating": int.parse(rating),
                    "review": review,
                    "url": picUrl
                  };

                  final ratingReview = <String, dynamic>{
                    "user": user.displayName,
                    "uid": user.uid,
                    "movie": movieName,
                    "review": review,
                    "url": picUrl
                  };

                  // final imageUrl_ = <String, dynamic>{
                  //   "user": user.displayName,
                  //   "uid": user.uid,
                  //   "movie": movieName,
                  //   "review": review,
                  // };

                  ref
                      .child("movie_reviews/${uid}")
                      .set(reviewData)
                      .then((value) {
                    ref
                        .child("user_reviews/${user.uid}/$uid")
                        .set(userReview)
                        .then((value) {
                      ref
                          .child("movies/$movieName/$uid")
                          .set(movieReview)
                          .then((value) {
                        ref
                            .child("ratings/$rating/$uid")
                            .set(ratingReview)
                            .then((value) {
                          // ref
                          //     .child("photos/$imageUrl_/$uid")
                          //     .set(picUrl)
                          //     .then((value) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/", (Route<dynamic> route) => false);
                          // });
                        });
                      });
                    });
                  }).catchError((e) {
                    print(e);
                  });
                }
              },
              child: const Text('SUBMIT'),
            ),
          ),
        ],
      ),
    );
  }
}
