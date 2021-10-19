import 'package:aishop/utils/authentication.dart';
import 'package:aishop/utils/costants.dart';
import 'package:aishop/widgets/appbar/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  late TextEditingController userEmailController = TextEditingController();
  late TextEditingController userFirstNameController = TextEditingController();
  late TextEditingController userLastNameController = TextEditingController();
  late TextEditingController userBirthdayController = TextEditingController();
  late TextEditingController userLocationController = TextEditingController();
  late FocusNode textFocusNodeBirthday = FocusNode();
  late FocusNode textFocusNodeLocation = FocusNode();
  bool _displayFNameValid = true;
  bool _displayLNameValid = true;

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
              userFirstNameController.text = documentSnapshot.get("fname"),
              userLastNameController.text = documentSnapshot.get("lname"),
              userEmailController.text = documentSnapshot.get("email"),
              userBirthdayController.text = documentSnapshot.get("bday"),
              userLocationController.text = documentSnapshot.get("location"),
              notifyListeners()
              // })
            }
        });
    notifyListeners();
  }

  updateProfileData() {
    // setState(() {
    userFirstNameController.text.isEmpty
        ? _displayFNameValid = false
        : _displayFNameValid = true;
    userLastNameController.text.isEmpty
        ? _displayLNameValid = false
        : _displayLNameValid = true;

    if (_displayFNameValid && _displayLNameValid) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('info')
          .doc(uid)
          .update({
        'fname': userFirstNameController.text,
        'lname': userLastNameController.text,
        'bday': userBirthdayController.text,
      });

      if (userLocationController.text.isEmpty) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('info')
            .doc(uid)
            .update({'location': "*missing"});
      } else {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('info')
            .doc(uid)
            .update({'location': userLocationController.text});
      }
    }
    // });
    notifyListeners();
    SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
    ScaffoldMessenger.of(contxt).showSnackBar(snackbar);
  }

  _initData() async {
    getUserInfofromdb();
    notifyListeners();
  }

  ProfileProvider.init() {
    _initData();
  }
}
