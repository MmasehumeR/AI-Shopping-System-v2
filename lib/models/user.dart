import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const ID = "uid";
  static const BIRTHDAY = "bday";
  static const NAME = "fname";
  static const EMAIL = "email";
  static const SURNAME = "lname";
  static const LOCATION = "location";
  static const PROVINCE = "province";

  late String _birthday;
  late String _name;
  late String _email;
  late String _surname;
  late String _location;
  late String _province;
  late String _id;

//  getters
String get id => _id;
  String get name => _name;
  String get email => _email;
  String get birthday => _birthday;
  String get surname => _surname;
  String get location => _location;
  String get province => _province;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot[NAME];
    _email = snapshot[EMAIL];
    _birthday = snapshot[BIRTHDAY];
    _surname = snapshot[SURNAME];
    _location = snapshot[LOCATION];
    _province = snapshot[PROVINCE];
    // _id = snapshot[ID];
  }
}
