import 'dart:math';
import 'package:aishop/styles/theme.dart';
import 'package:aishop/utils/authentication.dart';
import 'package:aishop/widgets/product_model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aishop/main.dart';
import 'dart:convert';
import 'dart:core';

class Recommendations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Recommendations();
  }
}

class _Recommendations extends State<Recommendations> {
  @override
  Widget build(BuildContext context) {
    StringBuffer sb = new StringBuffer();

    sb.write(recommendationsList);
    String text = sb.toString();

    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(text);

    var filteredList = lines.where((f) => f.contains(uid.toString())).toList();

    var recommendations = [];

    for (var UserProductList in filteredList) {
      var product = UserProductList.split("|");
      recommendations.add(product[0]);
    }
    print(recommendations);

    if (recommendations.isEmpty) {
      return Text("No Recommendations yet");
    } else {
      return Container(
        width: 0,
        height: 400,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Products")
              .where("id", whereIn: recommendations)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(grey),
                  backgroundColor: lightgrey,
                ),
              );
            } else {
              return GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 2,
                    mainAxisSpacing: 0),
                itemBuilder: (context, index) {
                  return ProductCard(
                      snapshot.data!.docs[index].id,
                      snapshot.data!.docs[index].get('url'),
                      snapshot.data!.docs[index].get('name'),
                      snapshot.data!.docs[index].get('description'),
                      snapshot.data!.docs[index].get('price'),
                      snapshot.data!.docs[index].get('stockamt'));
                },
                itemCount: snapshot.data!.docs.length,
              );
            }
          },
        ),
      );
    }
  }

  List<DocumentSnapshot> randoms(List<DocumentSnapshot> MostPurchased) {
    List<DocumentSnapshot> randomized = [];
    for (var i = 0; i < MostPurchased.length; i++) {
      var cat = MostPurchased[i].get("category");
      Stream<QuerySnapshot> stream = FirebaseFirestore.instance
          .collection("Products")
          .where("category", isEqualTo: cat)
          .snapshots();
      stream.forEach((element) {
        if (element != null) {
          element.docs..shuffle();
          element.docs..reversed;
          element.docs..shuffle();
          element.docs..shuffle();
          element.docs..reversed;
          element.docs..shuffle();
          final _random = new Random();
          final doc = element.docs[_random.nextInt(element.docs.length)];
          if (randomized.length <= 20) {
            if (randomized.length == 0) {
              randomized.add(doc);
            } else {
              if (!_contains(randomized, doc)) {
                randomized.add(doc);
              }
            }
          }
        }
      });
    }
    return randomized;
  }

  bool _contains(List<DocumentSnapshot> list,
      QueryDocumentSnapshot<Object?> documentSnapshot) {
    var counter = 0;
    var state = false;
    for (var i = 0; i < list.length; i++) {
      if (list[i].data() == documentSnapshot.data()) {
        counter++;
      }
    }
    if (counter > 0) {
      state = true;
    }
    return state;
  }
}
