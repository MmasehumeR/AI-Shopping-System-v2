
class ProductModel {
  static const ID = "id";
  static const NAME = "name";
  static const DESCRIPTION = "description";
  static const PRICE = "price";
  static const QUANTITY = "stockamt";
  static const CATEGORY = "category";
  static const URL = "";

  late String id;
  late String imgUrl;
  late String name;
  late String description;
  late int price;
  late int stockamt;
  late String category;

  ProductModel(this.id, this.imgUrl, this.name, this.description, this.price,
      this.stockamt, this.category);

  
  // ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
  //   // id = snapshot.data(ID).toString();
  //   // description = snapshot.data()[DESCRIPTION];
  //   // price = snapshot.data()[PRICE];
  //   // stockamt = snapshot.data()[QUANTITY];
  //   // name = snapshot.data()[NAME].toString();
  //   // category = snapshot.data()![CATEGORY];
  // }
}
