import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      appBar: AppBar(
        title: const Text("Movie App"),
        centerTitle: true,
      ),
      body: const MyCustomForm(),
    );
  }
}

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
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
                icon: Icon(Icons.movie), labelText: "Movie Name"),
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
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
                icon: Icon(Icons.edit), labelText: "Review"),
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
                      child: Icon(Icons.star),
                    ),
                    TextSpan(
                      text: "Rating:",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(5, 0, 5, 0)),
              DropdownButton<String>(
                value: rating,
                icon: const Icon(Icons.arrow_downward),
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
                    child: Text(value),
                  );
                }).toList(),
              )
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

                  ref
                      .child("movie_reviews/")
                      .push()
                      .set(reviewData)
                      .then((value) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/", (Route<dynamic> route) => false);
                  }).catchError((e) {
                    print(e);
                  });

                  ref
                      .child("${user.uid}/")
                      .push()
                      .set(userReview)
                      .then((value) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/", (Route<dynamic> route) => false);
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
