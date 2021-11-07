import 'package:aishop/models/user.dart';
import 'package:aishop/services/databasemanager.dart';
import 'package:aishop/services/networking.dart';
import 'package:aishop/services/user_service.dart';
import 'package:aishop/utils/costants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {
  User? _user;
  Status _status = Status.Uninitialized;
  UserServices _userServices = UserServices();
  late String location;
  String province = "";
  String cityname = "";
  String longitude = "";
  String latitude = "";
  String loginStatus = "";
  String dropdownvalue = " ";
  UserModel? _userModel;

  User? get user => _user;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController forgotPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController birthday = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController provinceController = TextEditingController();

  var dropDownItems = [
    " ",
    "Limpopo",
    "Gauteng",
    "Free State",
    "Western Cape",
    "KwaZulu-Natal",
    "North West",
    "Northern Cape",
    "Eastern Cape",
    "Mpumalanga"
  ];

  AuthProvider.initialize() {
    _fireSetUp();
    getLocationData();
    getProducts();
  }

  _fireSetUp() async {
    await initialization.then((value) {
      auth.authStateChanges().listen((value) {
        auth.authStateChanges().listen((User? user) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (user == null) {
            _status = Status.Unauthenticated;
          } else {
            _user = user;
            await prefs.setString("id", user.uid);
            uid = user.uid;
            _userModel =
                await _userServices.getUserById(user.uid).then((value) {
              _status = Status.Authenticated;
              return value;
            });
          }
        });
      });
    });
  }

  Future<bool> registerWithEmailPassword() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("id", result.user!.uid);
        _userServices.createUser(
            id: result.user!.uid,
            name: name.text.trim(),
            email: email.text.trim(),
            surname: surname.text.trim(),
            birthday: birthday.text,
            location: locationController.text,
            province: provinceController.text);
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<bool> signInWithGoogle(loc, prov) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await auth.signInWithPopup(googleAuthProvider).then((result) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("id", result.user!.uid);
        if (loc == null || prov == null) {
          _userServices.createUser(
              id: result.user!.uid,
              name: user!.displayName!.split(" ")[0],
              email: email.text.trim(),
              surname: user!.displayName!.split(" ")[1],
              birthday: "*missing",
              location: "*missing",
              province: "*missing");
        } else {
          location = loc;
          province = prov;
          _userServices.createUser(
              id: result.user!.uid,
              name: user!.displayName!.split(" ")[0],
              email: email.text.trim(),
              surname: user!.displayName!.split(" ")[1],
              birthday: "*missing",
              location: location,
              province: province);
        }
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signInWithEmailPassword() async {
    // await Firebase.initializeApp();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      // _status = Status.Authenticating;
      notifyListeners();
      await auth
          .signInWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((value) async {
        await prefs.setString("id", value.user!.uid);
        await firebaseFiretore
            .collection('Users')
            .doc(value.user!.uid)
            .collection('info')
            .doc(value.user!.uid)
            .get()
            .then((DocumentSnapshot ds) =>
                {location = ds.get('location'), province = ds.get('province')});
      });
      return true;
    } catch (e) {
      // _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  String? validateEmail(String value) {
    value = value.trim();

    if (email.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        return 'Enter a correct email address';
      }
    }

    return null;
  }

  String? validatePassword(String value) {
    value = value.trim();
    //makesure user creates a strong password
    if (password.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Please enter password';
      }
    }

    return null;
  }

  String? regValidatePassword(String value) {
    value = value.trim();
    //check user enters a strong enough password.
    if (password.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Please enter password';
      } else {
        if (!value.contains(new RegExp(r'[0-9]'))) {
          return ' Password must contain atleast one digit ';
        }

        if (!value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
          return 'Password must contain at least on special character';
        }
        if (!value.contains(new RegExp(r'[a-z]'))) {
          return 'Password must contain at least one lower case letter';
        }

        if (!value.contains(new RegExp(r'[A-Z]'))) {
          return 'Password must contain at least one upper case letter';
        }
      }
    }

    return null;
  }

  String? checkRepeatedPassword(String value) {
    value = value.trim();
//check that passwords are matching.
    if (confirmPassword.text.isNotEmpty) {
      if (confirmPassword.text != confirmPassword.text) {
        return 'Passwords do not match';
      } else {
        return 'Password Confirmed';
      }
    }
    return null;
  }

  Future getProducts() async {
    await DatabaseManager().setBooks();
    await DatabaseManager().setClothes();
    await DatabaseManager().setKitchen();
    await DatabaseManager().setShoes();
    await DatabaseManager().setTech();
  }
  
  void resetPassword(String email) {
    auth.sendPasswordResetEmail(email: email);
  }

  void getLocationData() async {
    print("running location data function");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    print("done with Geolocator+${position.longitude}");
    longitude = position.longitude.toString();
    latitude = position.latitude.toString();
    NetworkHelper networkHelper = NetworkHelper(
        'http://api.positionstack.com/v1/reverse?access_key=5e65a2bf717cff420bade43bf75f0cec&query=$latitude,$longitude');
    await networkHelper.getData();
    cityname = networkHelper.cityname;
    province = networkHelper.Province;
  }

  void clearController() {
    name.text = "";
    surname.text = "";
    password.text = "";
    email.text = "";
    locationController.text = "";
    provinceController.text = "";
    birthday.text = "";
    forgotPassword.text = "";
    confirmPassword.text = "";
  }
}
