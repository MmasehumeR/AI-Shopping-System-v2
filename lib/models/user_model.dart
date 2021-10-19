import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const ID = "uid";
  static const NAME = "fname";
  static const EMAIL = "email";
  static const SURNAME = "lname";
  static const LOCATION = "lname";
  static const PROVINCE = "lname";

  late String _id;
  late String _name;
  late String _email;
  late String _surname;
  late String _location;
  late String _province;

//  getters
  String get name => _name;
  String get email => _email;
  String get id => _id;
  String get surname => _surname;
  String get location => _location;
  String get province => _province;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot[NAME];
    _email = snapshot[EMAIL];
    _id = snapshot[ID];
    _surname = snapshot[SURNAME];
    _location = snapshot[LOCATION];
    _province = snapshot[PROVINCE];
  }
}
