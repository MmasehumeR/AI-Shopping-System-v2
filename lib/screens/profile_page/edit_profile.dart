import 'package:aishop/providers/profile_provider.dart';
import 'package:aishop/styles/round_button.dart';
import 'package:aishop/styles/round_textfield.dart';
import 'package:aishop/styles/theme.dart';
import 'package:aishop/utils/authentication.dart';
import 'package:aishop/widgets/appbar/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    contxt = context;
    Size size = MediaQuery.of(context).size;
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    return new Scaffold(
        appBar: MyAppBar(
          title: Text(
            "Profile",
          ),
          context: context,
        ),
        body: Container(
          color: mediumblack,
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: size.height - 60,
                    width: size.width * 0.3,
                    color: mediumblack,
                    alignment: Alignment.centerRight,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        "My Profile",
                        style: TextStyle(
                            fontFamily: 'Inria Serif',
                            fontSize: 80,
                            fontWeight: FontWeight.w800,
                            color: white),
                      ),
                    ),
                  ),
                  Container(
                    height: size.height - 60,
                    width: size.width * 0.7,
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    color: white,
                    child: ListView(children: [
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 70,
                            backgroundColor: mediumblack,
                            child: CircleAvatar(
                              radius: 65,
                              backgroundImage: imageUrl != null
                                  ? NetworkImage(imageUrl!)
                                  : null,
                              child: imageUrl == null
                                  ? Icon(Icons.account_circle, size: 120)
                                  : Container(),
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white),
                                onPressed: () =>
                                    profileProvider.updateProfileData(),
                                child: Text(
                                  "Edit Profile Picture",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              )

                              /*RoundTextField(
                              autofocus: false,
                              preicon: Icon(Icons.alternate_email),
                              text: "Email",
                              control: userEmailController,
                            ),*/
                              ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: RoundTextField(
                                autofocus: false,
                                text: "First Name",
                                preicon: Icon(Icons.person),
                                control:
                                    profileProvider.userFirstNameController),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: RoundTextField(
                                autofocus: false,
                                preicon: Icon(Icons.person),
                                text: "Last Name",
                                control:
                                    profileProvider.userLastNameController),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: RoundTextField(
                                autofocus: false,
                                onSubmitted: (value) {
                                  profileProvider.textFocusNodeBirthday
                                      .unfocus();
                                  FocusScope.of(context).requestFocus(
                                      profileProvider.textFocusNodeLocation);
                                },
                                preicon: Icon(LineIcons.birthdayCake),
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                control: profileProvider.userBirthdayController,
                                text: "Birthday",
                                tap: () => {
                                      FocusScope.of(context).unfocus(),
                                      showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(
                                              DateTime.now().year - 100, 01),
                                          lastDate: DateTime.now(),
                                          builder:
                                              (BuildContext context, picker) {
                                            return Theme(
                                                // TODO: change colors
                                                data: ThemeData.dark().copyWith(
                                                  colorScheme: ColorScheme.dark(
                                                    primary:
                                                        lightgrey, //highlighter
                                                    onPrimary:
                                                        black, //text highlighted
                                                    surface: mediumblack,
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
                                          profileProvider.userBirthdayController
                                              .text = formattedDate;
                                        }
                                      })
                                    }),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: RoundTextField(
                              autofocus: false,
                              preicon: Icon(Icons.location_pin),
                              text: "Location",
                              control: profileProvider.userLocationController,
                            ),
                          ),
                          // ignore: deprecated_member_use
                          RoundButton(
                            text: 'UPDATE PROFILE',
                            press: () => profileProvider.updateProfileData(),
                          ),
                        ],
                      ),
                    ]),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
