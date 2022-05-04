import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
      body: const MyCustomForm(),
    );
  }
}

enum ImageSourceType { gallery, camera }

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);
  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
  }

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class ImageFromGalleryEx extends StatefulWidget {
  final type;
  ImageFromGalleryEx(this.type);

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState(this.type);
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var imagePicker;
  var type;

  ImageFromGalleryExState(this.type);

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(type == ImageSourceType.camera
              ? "Image from Camera"
              : "Image from Gallery")),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 52,
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
              },
              child: Container(
                width: 200,
                height: 200,
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 230, 217, 217)),
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
    );
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
  }

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  //default rating in the option selector is 1
  String rating = "1";
  String movieName = "";
  String review = "";
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  String _generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  @override
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
                value: rating,
                icon: const Icon(Icons.arrow_downward, color: Colors.white),
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
                    child: Text(value, style: TextStyle(color: Colors.blue)),
                  );
                }).toList(),
              )
            ],
          ),
          Row(
            children: [
              MaterialButton(
                color: Color.fromARGB(255, 70, 70, 70),
                child: Text(
                  "Pick Image from Gallery",
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _handleURLButtonPress(context, ImageSourceType.gallery);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
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
                    "review": review
                  };

                  final userReview = <String, dynamic>{
                    "user": user.displayName,
                    "rating": int.parse(rating),
                    "movie": movieName,
                    "review": review
                  };

                  final movieReview = <String, dynamic>{
                    "user": user.displayName,
                    "uid": user.uid,
                    "rating": int.parse(rating),
                    "review": review,
                  };

                  final ratingReview = <String, dynamic>{
                    "user": user.displayName,
                    "uid": user.uid,
                    "movie": movieName,
                    "review": review
                  };

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
                          ScaffoldMessenger.of(context).clearSnackBars();
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/", (Route<dynamic> route) => false);
                        });
                      });
                    });
                  }).catchError((e) {
                    print(e);
                  });
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
