import 'package:cloud_firestore/cloud_firestore.dart';

class NewAddress {
  homeaddress(String address,id) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .collection('info')
        .doc(id)
        .set({
      'HomeAddress': address
    }
        ,SetOptions(merge: true)).then((value){
      //Do your stuff.
    });
  }

  workaddress(String address,id) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .collection('info')
        .doc(id)
        .set({
      'WorkAddress': address
    }
        ,SetOptions(merge: true)).then((value){
      //Do your stuff.
    });
  }
  otheraddress(String name,streetAdd,house,city,province,zipcode,id) {
    String address = name +" , "+ streetAdd +' , '+ house +' , '+ city +' , '+ province +' , '+ zipcode;
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .collection('info')
        .doc(id)
        .set({
      'OtherAddress': address
    }
        ,SetOptions(merge: true)).then((value){
      //Do your stuff.
    });
  }
}