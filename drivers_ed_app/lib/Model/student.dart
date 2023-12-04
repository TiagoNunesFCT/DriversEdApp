
//This class represents a Student object
class Student {
  //The Current Lesson Attributes
  int? studentId;
  int studentRegistrationNumber;
  double studentRegistrationDate;
  String studentName, studentCategory;


  Student({this.studentId, required this.studentName, required this.studentRegistrationNumber, required this.studentRegistrationDate, required this.studentCategory});

  //to be used when inserting a row in the table
  Map<String, dynamic> toMapWithoutId() {
    final map = <String, dynamic>{};
    map["student_name"] = studentName;
    map["student_registration_number"] = studentRegistrationNumber;
    map["student_registration_date"] = studentRegistrationDate;
    map["student_category"] = studentCategory;
    return map;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map["student_id"] = studentId;
    map["student_name"] = studentName;
    map["student_registration_number"] = studentRegistrationNumber;
    map["student_registration_date"] = studentRegistrationDate;
    map["student_category"] = studentCategory;
    return map;
  }

  //to be used when converting the row into object
  factory Student.fromMap(Map<String, dynamic> data) => Student(studentId: data['student_id'], studentName: data['student_name'], studentRegistrationNumber: data['student_registration_number'], studentRegistrationDate: data['student_registration_date'], studentCategory: data['student_category']);
}
