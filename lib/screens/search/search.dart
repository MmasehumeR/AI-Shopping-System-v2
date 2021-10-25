import 'package:aishop/providers/search_provider.dart';
import 'package:aishop/styles/theme.dart';
import 'package:aishop/widgets/product_model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    final SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (val) {
            searchProvider.initSearch(val);
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.black,
      ),
      //Body of the home page
      body: searchProvider.capitalizedValue.length == 1
          ? Container(
              height: 800,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Products")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(grey),
                        backgroundColor: lightgrey,
                      ),
                    );
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              (MediaQuery.of(context).size.width / 250).round(),
                          childAspectRatio: 2 / 3.5,
                          mainAxisSpacing: 0),
                      itemBuilder: (context, index) {
                        return ProductCard(
                            snapshot.data!.docs[index].id,
                            snapshot.data!.docs[index].get('url'),
                            snapshot.data!.docs[index].get('name'),
                            snapshot.data!.docs[index].get('description'),
                            snapshot.data!.docs[index].get('price'),
                            snapshot.data!.docs[index].get('stockamt'),
                            snapshot.data!.docs[index].get('category'));
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
                  }
                },
              ),
            )
          : searchProvider.tempSearchStore.isNotEmpty &&
                  searchProvider.capitalizedValue.length > 1
              ? ListView(children: <Widget>[
                  SizedBox(height: 15.0, width: 10.0),
                  GridView.count(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0, bottom: 10),
                      crossAxisCount:
                          (MediaQuery.of(context).size.width / 250).round(),
                      childAspectRatio: 2 / 3.5,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      primary: false,
                      shrinkWrap: true,
                      children: searchProvider.tempSearchStore.map((element) {
                        return ProductCard(
                            element.id.toString(),
                            element.data()['url'].toString(),
                            element.data()['name'].toString(),
                            element.data()['description'].toString(),
                            element.data()['price'],
                            element.data()['stockamt'],
                            element.data()['category'].toString());
                      }).toList())
                ])
              : searchProvider.tempSearchStore.isEmpty &&
                      searchProvider.capitalizedValue.length > 1
                  ? Container(
                      color: Colors.redAccent,
                      height: 50.0,
                      child: Center(
                        child: Text(
                          "No Results Found",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : new Text(''),
    );
  }
}
