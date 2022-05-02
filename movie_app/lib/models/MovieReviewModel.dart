class MovieReviewModel {
  MovieReviewModel({
    required this.uid,
    required this.movie,
    required this.review,
    required this.rating,
    required this.user,
  });

  String uid;
  String movie;
  String review;
  int rating;
  String user;

  factory MovieReviewModel.fromList(List<dynamic> items) => MovieReviewModel(
        uid: items[0],
        movie: items[1],
        review: items[2],
        rating: items[3],
        user: items[4],
      );
  // factory MovieReivewModel.fromJson(Map<String, dynamic> json) =>
  //     MovieReivewModel(
  //       uid: json["uid"],
  //       movie: json["movie"],
  //       review: json["review"],
  //       rating: json["rating"],
  //       user: json["user"],
  //     );

  // Map<String, dynamic> toJson() => {
  //       "uid": uid,
  //       "movie": movie,
  //       "review": review,
  //       "rating": rating,
  //       "user": user,
  //     };
}
