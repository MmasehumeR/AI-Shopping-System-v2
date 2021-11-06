
import 'package:aishop/utils/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void addToOrders() {
  DateTime now = new DateTime.now();
  DateTime date =
      new DateTime(now.year, now.month, now.day, now.hour, now.minute);

  FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Cart')
      .get()
      .then((snapshots) => {
            snapshots.docs.forEach((productid) {
              FirebaseFirestore.instance
                  .collection('Orders')
                  .doc(uid)
              .collection('Products')
              .doc(uid)
                  .set({
                'uid' : uid,
                'url': productid.get("url"),
                'name': productid.get("name"),
                'description': productid.get("description"),
                'category': productid.get('category'),
                'unit price': productid.get("price"),
                'total': productid.get("total"),
                'date': date,
                'quantity': productid.get("quantity")
              });
            })
          });
}

void addToOrdersAdmin() async{
  DateTime now = new DateTime.now();
  DateTime date =
  new DateTime(now.year, now.month, now.day, now.hour, now.minute);

  await FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Cart')
      .get()
      .then((snapshots) => {
    snapshots.docs.forEach((productid) {
      FirebaseFirestore.instance
          .collection('Torders')
          .doc(uid)
          .collection('Products')
          .doc()
          .set({
        'uid' : uid,
        'url': productid.get("url"),
        'name': productid.get("name"),
        'description': productid.get("description"),
        'category': productid.get('category'),
        'unit price': productid.get("price"),
        'total': productid.get("total"),
        'date': date,
        'quantity': productid.get("quantity")
      });
    })
  });

  await FirebaseFirestore.instance
      .collection('Torders')
      .doc(uid)
      .set({
    'date': date,
  });


}