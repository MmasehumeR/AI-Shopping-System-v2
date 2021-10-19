import 'package:aishop/utils/costants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CheckoutAdressProvider with ChangeNotifier {
  late TextEditingController userLocationController = TextEditingController();
  late String UsedAddress;
  late String HomeAddress;
  late String WorkAddress;

  String? get uid => null;

  Future getUserInfofromdb() async {
    // FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference _collectionReference =
        firebaseFiretore.collection("Users");
    DocumentReference _doc = _collectionReference.doc(uid);
    DocumentReference _documentReference = _doc.collection("info").doc(uid);

    _documentReference.get().then((documentSnapshot) => {
          if (!documentSnapshot.exists)
            {
              print("Sorry, User profile not found."),
            }
          else
            {
              // setState(() {
              userLocationController.text = documentSnapshot.get("location")
              // })
            }
        });
    notifyListeners();
  }

  _initData() async {
    getUserInfofromdb();
    notifyListeners();
  }

  CheckoutAdressProvider.init() {
    _initData();
  }
}
