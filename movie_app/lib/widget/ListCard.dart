import 'package:flutter/material.dart';

abstract class ListCard<T> {
  ListCard();

  //defines how each card element should look like
  Widget createCard(T cardItem);

  //defines how the list of cards should look like
  Widget createListCards(Future<List<T>> items) {
    return Center(
        child: FutureBuilder<List<T>>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    margin: const EdgeInsets.all(15.0),
                    // padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        // border: Border.all(color: Colors.redAccent),
                        color: const Color(0xFFF5FDFF)),
                    child: Row(children: [
                      Flexible(
                        child: createCard(snapshot.data![index]),
                      ),
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
