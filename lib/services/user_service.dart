import 'package:aishop/models/user.dart';
import 'package:aishop/utils/costants.dart';

class UserServices {
  String usersCollection = "TestUsers";

  void createUser({
    required String id,
    required String name,
    required String surname,
    required String email,
    required String birthday,
    required String province,
    required String location,
  }) {
    firebaseFiretore
        .collection(usersCollection)
        .doc(id)
        .collection("info")
        .doc(id)
        .set({
      "fname": name,
      'lname': surname,
      'bday': birthday,
      "email": email,
      'location': location,
      'province': province,
    });
  }

  void updateUserData(Map<String, dynamic> values) {
    firebaseFiretore
        .collection(usersCollection)
        .doc(values['id'])
        .update(values);
  }

  Future<UserModel> getUserById(String id) => firebaseFiretore
          .collection(usersCollection)
          .doc(id)
          .collection("info")
          .doc(id)
          .get()
          .then((doc) {
        return UserModel.fromSnapshot(doc);
      });
}
