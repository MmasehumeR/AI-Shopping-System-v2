import 'package:aishop/services/datacollection.dart';
import 'package:aishop/utils/costants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class WishlistServices{
  late final  id, imgUrl, description, name, price, stockamt, category;

  addToCart(id,imgUrl, description, name,
      price,stockamt, category) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("Wishlist")
        .doc(id)
        .set({
      'url': imgUrl,
      'name': name,
      'description': description,
      'price': price,
      'stockamt': stockamt,
      'category' : category
    });
    DataCollection(name, id, price, "wishlist", category).DataCollector();
  }

  removeFromCart(id, imgUrl, description, name,
      price, stockamt, category) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("Wishlist")
        .doc(id)
        .delete();
  }
}