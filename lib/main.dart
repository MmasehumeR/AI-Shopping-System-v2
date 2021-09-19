import 'package:aishop/screens/homepage/homepage.dart';
import 'package:aishop/screens/login/loginscreen.dart';
import 'package:aishop/utils/authentication.dart';
import 'package:aishop/widgets/recommendations/recommendations.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

String recommendationsList = '';

class _MyAppState extends State<MyApp> {
  bool auto = false;

  void initState() {
    getUserInfo();
    super.initState();
  }

  /* Future<String> loadAsset() async {
  }
*/
//check if user is already logged in in the previous session.
  //get user info if logged in.
  Future getUserInfo() async {
    recommendationsList = await rootBundle.loadString(
        '../../assets/DecisionTreeOutputs/final_recommendations.csv');

    await getUser();
    setState(() {
      if (uid != null) {
        auto = true;
      }
    });
    // print(myData);
    print(uid);
  }

  //remove debug banner in the corner
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: auto == false ? LoginScreen() : HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
