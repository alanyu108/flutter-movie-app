class MovieModel {
  MovieModel(
      {required this.uid,
      required this.review,
      required this.rating,
      required this.user,
      required this.picUrl});

  String uid;
  String review;
  int rating;
  String user;
  String picUrl;

  factory MovieModel.fromList(Object? dbData) {
    List<dynamic> reviewData = [];
    final data = Map<Object?, Object?>.from(dbData as Map<Object?, Object?>);
    data.forEach((_, value) {
      reviewData.add(value);
    });

    return MovieModel(
        uid: reviewData[0],
        review: reviewData[1],
        rating: reviewData[2],
        user: reviewData[3],
        picUrl: reviewData[4]);
  }
}
