
//This class represents a Manoeuvre object
class Manoeuvre {
  //The Current Manoeuvre Attributes
  int? manoeuvreId;
  String manoeuvreName;
  String manoeuvreCategory;

  Manoeuvre({this.manoeuvreId, required this.manoeuvreName, required this.manoeuvreCategory});

  //to be used when inserting a row in the table
  Map<String, dynamic> toMapWithoutId() {
    final map = <String, dynamic>{};
    map["manoeuvre_name"] = manoeuvreName;
    map["manoeuvre_category"] = manoeuvreCategory;
    return map;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map["manoeuvre_id"] = manoeuvreId;
    map["manoeuvre_name"] = manoeuvreName;
    map["manoeuvre_category"] = manoeuvreCategory;
    return map;
  }

  //to be used when converting the row into object
  factory Manoeuvre.fromMap(Map<String, dynamic> data) => Manoeuvre(manoeuvreId: data['manoeuvre_id'], manoeuvreName: data['manoeuvre_name'], manoeuvreCategory: data['manoeuvre_category']);
}
