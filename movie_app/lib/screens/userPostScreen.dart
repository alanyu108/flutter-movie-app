import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/UserReviewModel.dart';
import '../widget/ListCard.dart';

class buildMovieReviewList extends ListCard<UserReviewModel> {
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
      const Padding(padding: EdgeInsets.all(8.0))
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

      data.forEach((_, value) {
        userReviews.add(UserReviewModel.fromList(value));
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
      body: buildMovieReviewList().createListCards(userReviews),
    );
  }
}
