//this class is used to design the google button with a white background and a black border

import 'package:aishop/navigation/locator.dart';
import 'package:aishop/navigation/routing/route_names.dart';
import 'package:aishop/providers/auth_provider.dart';
import 'package:aishop/services/navigation_service.dart';
import 'package:aishop/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoogleRoundButton extends StatelessWidget {
  late final text;
  late final press;
  late final Color color, textColor;
  late final icon;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final AuthProvider signin = Provider.of<AuthProvider>(context);
    return Container(
        height: 50,
        width: size.width,
        child: ElevatedButton(
          child: Text('Sign in with Google'),
          style: ElevatedButton.styleFrom(
              onPrimary: black,
              primary: white,
              textStyle: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w900),
              side: BorderSide(color: black, width: 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100))),
          onPressed: () async {
            await signin.signInWithGoogle().then((result) {
              // if (result != null) {
              locator<NavigationService>().globalNavigateTo(HomeRoute, context);
              // Navigator.push(
              //   context,
              //   new MaterialPageRoute(builder: (context) => HomePage()),
              // );
              // }
            }).catchError((error) {
              print('Registration Error: $error');
            });
          }, //login button on pressed
        ));
  }
}
