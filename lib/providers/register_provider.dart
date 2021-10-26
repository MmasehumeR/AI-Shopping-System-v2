import 'package:aishop/models/user_model.dart';
import 'package:aishop/navigation/locator.dart';
import 'package:aishop/navigation/routing/route_names.dart';
import 'package:aishop/services/navigation_service.dart';
import 'package:aishop/services/networking.dart';
import 'package:aishop/services/user_service.dart';
import 'package:aishop/utils/costants.dart';
import 'package:aishop/widgets/appbar/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class RegisterProvider with ChangeNotifier {
  late User _user;
  Status _status = Status.Uninitialized;
  UserServices _userServices = UserServices();
  late UserModel _userModel;
  bool _isEditingEmail = true;
  bool _isEditingpassword = false;
  String longitude = "";
  String latitude = "";
  String Province = "";
  String Cityname = "";
  String? Location;
  String? imageUrl;
  String dropdownvalue = " ";
  String loginStatus = "";
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

  Future<bool> registerWithEmailPassword() async {
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
      }).catchError((error) {
        print('Sign in Error: $error');
        loginStatus = 'Error occured while Signing in';
        locator<NavigationService>().globalNavigateTo(LoginRoute, contxt);
      });

      return true;
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('An account already exists for that email.');
      }
      return false;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e);
      return false;
    }
  }

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
    // notifyListeners();
  }

  void editsPassword() {
    _isEditingpassword = true;
    // notifyListeners();
  }

  void clearController() {
    name.text = "";
    surname.text = "";
    password.text = "";
    forgotPassword.text = "";
    confirmPassword.text = "";
    email.text = "";
    province.text = "";
    location.text = "";
    birthday.text = "";
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
    Cityname = networkHelper.cityname;
    Province = networkHelper.Province;
    notifyListeners();
  }

  void resetPassword(String email) {
    auth.sendPasswordResetEmail(email: email);
  }

  _initAuth() async {
    getLocationData();
    // getProducts();
    // _isEditingpassword = true;
    // _isEditingEmail = true;
    notifyListeners();
  }

  RegisterProvider.init() {
    _initAuth();
  }
}
