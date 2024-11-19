//This class represents a Lesson object
class Lesson {
  //The Current Lesson Attributes
  int? lessonId;
  int lessonStudentId;
  double lessonDate, lessonHours, lessonDistance;
  int lessonDone; //technically a boolean, but since sqlite does not support booleans, it'll be an integer that oscillates between 0 and 1, to be parsed locally when needed.
  String lessonManoeuvres, lessonCategory;

  Lesson({this.lessonId, required this.lessonStudentId, required this.lessonDate, required this.lessonHours, required this.lessonDistance, required this.lessonDone, required this.lessonManoeuvres, required this.lessonCategory});

  //to be used when inserting a row in the table
  Map<String, dynamic> toMapWithoutId() {
    final map = <String, dynamic>{};
    map["lesson_studentId"] = lessonStudentId;
    map["lesson_date"] = lessonDate;
    map["lesson_hours"] = lessonHours;
    map["lesson_distance"] = lessonDistance;
    map["lesson_done"] = lessonDone;
    map["lesson_manoeuvres"] = lessonManoeuvres;
    map["lesson_category"] = lessonCategory;
    return map;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map["lesson_id"] = lessonId;
    map["lesson_studentId"] = lessonStudentId;
    map["lesson_date"] = lessonDate;
    map["lesson_hours"] = lessonHours;
    map["lesson_distance"] = lessonDistance;
    map["lesson_done"] = lessonDone;
    map["lesson_manoeuvres"] = lessonManoeuvres;
    map["lesson_category"] = lessonCategory;
    return map;
  }

  //to be used when converting the row into object
  factory Lesson.fromMap(Map<String, dynamic> data) => Lesson(lessonId: data['lesson_id'], lessonStudentId: data['lesson_studentId'], lessonDate: data['lesson_date'], lessonHours: data['lesson_hours'], lessonDistance: data['lesson_distance'], lessonDone: data['lesson_done'], lessonManoeuvres: data['lesson_manoeuvres'], lessonCategory: data['lesson_category']);
}
