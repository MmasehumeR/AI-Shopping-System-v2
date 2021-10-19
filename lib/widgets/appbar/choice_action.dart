
import 'package:aishop/addons/popop_menu_consts.dart';
import 'package:aishop/navigation/locator.dart';
import 'package:aishop/navigation/routing/route_names.dart';
import 'package:aishop/services/navigation_service.dart';
import 'package:aishop/utils/authentication.dart';
import 'package:aishop/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';

void choiceAction(String choice) {
      if (choice == Constants.profile) {
        locator<NavigationService>().globalNavigateTo(ProfileRoute, contxt);;
      } else if (choice == Constants.settings) {
        locator<NavigationService>().globalNavigateTo(SettingsRoute, contxt);
      } else if (choice == Constants.orders) {
        locator<NavigationService>()
            .globalNavigateTo(PastPurchasesRoute, contxt);
      } else if (choice == Constants.invoices) {
        locator<NavigationService>().globalNavigateTo(InvoicesRoute, contxt);
      } else if (choice == Constants.signout) {
        signOut().then((response) => {
              if (response == "User signed out")
                {
                  showDialog(
                    context: contxt,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text("Success!"),
                        content: new Text(response),
                        actions: <Widget>[
                          ElevatedButton(
                            child: new Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              locator<NavigationService>()
                                  .globalNavigateTo(LoginRoute, context);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                }
              else
                showDialog(
                  context: contxt,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: new Text("Error!!"),
                      content: new Text(response),
                      actions: <Widget>[
                        ElevatedButton(
                          child: new Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                )
            });
      }
    }
