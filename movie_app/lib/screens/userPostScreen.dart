import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/UserReviewModel.dart';
import '../widget/ListCard.dart';

class buildMovieReviewList extends ListCard<UserReviewModel> {
  buildMovieReviewList(this.db, this.uid, this.context);

  DatabaseReference db;
  String uid;
  BuildContext context;

  @override
  Widget createCard(UserReviewModel cardItem) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        "Movie:",
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
      Text(cardItem.movie),
      const Text(
        "Rating:",
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
      Text(cardItem.rating.toString()),
      const Text(
        "Review:",
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
      Text(cardItem.review),
      const Text(
        "By:",
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
      Text(cardItem.user),
      GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Delete Review"),
                content: const Text("Do you want to delete your post?"),
                actions: [
                  TextButton(
                    child: const Text(
                      "No",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: const Text(
                      "Yes",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      db
                          .child("movie_reviews/${cardItem.entry_id}")
                          .remove()
                          .then((value) {
                        db
                            .child("user_reviews/$uid/${cardItem.entry_id}")
                            .remove()
                            .then((value) {
                          db
                              .child(
                                  "movies/${cardItem.movie}/${cardItem.entry_id}")
                              .remove()
                              .then((value) {
                            db
                                .child(
                                    "ratings/${cardItem.rating}/${cardItem.entry_id}")
                                .remove()
                                .then((value) {
                              Navigator.pushNamedAndRemoveUntil(context, "/",
                                  (Route<dynamic> route) => false);
                            });
                          });
                        });
                      }).catchError((e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to Delete Review!')),
                        );
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.delete,
          color: Colors.red,
          size: 30,
        ),
      ),
    ]);
  }
}

class userPostScreen extends StatefulWidget {
  const userPostScreen({Key? key, required this.user, required this.uid})
      : super(key: key);

  final String user;
  final String uid;

  @override
  _userPostScreen createState() => _userPostScreen();
}

class _userPostScreen extends State<userPostScreen> {
  late Future<List<UserReviewModel>> userReviews;
  final ref = FirebaseDatabase.instance.ref();

  Future<List<UserReviewModel>> _fetchUserReviewData() async {
    final snapshot = await ref.child('user_reviews/${widget.uid}').get();
    List<UserReviewModel> userReviews = [];

    if (snapshot.exists) {
      final data =
          Map<Object?, Object?>.from(snapshot.value as Map<Object?, Object?>);

      data.forEach((key, value) {
        UserReviewModel data = UserReviewModel.fromList(value);

        data.setEntryID(key as String);
        userReviews.add(data);
      });
    } else {
      print('No data available.');
    }

    return userReviews;
  }

  @override
  void initState() {
    super.initState();
    userReviews = _fetchUserReviewData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie App"),
        centerTitle: true,
      ),
      body: buildMovieReviewList(ref, widget.uid, context)
          .createListCards(userReviews),
    );
  }
}