import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/models/UserReviewModel.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widget/ListCard.dart';
import '../models/MovieModel.dart';

class buildMovieReviewList extends ListCard<MovieModel> {
  buildMovieReviewList({required this.context, required this.movie});

  BuildContext context;
  final String movie;

  @override
  Widget createCard(MovieModel cardItem) {
    return Row(children: [
      // Text(
      //   "Movie:",
      //   // style: TextStyle(
      //   //   decoration: TextDecoration.underline,
      //   // style: GoogleFonts.kaiseiTokumin(fontSize: 24),
      Image.network(cardItem.picUrl, height: 222),
      Padding(padding: EdgeInsets.all(4)),
      Flexible(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          movie,
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
        // Padding(padding: EdgeInsets.only(bottom: 8)),
        // Container(
        //   alignment: Alignment(0.0, -1.0),
        // ),
        Text('-' + cardItem.user),
      ] //children
                  ))
    ] //children
        );
  }
}

class MovieScreen extends StatefulWidget {
  const MovieScreen({Key? key, required this.movie}) : super(key: key);

  final String movie;

  @override
  _MovieScreen createState() => _MovieScreen();
}

class _MovieScreen extends State<MovieScreen> {
  late Future<List<MovieModel>> movieReviewsByMovie;
  final ref = FirebaseDatabase.instance.ref();

  Future<List<MovieModel>> _fetchMovieDataByMovie() async {
    final snapshot = await ref.child('movies/${widget.movie}/').get();
    List<MovieModel> movieReviews = [];

    if (snapshot.exists) {
      final data =
          Map<Object?, Object?>.from(snapshot.value as Map<Object?, Object?>);

      data.forEach((_, value) {
        movieReviews.add(MovieModel.fromList(value));
      });
    } else {
      print('No data available.');
    }
    return movieReviews;
  }

  @override
  void initState() {
    super.initState();
    movieReviewsByMovie = _fetchMovieDataByMovie();
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
              child: Text("Movie: ${widget.movie}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ))),
          Expanded(
            child: buildMovieReviewList(context: context, movie: widget.movie)
                .createListCards(movieReviewsByMovie),
          )
        ],
      ),
    );
  }
}
