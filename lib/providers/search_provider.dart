import 'package:aishop/navigation/locator.dart';
import 'package:aishop/navigation/routing/route_names.dart';
import 'package:aishop/services/navigation_service.dart';
import 'package:aishop/utils/costants.dart';
import 'package:aishop/widgets/appbar/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  bool _isSearching = false;
  var queryResultSet = [];
  var tempSearchStore = [];
  var capitalizedValue = ' ';
  int searchvalue = 0;

  // bool get isSearching => _isSearching;

  void search() {
    // _isSearching = true;
    notifyListeners();
    locator<NavigationService>().globalNavigateTo(SearchRoute, contxt);
  }

  void increment(String itemname) async {
    firebaseFiretore
        .collection('Products')
        .where('name', isEqualTo: itemname)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        documentSnapshot.reference.update({"clicks": FieldValue.increment(1)});
      });
    });
    notifyListeners();
  }

  searchByName(String searchField) {
    notifyListeners();
    return FirebaseFirestore.instance
        .collection('Products')
        .where('name', isGreaterThan: searchField)
        .get();
  }

  _initData() async {
    _isSearching = true;
    notifyListeners();
  }

  initSearch(value) async {
    _isSearching = true;
    searchvalue = capitalizedValue.length;
    notifyListeners();
    if (value.length == 0) {
      queryResultSet = [];
      tempSearchStore = [];
      notifyListeners();
    }
    capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);
    notifyListeners();
    if (queryResultSet.length == 0 && value.length > 0) {
      searchByName(capitalizedValue).then((QuerySnapshot mydocs) {
        for (int i = 0; i < mydocs.docs.length; ++i) {
          queryResultSet.add(mydocs.docs[i]);
          tempSearchStore.add(queryResultSet[i]);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].toLowerCase().contains(value.toLowerCase()) ==
            true) {
          if (element["name"].toLowerCase().indexOf(value.toLowerCase()) == 0) {
            tempSearchStore.add(element);
          }
        }
      });
      notifyListeners();
    }
    if (tempSearchStore.length == 0 && value.length > 1) {
      // setState(() {});
    }
    searchvalue = capitalizedValue.length;
    notifyListeners();
  }

  SearchProvider.init() {
    _initData();
    // _initSearch(value);
  }
}
