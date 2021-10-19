import 'package:aishop/models/user_model.dart';
import 'package:aishop/services/databasemanager.dart';
import 'package:aishop/services/networking.dart';
import 'package:aishop/services/user_service.dart';
import 'package:aishop/utils/authentication.dart';
import 'package:aishop/utils/costants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider extends ChangeNotifier {
  late User _user;
  Status _status = Status.Uninitialized;
  UserServices _userServices = UserServices();
  late UserModel _userModel;
  bool _isEditingEmail = false;
  bool _isEditingpassword = false;
  String longitude = "";
  String latitude = "";
  String Province = "";
  String cityname = "";
  String dropdownvalue = " ";
  String loginStatus = "";

  //  getter
  UserModel get userModel => _userModel;
  Status get status => _status;
  User get user => _user;
  bool get isEditingEmail => _isEditingEmail;
  bool get isEditingPassword => _isEditingpassword;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController forgotPassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController birthday = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController province = TextEditingController();

  Future<User?> signInWithEmailPassword() async {
    await Firebase.initializeApp();
    User? user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      _status = Status.Authenticating;
      notifyListeners();
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      user = userCredential.user;

      if (user != null) {
        uid = user.uid;
        userEmail = user.email;

        // SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('auth', true);

        await firebaseFiretore
            .collection('Users')
            .doc(uid)
            .collection('info')
            .doc(uid)
            .get()
            .then((DocumentSnapshot ds) =>
                {location = ds.get('location'), province = ds.get('province')});
      }
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return user;
  }

  Future<User?> registerWithEmailPassword() async {
    await Firebase.initializeApp();
    User? user;

    try {
      _status = Status.Authenticating;
      notifyListeners();
      await auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('auth', true);
        _userServices.createUser(
            id: result.user!.uid,
            name: name.text.trim(),
            surname: surname.text.trim(),
            email: email.text.trim(),
            birthday: birthday.text.trim(),
            province: province.text.trim(),
            location: location.text.trim());
        // return true;
      });

      // user = userCredential.user;

      // if (user != null) {
      //   uid = user.uid;
      //   userEmail = user.email;
      // }

    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('An account already exists for that email.');
      }
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e);
    }

    notifyListeners();
    return user;
  }

//   Future<User?> signInWithGoogle(loc, prov) async {
//   // Initialize Firebase
//   await Firebase.initializeApp();
//   User? user;

//   location = loc;
//   province = prov;

//   // The `GoogleAuthProvider` can only be used while running on the web
//   // GoogleAuthProvider authProvider = GoogleAuthProvider();

//   try {
//     final UserCredential userCredential =
//     await auth.signInWithPopup(googleAuthProvider);

//     user = userCredential.user;
//   } catch (e) {
//     print(e);
//   }

//   if (user != null) {
//     uid = user.uid;
//     name = user.displayName as TextEditingController;
//     userEmail = user.email;
//     imageUrl = user.photoURL;

//     FirebaseFirestore.instance
//         .collection('Users')
//         .doc(uid).collection('info').doc(uid).get()
//         .then((DocumentSnapshot documentSnapshot) =>
//     {
//       if(!documentSnapshot.exists){
//         print("user added"),
//         FirebaseFirestore.instance.collection('Users').doc(uid).collection("info").doc(uid).set(
//             {
//               'fname': name!.split(" ")[0],
//               'lname':name!.split(" ")[1],
//               'email':userEmail,
//               'bday':"*missing",
//               'location': location,
//               'province' : province
//             }
//         )
//       }
//       else{
//         print("user exists in database")
//       }
//     });

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('auth', true);
//   }

//   return user;
// }

  String? validateEmail(String value) {
    value = value.trim();
    // validate the email input that the usr gives.
    if (email.text.isNotEmpty) {
      if (value.isEmpty) {
        notifyListeners();
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        notifyListeners();
        return 'Enter a correct email address';
      }
    }
    notifyListeners();
    return null;
  }

  String? validatePassword(String value) {
    value = value.trim();
    //makesure user creates a strong password
    if (password.text.isNotEmpty) {
      if (value.isEmpty) {
        notifyListeners();
        return 'Please enter password';
      }
    }
    notifyListeners();
    return null;
  }

  String? svalidatePassword(String value) {
    value = value.trim();
    //check user enters a strong enough password.
    if (password.text.isNotEmpty) {
      if (value.isEmpty) {
        notifyListeners();
        return 'Please enter password';
      } else {
        if (!value.contains(new RegExp(r'[0-9]'))) {
          notifyListeners();
          return ' Password must contain atleast one digit ';
        }

        if (!value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
          notifyListeners();
          return 'Password must contain at least on special character';
        }
        if (!value.contains(new RegExp(r'[a-z]'))) {
          notifyListeners();
          return 'Password must contain at least one lower case letter';
        }

        if (!value.contains(new RegExp(r'[A-Z]'))) {
          notifyListeners();
          return 'Password must contain at least one upper case letter';
        }
      }
    }
    notifyListeners();
    return null;
  }

  String? checkRepeatedPassword(String value) {
    value = value.trim();
//check that passwords are matching.
    if (password.text.isNotEmpty) {
      if (confirmPassword.text != password.text) {
        notifyListeners();
        return 'Passwords do not match';
      } else {
        notifyListeners();
        return 'Password Confirmed';
      }
    }
    notifyListeners();
    return null;
  }

  void editsEmail() {
    _isEditingEmail = true;
    notifyListeners();
  }

  void editsPassword() {
    _isEditingpassword = true;
    notifyListeners();
  }

  void clearController() {
    name.text = "";
    password.text = "";
    forgotPassword.text = "";
    email.text = "";
  }

  void getLocationData() async {
    print("running location data function");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    print("done with Geolocator+${position.longitude}");
    longitude = position.longitude.toString();
    latitude = position.latitude.toString();
    NetworkHelper networkHelper = await NetworkHelper(
        'http://api.positionstack.com/v1/reverse?access_key=5e65a2bf717cff420bade43bf75f0cec&query=$latitude,$longitude');
    await networkHelper.getData();
    cityname = networkHelper.cityname;
    Province = networkHelper.Province;
    notifyListeners();
  }

  void resetPassword(String email) {
    auth.sendPasswordResetEmail(email: email);
  }

  Future getProducts() async {
    await DatabaseManager().setBooks();
    await DatabaseManager().setClothes();
    await DatabaseManager().setKitchen();
    await DatabaseManager().setShoes();
    await DatabaseManager().setTech();
    notifyListeners();
  }

  _initAuth() async {
    getLocationData();
    getProducts();
    // _isEditingpassword = true;
    // _isEditingEmail = true;
    notifyListeners();
  }

  AuthProvider.init() {
    _initAuth();
  }
}
