
//This class represents an Exam object
class Exam {
  //The Current Exam Attributes
  int examId, examStudentId;
  double examDate;
  bool examDone, examPassed;
  String examCategory;

  Exam({required this.examId, required this.examStudentId, required this.examDate, required this.examDone, required this.examPassed, required this.examCategory});

  //to be used when inserting a row in the table
  Map<String, dynamic> toMapWithoutId() {
    final map = <String, dynamic>{};
    map["exam_studentId"] = examStudentId;
    map["exam_date"] = examDate;
    map["exam_done"] = examDone;
    map["exam_passed"] = examPassed;
    map["exam_category"] = examCategory;
    return map;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map["exam_id"] = examId;
    map["exam_studentId"] = examStudentId;
    map["exam_date"] = examDate;
    map["exam_done"] = examDone;
    map["exam_passed"] = examPassed;
    map["exam_category"] = examCategory;
    return map;
  }

  //to be used when converting the row into object
  factory Exam.fromMap(Map<String, dynamic> data) => Exam(examId: data['exam_id'], examStudentId: data['exam_studentId'], examDate: data['exam_date'], examDone: data['exam_done'], examPassed: data['exam_passed'], examCategory: data['exam_category']);
}
