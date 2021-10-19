import 'dart:ui';
import 'package:aishop/navigation/locator.dart';
import 'package:aishop/navigation/routing/route_names.dart';
import 'package:aishop/navigation/routing/router.dart';
import 'package:aishop/providers/checkout_address_provider.dart';
import 'package:aishop/providers/order_review_provider.dart';
import 'package:aishop/providers/profile_provider.dart';
import 'package:aishop/providers/search_provider.dart';
import 'package:aishop/services/databasemanager.dart';
import 'package:aishop/utils/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: SearchProvider.init()),
    ChangeNotifierProvider.value(value: ProfileProvider.init()),
    ChangeNotifierProvider.value(value: CheckoutAdressProvider.init()),
    // ChangeNotifierProvider.value(value: OrderReviewProvider.init()),
  ], child: MyApp()));
}

// class MyApp extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _MyAppState();
//   }
// }

class MyApp extends StatelessWidget {
  bool auto = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // scrollBehavior: MyCustomScrollBehavior(),
      title: 'AI Shop',
      onGenerateRoute: generateRoute,
      initialRoute: LoginRoute,
      // home: auto == false ? LoginScreen() : HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }

//check if user is already logged in in the previous session.
  //get user info if logged in.
  Future getUserInfo() async {
    await getUser();
    // setState(() {
    if (uid != null) {
      auto = true;
    }
    // });
    print(uid);
  }

  Future getProducts() async {
    await DatabaseManager().setBooks();
    await DatabaseManager().setClothes();
    await DatabaseManager().setKitchen();
    await DatabaseManager().setShoes();
    await DatabaseManager().setTech();
  }

  //remove debug banner in the corner
  // void initState() {
  //   getUserInfo();
  //   super.initState();
  // }
}

// class MyCustomScrollBehavior extends MaterialScrollBehavior {
//   // Override behavior methods and getters like dragDevices
//   @override
//   Set<PointerDeviceKind> get dragDevices => {
//         PointerDeviceKind.touch,
//         PointerDeviceKind.mouse,
//         // etc.
//       };
// }

// class AppPagesController extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     AuthProvider authProvider = Provider.of<AuthProvider>(context);

//     return FutureBuilder(
//       // Initialize FlutterFire:
//       future: initialization,
//       builder: (context, snapshot) {
//         // Check for errors
//         if (snapshot.hasError) {
//           return Scaffold(
//             body: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [Text("Something went wrong")],
//             ),
//           );
//         }

//         // Once complete, show your application
//         if (snapshot.connectionState == ConnectionState.done) {
//           print(authProvider.status.toString());
//           switch (authProvider.status) {
//             case Status.Uninitialized:
//               return Loading();
//             case Status.Unauthenticated:
//             case Status.Authenticating:
//               return LoginScreen();
//             case Status.Authenticated:
//               return HomePage();
//             default:
//               return LoginScreen();
//           }
//         }

//         // Otherwise, show something whilst waiting for initialization to complete
//         return Scaffold(
//           body: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [CircularProgressIndicator()],
//           ),
//         );
//       },
//     );
//   }
// }