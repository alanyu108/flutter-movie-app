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

  factory MovieReviewModel.fromList(Object? dbData) {
    List<dynamic> reviewData = [];
    final data = Map<Object?, Object?>.from(dbData as Map<Object?, Object?>);
    data.forEach((_, value) {
      reviewData.add(value);
    });

    return MovieReviewModel(
      uid: reviewData[0],
      movie: reviewData[1],
      review: reviewData[2],
      rating: reviewData[3],
      user: reviewData[4],
    );
  }
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
