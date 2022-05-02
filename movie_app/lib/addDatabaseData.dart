import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

String randomString(String element) {
  Random random = Random();
  List<String> seperatedElements = element.split(" ");
  return seperatedElements[random.nextInt(seperatedElements.length)];
}

void addDatabaseData() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("movie_reviews/");

  String text =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut tortor pretium viverra suspendisse. Varius duis at consectetur lorem donec. At elementum eu facilisis sed odio morbi quis. Quis ipsum suspendisse ultrices gravida. Est ultricies integer quis auctor elit. Leo urna molestie at elementum eu facilisis sed. Dignissim suspendisse in est ante in nibh mauris cursus mattis. Faucibus et molestie ac feugiat sed lectus vestibulum. Lacinia at quis risus sed. Fringilla urna porttitor rhoncus dolor purus. Ut consequat semper viverra nam libero. Pretium vulputate sapien nec sagittis aliquam malesuada bibendum arcu vitae. Sed egestas egestas fringilla phasellus. Tempor orci eu lobortis elementum nibh tellus molestie nunc non. Et pharetra pharetra massa massa ultricies mi quis hendrerit dolor. Eu sem integer vitae justo eget magna fermentum iaculis. Sit amet facilisis magna etiam tempor orci. Vitae tempus quam pellentesque nec nam aliquam sem et tortor. Nulla facilisi nullam vehicula ipsum a arcu cursus vitae congue.";

  String users = "Alan Dylan Amy Elvis Bob";
  String movies =
      "aliquet nibh praesent tristique magna sit amet purus gravida quis";
  Random random = Random();
  String review = "";
  for (var i = 0; i < 20; i++) {
    review += randomString(text) + " ";
  }

  for (int i = 0; i < 10; i++) {
    await ref.push().set({
      "user": randomString(users),
      "rating": random.nextInt(5) + 1,
      "movie": randomString(movies),
      "review": review
    });
  }
}
