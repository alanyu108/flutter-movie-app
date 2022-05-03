import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/MovieReviewModel.dart';
import 'ListCard.dart';

class buildMovieReviewList extends ListCard<MovieReviewModel> {
  @override
  Widget createCard(MovieReviewModel cardItem) {
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
      Text(cardItem.user)
    ]);
  }
}

class MovieReviewList extends StatefulWidget {
  const MovieReviewList({Key? key}) : super(key: key);

  @override
  State<MovieReviewList> createState() => _MovieReviewListState();
}

class _MovieReviewListState extends State<MovieReviewList> {
  late Future<List<MovieReviewModel>> movieReviews;
  final ref = FirebaseDatabase.instance.ref();

  Future<List<MovieReviewModel>> _fetchMovieData() async {
    final snapshot = await ref.child('movie_reviews/').get();
    List<MovieReviewModel> movieReviews = [];

    if (snapshot.exists) {
      final data =
          Map<Object?, Object?>.from(snapshot.value as Map<Object?, Object?>);

      data.forEach((_, value) {
        movieReviews.add(MovieReviewModel.fromList(value));
      });
    } else {
      print('No data available.');
    }

    return movieReviews;
  }

  @override
  void initState() {
    super.initState();
    movieReviews = _fetchMovieData();
  }

  @override
  Widget build(BuildContext context) {
    return buildMovieReviewList().createListCards(movieReviews);
  }
}