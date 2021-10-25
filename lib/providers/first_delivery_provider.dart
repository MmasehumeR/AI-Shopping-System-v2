import 'package:aishop/utils/costants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirstDeliveryProvider extends ChangeNotifier{
   late TextEditingController location = TextEditingController();
   late String name, streetAdd, house, city, province, zipcode;
  
  Future getUserInfofromdb() async {
    CollectionReference _collectionReference = firebaseFiretore.collection("Users");
    DocumentReference _doc = _collectionReference.doc(uid);
    DocumentReference _documentReference = _doc.collection("info").doc(uid);

    _documentReference.get().then((documentSnapshot) => {
          if (!documentSnapshot.exists)
            {
              print("Sorry, User profile not found."),
              notifyListeners()
            }
          else
            {

                location.text = documentSnapshot.get("location"),
                notifyListeners()

            }
        });
  }

  _initDelivery() async {
    getUserInfofromdb();
    notifyListeners();
  }

  FirstDeliveryProvider.init() {
    _initDelivery();
  }

}