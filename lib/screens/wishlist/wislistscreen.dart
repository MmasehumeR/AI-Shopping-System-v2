import 'package:aishop/styles/theme.dart';
import 'package:aishop/utils/costants.dart';
import 'package:aishop/widgets/appbar/appbar.dart';
import 'package:aishop/widgets/wishlist_model/wishlist_product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: MyAppBar(
        title: Text(
          'My Wish List',
        ),
        context: context,
      ),
      body: new StreamBuilder<QuerySnapshot>(
        stream: wishlistRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueGrey,
              ),
            );
          } else {
            return new ListView.builder(
              itemBuilder: (context, index) {
                return wishlistModel(
                  cartid: snapshot.data!.docs[index].id,
                  prodname: snapshot.data!.docs[index].get('name'),
                  prodpicture: snapshot.data!.docs[index].get('url'),
                  proddescription:
                      snapshot.data!.docs[index].get('description'),
                  prodprice: snapshot.data!.docs[index].get('price').toString(),
                  stockamt: snapshot.data!.docs[index].get('stockamt'),
                );
              },
              itemCount: snapshot.data!.docs.length,
            );
          }
        },
      ),
    );
  }

  etdata() async {
    return wishlistRef;
  }
}

// ignore: camel_case_types
