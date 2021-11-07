import 'package:aishop/providers/auth_provider.dart';
import 'package:aishop/screens/homepage/homepage.dart';
import 'package:aishop/screens/signup/registerscreen.dart';
import 'package:aishop/styles/google_round_button.dart';
import 'package:aishop/styles/or_divider.dart';
import 'package:aishop/styles/round_button.dart';
import 'package:aishop/styles/round_passwordfield.dart';
import 'package:aishop/styles/round_textfield.dart';
import 'package:aishop/styles/sidepanel.dart';
import 'package:aishop/styles/textlink.dart';
import 'package:aishop/styles/theme.dart';
import 'package:aishop/styles/title.dart';
import 'package:aishop/utils/authentication.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isEditingEmail = false;
  bool _isEditingpassword = false;

//test keys
  static const notRegisteredTextKey = Key('notRegisteredTextKey');
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context);
    return new Scaffold(
        body: Container(
            width: size.width,
            height: size.height,
            color: lightblack,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                Widget>[
              Expanded(child: SidePanel()),
              Expanded(
                  child: Container(
                      color: white,
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.1,
                          vertical: size.height * 0.1),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //=============================================
                            //heading login
                            PageTitle(
                              text: "LOGIN",
                            ),
                            //=============================================
                            //Email text field
                            RoundTextField(
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              control: authProvider.email,
                              text: "Email",
                              autofocus: false,
                              preicon: Icon(LineIcons.user),
                              onChanged: (value) {
                                setState(() {
                                  _isEditingEmail = true;
                                });
                              },
                              errorText: _isEditingEmail
                                  ? authProvider
                                      .validateEmail(authProvider.email.text)
                                  : "",
                              errorstyle: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            //=============================================
                            //Password text field
                            RoundPasswordField(
                              control: authProvider.password,
                              text: "Password",
                              icon: Icon(LineIcons.key),
                              autofocus: false,
                              onChanged: (value) {
                                setState(() {
                                  _isEditingpassword = true;
                                });
                              },
                              errorText: _isEditingpassword
                                  ? authProvider.validatePassword(
                                      authProvider.password.text)
                                  : "",
                              errorstyle: TextStyle(color: Colors.black54),
                            ),
                            //=============================================
                            //login button
                            RoundButton(
                              text: "LOGIN",
                              press: () async {
                                if (!await authProvider
                                    .signInWithEmailPassword()) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(32.0))),
                                          contentPadding:
                                              EdgeInsets.only(top: 10.0),
                                          content: Container(
                                            width: 300.0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                      "Error has occured",
                                                      style: TextStyle(
                                                          fontSize: 24.0),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                      "Your Password/Email is incorrect",
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          color: Colors.red),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TextButton(
                                                  child: Text('OK',
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                  return;
                                }
                                authProvider.clearController();
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              },
                            ),
                            //=============================================
                            TextLink(
                                text: "Forgot Password?",
                                align: Alignment.centerRight,
                                press: () => {
                                      Alert(
                                          context: context,
                                          title:
                                              "Enter email for password reset",
                                          content: Column(
                                            children: <Widget>[
                                              TextField(
                                                decoration: InputDecoration(
                                                  icon: Icon(LineIcons.user),
                                                  labelText: 'E-mail',
                                                ),
                                                controller:
                                                    authProvider.forgotPassword,
                                              ),
                                            ],
                                          ),
                                          buttons: [
                                            DialogButton(
                                              onPressed: () {
                                                resetPassword(authProvider
                                                    .forgotPassword.text);

                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Send email",
                                                style: TextStyle(
                                                    color: white, fontSize: 20),
                                              ),
                                              color: lightblack,
                                            ),
                                            DialogButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: white, fontSize: 20),
                                              ),
                                              color: lightblack,
                                            )
                                          ]).show(),
                                    }),
                            //=========================================
                            //or dividers
                            OrDivider(),
                            //==========================================
                            //Google sign in button
                            GoogleRoundButton(),
                            //==========================================
                            TextLink(
                                key: notRegisteredTextKey,
                                text: "Not Registered?",
                                align: Alignment.center,
                                press: () => {
                                      print(authProvider.cityname),
                                      Timer(Duration(seconds: 2), () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterScreen(
                                                      cityName: authProvider
                                                          .cityname
                                                          .toString(),
                                                      /*longitude: longitude,
                                                  latitude: latitude,*/
                                                    )));
                                      })
                                    })

                            //=====================================================
                          ])))
            ])));
  }
}
