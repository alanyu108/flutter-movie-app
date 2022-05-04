import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/models/UserReviewModel.dart';
import '../models/MovieReviewModel.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widget/ListCard.dart';

class buildMovieReviewList extends ListCard<UserReviewModel> {
  buildMovieReviewList({required this.context});

  BuildContext context;

  @override
  Widget createCard(UserReviewModel cardItem) {
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
      Text(cardItem.user, textAlign: TextAlign.right),
    ]);
  }
}

class AuthorScreen extends StatefulWidget {
  const AuthorScreen({Key? key, required this.review}) : super(key: key);

  final MovieReviewModel review;

  @override
  _AuthorScreen createState() => _AuthorScreen();
}

class _AuthorScreen extends State<AuthorScreen> {
  late Future<List<UserReviewModel>> movieReviewsByAuthor;
  final ref = FirebaseDatabase.instance.ref();

  Future<List<UserReviewModel>> _fetchMovieDataByAuthor() async {
    final snapshot = await ref.child('user_reviews/${widget.review.uid}').get();
    List<UserReviewModel> movieReviews = [];

    if (snapshot.exists) {
      final data =
          Map<Object?, Object?>.from(snapshot.value as Map<Object?, Object?>);

      data.forEach((_, value) {
        movieReviews.add(UserReviewModel.fromList(value));
      });
    } else {
      print('No data available.');
    }
    return movieReviews;
  }

  @override
  void initState() {
    super.initState();
    movieReviewsByAuthor = _fetchMovieDataByAuthor();
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
      body: Column(
        children: [
          Center(
              child: Text("User: ${widget.review.user}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ))),
          Expanded(
            child: buildMovieReviewList(context: context)
                .createListCards(movieReviewsByAuthor),
          )
        ],
      ),
    );
  }
}
