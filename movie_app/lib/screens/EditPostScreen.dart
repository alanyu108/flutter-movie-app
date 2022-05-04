import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/UserReviewModel.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen(
      {Key? key,
      required this.userReview,
      required this.db,
      required this.uid,
      required this.user})
      : super(key: key);

  final UserReviewModel userReview;
  final DatabaseReference db;
  final String uid;
  final String user;

  @override
  _EditPostScreen createState() => _EditPostScreen();
}

class _EditPostScreen extends State<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  String rating = "";
  String movieName = "";
  String review = "";
  bool changeRating = false;
  bool changeMovieName = false;

  @override
  void initState() {
    super.initState();

    rating = widget.userReview.rating.toString();
    movieName = widget.userReview.movie;
    review = widget.userReview.review;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MOVIE APP",
            style: GoogleFonts.libreBarcode39ExtendedText(
              color: Colors.white,
              fontSize: 48,
            )),
      ),
      body: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(children: [
            const Text('Edit Post',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    decoration: TextDecoration.underline)),
            const Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      initialValue: widget.userReview.movie,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.movie, color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.5))),
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
                    const Padding(padding: const EdgeInsets.all(8.0)),
                    TextFormField(
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      initialValue: widget.userReview.review,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.airplay_rounded,
                              color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.5))),

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
                          icon: const Icon(Icons.arrow_downward,
                              color: Colors.white),
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
                                  style: const TextStyle(color: Colors.blue)),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text("Edit Post"),
                                content: const Text(
                                    "Are you sure you want to make these changes?"),
                                actions: [
                                  TextButton(
                                    child: const Text(
                                      "No",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      DatabaseReference dbRef = widget.db;
                                      UserReviewModel user = widget.userReview;
                                      // Validate returns true if the form is valid, or false otherwise.
                                      if (_formKey.currentState!.validate()) {
                                        //check if user had changed any values
                                        if (user.movie == movieName &&
                                            user.review == review &&
                                            user.rating.toString() == rating) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Values were not changed')),
                                          );
                                          Navigator.pop(dialogContext);
                                          return;
                                        }

                                        if (user.movie != movieName) {
                                          changeMovieName = true;
                                        }
                                        if (user.rating.toString() != rating) {
                                          changeRating = true;
                                        }

                                        //  ScaffoldMessenger.of(context).showSnackBar(
                                        //     const SnackBar(content: Text('Processing Data')),
                                        //   );
                                        final reviewData = <String, dynamic>{
                                          "user": widget.user,
                                          "uid": widget.uid,
                                          "rating": int.parse(rating),
                                          "movie": movieName,
                                          "review": review
                                        };

                                        final movieReview = <String, dynamic>{
                                          "user": widget.user,
                                          "uid": widget.uid,
                                          "rating": int.parse(rating),
                                          "review": review,
                                        };

                                        final ratingReview = <String, dynamic>{
                                          "user": widget.user,
                                          "uid": widget.uid,
                                          "movie": movieName,
                                          "review": review
                                        };

                                        final userReview = <String, dynamic>{
                                          "user": widget.user,
                                          "rating": int.parse(rating),
                                          "movie": movieName,
                                          "review": review
                                        };

                                        //updates the movie_reviews db
                                        dbRef
                                            .child(
                                                "movie_reviews/${user.entry_id}/")
                                            .set(reviewData)
                                            .then((_) {
                                          //updates the user_reviews db
                                          dbRef
                                              .child(
                                                  "user_reviews/${widget.uid}/${user.entry_id}")
                                              .set(userReview)
                                              .then((_) {
                                            if (user.review != review &&
                                                !changeMovieName &&
                                                !changeRating) {
                                              dbRef
                                                  .child(
                                                      "movies/${user.movie}/${user.entry_id}")
                                                  .set(movieReview)
                                                  .then((_) {
                                                dbRef
                                                    .child(
                                                        "ratings/${user.rating}/${user.entry_id}")
                                                    .set(ratingReview);
                                              });
                                            }
                                            if (changeMovieName &&
                                                changeRating) {
                                              //removes the entry in the movie db
                                              dbRef
                                                  .child(
                                                      "movies/${user.movie}/${user.entry_id}")
                                                  .set(null)
                                                  .then((value) {
                                                //adds a new entry into the movie db
                                                dbRef
                                                    .child(
                                                        "movies/$movieName/${user.entry_id}")
                                                    .set(movieReview)
                                                    .then((value) {
                                                  //removes the review from the rating db
                                                  dbRef
                                                      .child(
                                                          "ratings/${user.rating}/${user.entry_id}")
                                                      .set(null)
                                                      .then((value) {
                                                    //adds the new entry to the updated rating value
                                                    dbRef
                                                        .child(
                                                            "ratings/$rating/${user.entry_id}")
                                                        .set(ratingReview)
                                                        .then((value) {
                                                      Navigator
                                                          .pushNamedAndRemoveUntil(
                                                              context,
                                                              "/",
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false);
                                                    });
                                                  });
                                                });
                                              });
                                            } else if (changeMovieName ==
                                                true) {
                                              //removes the entry in the movie db
                                              dbRef
                                                  .child(
                                                      "movies/${user.movie}/${user.entry_id}")
                                                  .set(null)
                                                  .then((value) {
                                                //adds a new entry into the movie db
                                                dbRef
                                                    .child(
                                                        "movies/$movieName/${user.entry_id}")
                                                    .set(movieReview)
                                                    .then((value) {
                                                  dbRef
                                                      .child(
                                                          "ratings/${user.rating}/${user.entry_id}")
                                                      .set(ratingReview)
                                                      .then((value) {
                                                    Navigator
                                                        .pushNamedAndRemoveUntil(
                                                            context,
                                                            "/",
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                  });
                                                });
                                              });
                                            } else if (changeRating == true) {
                                              //removes the review from the rating db
                                              dbRef
                                                  .child(
                                                      "ratings/${user.rating}/${user.entry_id}")
                                                  .set(null)
                                                  .then((value) {
                                                //adds the new entry to the updated rating value
                                                dbRef
                                                    .child(
                                                        "ratings/$rating/${user.entry_id}")
                                                    .set(ratingReview)
                                                    .then((value) {
                                                  dbRef
                                                      .child(
                                                          "movies/${user.movie}/${user.entry_id}")
                                                      .set(movieReview)
                                                      .then((value) {
                                                    Navigator
                                                        .pushNamedAndRemoveUntil(
                                                            context,
                                                            "/",
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                  });
                                                });
                                              });
                                            } else {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  "/",
                                                  (Route<dynamic> route) =>
                                                      false);
                                            }
                                          });
                                        });
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Submit'),
                      ),
                    )
                  ],
                ))
          ])),
    );
  }
}
