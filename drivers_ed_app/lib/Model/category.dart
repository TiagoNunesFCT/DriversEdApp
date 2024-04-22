
//This class represents a Category object
class Category {
  //The Current Category Attributes
  int? categoryId;
  String categoryName;
  String categoryDescription;

  Category({this.categoryId, required this.categoryName, required this.categoryDescription});

  //to be used when inserting a row in the table
  Map<String, dynamic> toMapWithoutId() {
    final map = <String, dynamic>{};
    map["category_name"] = categoryName;
    map["category_description"] = categoryDescription;
    return map;
  }

  String getName(){
    return categoryName;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map["category_id"] = categoryId;
    map["category_name"] = categoryName;
    map["category_description"] = categoryDescription;
    return map;
  }

  //to be used when converting the row into object
  factory Category.fromMap(Map<String, dynamic> data) => Category(categoryId: data['category_id'], categoryName: data['category_name'], categoryDescription: data['category_description']);
}
