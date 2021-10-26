import 'package:aishop/navigation/locator.dart';
import 'package:aishop/navigation/routing/route_names.dart';
import 'package:aishop/providers/register_provider.dart';
import 'package:aishop/services/navigation_service.dart';
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
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final RegisterProvider regProvider = Provider.of<RegisterProvider>(context);
    return Scaffold(
        body: Container(
            width: size.width,
            height: size.height,
            color: lightblack,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                Widget>[
              Expanded(child: SidePanel()),
              Expanded(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                      decoration: BoxDecoration(color: white),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //=============================================
                            //heading Signup
                            PageTitle(text: "SIGNUP"),
                            //=============================================

                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                //====================================================================================row
                                children: [
                                  Expanded(
                                      child: RoundTextField(
                                    preicon: Icon(LineIcons.user),
                                    autofocus: false,
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    control: regProvider.name,
                                    text: "First Name",
                                  )),
                                  //====================================================================================row
                                  Expanded(
                                      child: RoundTextField(
                                    autofocus: false,
                                    preicon: Icon(LineIcons.user),
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    control: regProvider.surname,
                                    text: "Last Name",
                                  ))
                                ]
                                //====================================================================================rowEnded
                                ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                //====================================================================================row
                                children: <Widget>[
                                  Expanded(
                                      flex: 2,
                                      child: RoundTextField(
                                        preicon: Icon(LineIcons.at),
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        control: regProvider.email,
                                        text: "Email",
                                        autofocus: false,
                                        onChanged: (value) =>
                                            // regProvider.isEditingEmail,
                                            {regProvider.editsEmail()
                                            },
                                        errorText: regProvider.isEditingEmail
                                            ? regProvider.validateEmail(
                                                regProvider.email.text)
                                            : null,
                                        errorstyle:
                                            TextStyle(color: Colors.black54),
                                      )),
                                  //====================================================================================row
                                  Expanded(
                                      flex: 1,
                                      child: RoundTextField(
                                          autofocus: false,
                                          preicon: Icon(LineIcons.birthdayCake),
                                          margin:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          control: regProvider.birthday,
                                          text: "Birthday",
                                          tap: () => {
                                                FocusScope.of(context)
                                                    .unfocus(),
                                                showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(
                                                        DateTime.now().year -
                                                            100,
                                                        01),
                                                    lastDate: DateTime.now(),
                                                    builder:
                                                        (BuildContext context,
                                                            picker) {
                                                      return Theme(
                                                          // change colors
                                                          data: ThemeData.dark()
                                                              .copyWith(
                                                            colorScheme:
                                                                ColorScheme
                                                                    .dark(
                                                              primary:
                                                                  lightgrey, //highlighter
                                                              onPrimary:
                                                                  black, //text highlighted
                                                              surface:
                                                                  mediumblack,
                                                              onSurface: white,
                                                            ),
                                                            dialogBackgroundColor:
                                                                lightblack,
                                                          ),
                                                          child: (picker)!);
                                                    }).then((pickedDate) {
                                                  if (pickedDate != null) {
                                                    String formattedDate =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(pickedDate);
                                                    regProvider.birthday.text =
                                                        formattedDate;
                                                  }
                                                })
                                              }))
                                ]
                                //====================================================================================rowEnded
                                ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                //====================================================================================row
                                children: <Widget>[
                                  Expanded(
                                      child: RoundPasswordField(
                                    icon: Icon(LineIcons.key),
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    text: "Password",
                                    autofocus: false,
                                    control: regProvider.password,
                                    onChanged: (value) {
                                      regProvider.editsPassword();
                                    },
                                    errorText: regProvider.isEditingPassword
                                        ? regProvider.svalidatePassword(
                                            regProvider.password.text)
                                        : " ",
                                    errorstyle:
                                        TextStyle(color: Colors.black54),
                                  )),
                                  //====================================================================================row
                                  Expanded(
                                      child: RoundPasswordField(
                                    autofocus: false,
                                    icon: Icon(LineIcons.key),
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    text: "Confirm Password",
                                    control: regProvider.confirmPassword,
                                    onChanged: (value) {
                                      regProvider.editsPassword();
                                    },
                                    errorText: regProvider.isEditingPassword
                                        ? regProvider.checkRepeatedPassword(
                                            regProvider.confirmPassword.text)
                                        : " ",
                                    errorstyle:
                                        TextStyle(color: Colors.black54),
                                  ))
                                ]),
                            //==================================================
                            //location
                            RoundTextField(
                              autofocus: false,
                              control: regProvider.location,
                              preicon: Icon(LineIcons.mapMarker),
                            ),

                            FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 16.0),
                                      hintText: 'Please select province',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0))),
                                  isEmpty: regProvider.dropdownvalue == ' ',
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      key: Key('dropdown'),
                                      value: regProvider.dropdownvalue,
                                      isDense: true,
                                      onChanged: (newValue) {
                                        regProvider.dropdownvalue =
                                            newValue.toString();
                                        province = regProvider.dropdownvalue;
                                        state.didChange(newValue);
                                      },
                                      items: regProvider.dropDownItems
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),

                            //=============================================
                            //login button
                            RoundButton(
                                text: "SIGNUP",
                                press: () async {
                                  regProvider.province.text =
                                      regProvider.Province;
                                  if (regProvider.email.text == "" ||
                                      regProvider.birthday.text == "" ||
                                      regProvider.confirmPassword.text == "" ||
                                      regProvider.name.text == "" ||
                                      regProvider.surname.text == "" ||
                                      regProvider.dropdownvalue == " " ||
                                      regProvider.password.text == "" ||
                                      regProvider.province.text == " ") {
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
                                              width: 370.0,
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
                                                  Text(
                                                    "Please fill in all the fields.",
                                                    style: TextStyle(
                                                        fontSize: 24.0),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  TextButton(
                                                    child: Text('OK',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  } else if (!await regProvider
                                      .registerWithEmailPassword()) {
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
                                              width: 370.0,
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
                                                        "Error has occured !",
                                                        style: TextStyle(
                                                            fontSize: 24.0),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        "This account already exist/There's something wrong",
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors.red),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  TextButton(
                                                    child: Text('OK',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                    regProvider.clearController();
                                    locator<NavigationService>()
                                        .globalNavigateTo(HomeRoute, context);
                                  }
                                }),
                            //=================================================================
                            //or dividers
                            OrDivider(),
                            //==========================================
                            //Google sign in button
                            GoogleRoundButton(),
                            //=============================================
                            // Already registered button => take user to login page
                            TextLink(
                                align: Alignment.center,
                                text: 'Already have an account? Login here.',
                                press: () => {
                                      locator<NavigationService>()
                                          .globalNavigateTo(LoginRoute, context)
                                    })
                          ])))
            ])));
  }
}
