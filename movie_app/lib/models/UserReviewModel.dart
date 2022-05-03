class UserReviewModel {
  UserReviewModel({
    required this.user,
    required this.rating,
    required this.movie,
    required this.review,
  });

  String user;
  String movie;
  String review;
  int rating;

  factory UserReviewModel.fromList(Object? dbData) {
    List<dynamic> reviewData = [];
    final data = Map<Object?, Object?>.from(dbData as Map<Object?, Object?>);
    data.forEach((_, value) {
      reviewData.add(value);
    });

    return UserReviewModel(
      movie: reviewData[0],
      review: reviewData[1],
      rating: reviewData[2],
      user: reviewData[3],
    );
  }
}
