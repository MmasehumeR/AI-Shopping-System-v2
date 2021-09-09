import 'package:aishop/utils/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void addToPurchases() {
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
                  .collection('Users')
                  .doc(uid)
                  .collection('Purchases')
                  .doc(productid.id)
                  .get()
                  .then((snapshot) => {
                        if (snapshot.data() == null || !snapshot.exists)
                          {
                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(uid)
                                .collection("Purchases")
                                .doc(productid.id)
                                .set({
                              'url': productid.get("url"),
                              'name': productid.get("name"),
                              'description': productid.get("description"),
                              'unit price': productid.get("price"),
                              'total': productid.get("total"),
                              'date': date,
                              'qquantity': productid.get("quantity")
                            }),

                            FirebaseFirestore.instance
                                .collection('Products')
                                .doc(productid.id)
                                .get()
                                .then((prodshot) {
                              FirebaseFirestore.instance
                                  .collection('Products')
                                  .doc(productid.id)
                                  .update({
                                'Purchased by': FieldValue.increment(1),
                                'date': date
                              });
                            })
                          }
                        else
                          {

                            FirebaseFirestore.instance
                                .collection('Products')
                                .doc(productid.id)
                                .get()
                                .then((prodshot) {
                              FirebaseFirestore.instance
                                  .collection('Products')
                                  .doc(productid.id)
                                  .update({
                                'Purchased by': FieldValue.increment(1),
                                'date': date
                              });
                            })
                          },
                        productid.reference.delete()
                      });
            })
          });
}
