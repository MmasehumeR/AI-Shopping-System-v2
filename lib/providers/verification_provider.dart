import 'dart:async';

import 'package:aishop/navigation/locator.dart';
import 'package:aishop/navigation/routing/route_names.dart';
import 'package:aishop/services/navigation_service.dart';
import 'package:aishop/utils/costants.dart';
import 'package:aishop/widgets/appbar/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationProvider extends ChangeNotifier {
  late User user;
  late Timer timer;

  Future<void> checkVerification() async {
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      locator<NavigationService>().globalNavigateTo(HomeRoute, contxt);
      // Navigator.push(
      //     context, new MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  _initVerify() async {
    user = auth.currentUser!;
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkVerification();
    });
    notifyListeners();
  }

  VerificationProvider.init() {
    _initVerify();
  }
}
