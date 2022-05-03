import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/MovieReviewModel.dart';

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
    return Center(
        child: FutureBuilder<List<MovieReviewModel>>(
      future: movieReviews,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Movie:",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Text(snapshot.data![index].movie),
                          const Text(
                            "Rating:",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Text(snapshot.data![index].rating.toString()),
                          const Text(
                            "Review:",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Text(snapshot.data![index].review),
                          const Text(
                            "By:",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Text(snapshot.data![index].user),
                          const Padding(padding: EdgeInsets.all(8.0))
                        ]));
              });
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    ));
  }
}
