import 'package:aishop/models/user_model.dart';
import 'package:aishop/utils/costants.dart';

class UserServices {
  String usersCollection = "TestUsers";
  // String usersCollection = "Users";

  void createUser({
    required String id,
    required String name,
    required String surname,
    required String email,
    required String birthday,
    required String province,
    required String location,
  }) {
    firebaseFiretore.collection(usersCollection).doc(id).collection("info")
                                            .doc(id).set({
      "fname": name,
      'lname': surname,
      'bday' : birthday,
      "email": email,
      'location': location,
      'province' : province,

    });
  }

  void updateUserData(Map<String, dynamic> values) {
    firebaseFiretore
        .collection(usersCollection)
        .doc(values['id'])
        .update(values);
  }

  Future<UserModel> getAdminById(String id) =>
      firebaseFiretore.collection(usersCollection).doc(id).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });

  // Future<List<UserModel>> getAllUsers() async =>
  //     firebaseFiretore.collection(usersCollection).get().then((result) {
  //       List<UserModel> users = [];
  //       for (DocumentSnapshot user in result.docs) {
  //         users.add(UserModel.fromSnapshot(user));
  //       }
  //       return users;
  //     });
}
