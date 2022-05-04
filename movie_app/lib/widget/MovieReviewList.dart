import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/MovieReviewModel.dart';
import 'ListCard.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/AuthorScreen.dart';

class buildMovieReviewList extends ListCard<MovieReviewModel> {
  buildMovieReviewList({required this.context});

  BuildContext context;

  @override
  Widget createCard(MovieReviewModel cardItem) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Text(
      //   "Movie:",
      //   // style: TextStyle(
      //   //   decoration: TextDecoration.underline,
      //   // style: GoogleFonts.kaiseiTokumin(fontSize: 24),
      // ),
      Text(
        cardItem.movie,
        style: GoogleFonts.kaiseiTokumin(
            fontSize: 26, color: Color.fromARGB(255, 52, 52, 52)),
      ),
      // const Text(
      //   "Rating:",
      //   style: TextStyle(
      //     decoration: TextDecoration.underline,
      //   ),
      // ),
      Text(
        cardItem.rating.toString() + ' stars',
      ),
      // const Text(
      //   "Review:",
      //   style: TextStyle(
      //     decoration: TextDecoration.underline,
      //   ),
      // ),
      Text(cardItem.review),
      // const Text(
      //   "By:",
      //   style: TextStyle(
      //     decoration: TextDecoration.underline,
      //   ),
      // ),
      Padding(padding: EdgeInsets.all(15)),
      // Container(
      //   alignment: Alignment(0.0, -1.0),
      // ),
      GestureDetector(
        child: Text(cardItem.user, textAlign: TextAlign.right),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AuthorScreen(review: cardItem)));
        },
      )
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
    return buildMovieReviewList(context: context).createListCards(movieReviews);
  }
}
