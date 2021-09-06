import 'package:aishop/styles/theme.dart';
import 'package:aishop/widgets/product_model/product_model.dart';
import 'package:aishop/widgets/tech/tech.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tech ...', (tester) async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('Users').doc('1').collection('Cart').add({
      'url':
          'https://cdn.shopify.com/s/files/1/0089/4602/4553/products/womens-consuela-sneaker-charcoal-aqua-yellow-sneakers-soviet_1000x.jpg?v=1615001507',
      'name': "Soviet Consuela Sneaker - Women",
      'description':
          'Elevate your street wear looks with the trendy Soviet Sneaker',
      'price': 250,
      'quantity': 1,
      'stockamt': 356,
      'total': 250,
      'category' : 'Tech'
    });

    await tester.pumpWidget(Container(
        width: 0,
        height: 400,
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection("Products")
              .where("category", isEqualTo: "Tech")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
            return SizedBox(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(grey),
                backgroundColor: lightgrey,
              ),
            );
          }else{
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
                    snapshot.data!.docs[index].get('name').toString(),
                    snapshot.data!.docs[index].get('description'),
                    snapshot.data!.docs[index].get('price'),
                    snapshot.data!.docs[index].get('stockamt'));
              },
              itemCount: snapshot.data!.docs.length,
            );
          }
          
        },
        )
        )
        );
  });
}
