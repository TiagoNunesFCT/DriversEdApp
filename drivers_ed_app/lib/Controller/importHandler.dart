import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:drivers_ed_app/Model/student.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Model/exam.dart';
import '../Model/lesson.dart';
import '../View/studentView.dart';
import 'databaseController.dart';

//This Class is what handles importing and exporting to and from .csv files, hence the name
class ImportHandler extends StatefulWidget {
  //The Path in which the import handler will work.
  final String path;

  @override
  ImportHandlerState createState() => ImportHandlerState();

  const ImportHandler({super.key, required this.path});
}

class ImportHandlerState extends State<ImportHandler> with TickerProviderStateMixin {
  //Used for the Circular Progress Indicator
  late AnimationController animationController;

  @override
  void initState() {
    //Play Animation
    animationController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animationController.repeat();

    //Load the .csv file as parse it to a list.
    loadingCSVData(widget.path);
    super.initState();

    //Try to parse the list's contents.
    loadCSVData(widget.path, context);
  }

  //The list of all the missing headers
  List<String> missHeaders = [];

  //Building the Widget
  @override
  Widget build(BuildContext context) {
    return /*Scaffold(
      appBar: AppBar(
        title: Text("CSV DATA"),
      ),*/
        Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
          width: 150,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
            AlertDialog(backgroundColor: const Color(0xFF242933), contentPadding: const EdgeInsets.all(15.0), content: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(height: 40, width: 40, child: CircularProgressIndicator(valueColor: animationController.drive(ColorTween(begin: const Color(0xFF8FBCBB), end: Colors.blueGrey.shade700)), backgroundColor: Colors.black))]))
          ]))
    ]);
  }

  //this variable specifies that the eols (ends of line) can be either \n or \r\n
  var d = const FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n']);

  //This method tries to load the .csv file from the path and parse it (through an UTF-8 Converter) to a List of Strings, for further use
  // ignore: missing_return
  Future<List<List<dynamic>>?> loadingCSVData(String path) async {
    //Opening the File for Reading
    final csvFile = File(path).openRead();

    try {
      //Try to decode it as an UTF-8 File, and convert it to a List
      List<List<dynamic>> result = await csvFile
          .transform(utf8.decoder)
          .transform(
            CsvToListConverter(csvSettingsDetector: d),
          )
          .toList();
      return result;
      //if it fails, it might be because the File is not encoded in UTF-8, this will force a critical error dialog to pop-up
    } on Exception {
      List<String> pathSplit = widget.path.split("/");

      String fileName = pathSplit[pathSplit.length - 1];
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) => CritErrorScreen(context, fileName),
      );
    }
    return null;
  }

  //The Warning Screen, it appears whenever there's missing headers, however these headers are not part of the list of mandatory headers and are not essential for a correct interpretation of the database (ie. Student Name, Registration Number, ID). The user can cancel the import of proceed forward.
  // ignore: non_constant_identifier_names
  Widget WarningScreen(BuildContext context, List<List> result, int indName, int indNumb, int indDate, int indCat, int indLes, int indExa, String fileName) {
    int numberOfValidStudents = 0;
    return Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
      AlertDialog(
          backgroundColor: const Color(0xFF242933),
          titlePadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            IconButton(padding: const EdgeInsets.fromLTRB(10.0, 14.0, 10.0, 10.0), alignment: Alignment.topLeft, iconSize: 22, icon: const Icon(Icons.warning_amber_rounded), color: const Color(0xFFB2A263), onPressed: () {}),
            Container(
                padding: const EdgeInsets.all(0.0),
                child: const Text(
                  'Warning',
                  style: TextStyle(fontFamily: "Montserrat", color: Color(0xFFB2A263), fontWeight: FontWeight.w600, fontSize: 20.0),
                ))
          ]),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 0.0),
          actionsPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'Problems Found while Parsing CSV File:',
              style: TextStyle(fontFamily: "Montserrat", color: Color(0xFFD8DEE9), fontWeight: FontWeight.w300, fontSize: 16.0),
            ),
            Text(
              fileName,
              style: const TextStyle(fontFamily: "Montserrat", color: Color(0xFFD8DEE9), fontWeight: FontWeight.w300, fontSize: 10.0),
            ),
            const SizedBox(height: 10),
            const Text(
              'The following optional headers were missing:',
              style: TextStyle(fontFamily: "Montserrat", color: Color(0xFFD8DEE9), fontWeight: FontWeight.w300, fontSize: 14.0),
            ),
            const SizedBox(height: 10),
            SizedBox(
                height: (17 * missHeaders.length.toDouble()),
                width: 100,
                child: ListView.builder(
                    itemCount: missHeaders.length,
                    itemBuilder: (context, position) {
                      String thisHeader = missHeaders[position];
                      return Text(
                        thisHeader,
                        style: const TextStyle(fontFamily: "Montserrat", color: Color(0xFFD8DEE9), fontWeight: FontWeight.w500, fontSize: 14.0),
                      );
                    })),
          ]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Abort',
                style: TextStyle(fontFamily: "Montserrat", color: Color(0xFF8FBCBB), fontWeight: FontWeight.w300, fontSize: 16.0),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) => ImportStatus(context, result, numberOfValidStudents, indName, indNumb, indDate, indCat, indLes, indExa),
                );
              },
              child: const Text(
                'Import Anyway',
                style: TextStyle(fontFamily: "Montserrat", color: Color(0xFF8FBCBB), fontWeight: FontWeight.w300, fontSize: 16.0),
              ),
            ),
          ])
    ]);
  }

  //The Error Screen, it appears whenever there's missing headers and these headers are part of the list of mandatory headers and are essential for a correct visualization of the Student. The user cannot proceed with the import, only cancel it.
  // ignore: non_constant_identifier_names
  Widget ErrorScreen(BuildContext context, String fileName) {
    return /*Scaffold(
      appBar: AppBar(
        title: Text("CSV DATA"),
      ),*/
        Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
      AlertDialog(
          backgroundColor: const Color(0xFF242933),
          titlePadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            IconButton(padding: const EdgeInsets.fromLTRB(10.0, 14.0, 10.0, 10.0), alignment: Alignment.topLeft, iconSize: 22, icon: const Icon(Icons.error_outline_rounded), color: const Color(0xFFE97553), onPressed: () {}),
            Container(
                padding: const EdgeInsets.all(0.0),
                child: const Text(
                  'Error',
                  style: TextStyle(fontFamily: "Montserrat", color: Color(0xFFE97553), fontWeight: FontWeight.w600, fontSize: 20.0),
                ))
          ]),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 0.0),
          actionsPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'Error while Parsing CSV File:',
              style: TextStyle(fontFamily: "Montserrat", color: Color(0xFFD8DEE9), fontWeight: FontWeight.w300, fontSize: 16.0),
            ),
            Text(
              fileName,
              style: const TextStyle(fontFamily: "Montserrat", color: Color(0xFFD8DEE9), fontWeight: FontWeight.w300, fontSize: 10.0),
            ),
            const SizedBox(height: 10),
            const Text(
              'The following required headers were missing:',
              style: TextStyle(fontFamily: "Montserrat", color: Color(0xFFD8DEE9), fontWeight: FontWeight.w300, fontSize: 14.0),
            ),
            const SizedBox(height: 10),
            SizedBox(
                height: (17 * missHeaders.length.toDouble()),
                width: 100,
                child: ListView.builder(
                    itemCount: missHeaders.length,
                    itemBuilder: (context, position) {
                      String thisHeader = missHeaders[position];
                      return Text(
                        thisHeader,
                        style: const TextStyle(fontFamily: "Montserrat", color: Color(0xFFD8DEE9), fontWeight: FontWeight.w500, fontSize: 14.0),
                      );
                    })),
          ]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Abort',
                style: TextStyle(fontFamily: "Montserrat", color: Color(0xFF8FBCBB), fontWeight: FontWeight.w300, fontSize: 16.0),
              ),
            ),
          ])
    ]);
  }

  //This is the Critical Error Screen, which appears whenever there's a problem with the file encoding, and as such the file hasn't even been parsed
  // ignore: non_constant_identifier_names
  Widget CritErrorScreen(BuildContext context, String fileName) {
    return /*Scaffold(
      appBar: AppBar(
        title: Text("CSV DATA"),
      ),*/
        Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
      AlertDialog(
          backgroundColor: const Color(0xFF242933),
          titlePadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            IconButton(padding: const EdgeInsets.fromLTRB(10.0, 14.0, 10.0, 10.0), alignment: Alignment.topLeft, iconSize: 22, icon: const Icon(Icons.cancel_outlined), color: Colors.redAccent.shade700, onPressed: () {}),
            Container(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  'Critical Error',
                  style: TextStyle(fontFamily: "Montserrat", color: Colors.redAccent.shade700, fontWeight: FontWeight.w600, fontSize: 20.0),
                ))
          ]),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 0.0),
          actionsPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'CSV File Format not recognized.',
              style: TextStyle(fontFamily: "Montserrat", color: Color(0xFFD8DEE9), fontWeight: FontWeight.w300, fontSize: 16.0),
            ),
            Text(
              fileName,
              style: const TextStyle(fontFamily: "Montserrat", color: Color(0xFFD8DEE9), fontWeight: FontWeight.w300, fontSize: 10.0),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please use UTF-8 Encoded Files.',
              style: TextStyle(fontFamily: "Montserrat", color: Color(0xFFD8DEE9), fontWeight: FontWeight.w300, fontSize: 14.0),
            ),
          ]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Ok',
                style: TextStyle(fontFamily: "Montserrat", color: Color(0xFF8FBCBB), fontWeight: FontWeight.w300, fontSize: 16.0),
              ),
            ),
          ])
    ]);
  }

  //This Sub-Dialog shows the user the status of the Import, after either a successful pre-processing or one with a Warning Screen. It shows how many valid Students were found, out of the total, and it allows the user one last chance at Aborting the import process
  // ignore: non_constant_identifier_names
  Widget ImportStatus(BuildContext context, List<List<dynamic>> result, int numberOfValidStudents, int indName, int indNumb, int indDate, int indCat, int indLes, int indExa) {
    //This part belongs to the pre-validation of the Students in order to figure out which Students are valid, and which aren't.

    //for each line of the result List (which will approximately correspond to a Student each)
    for (List<dynamic> currStud in result) {
      try {
        //It will try to parse its remaining fields
        Student stud = Student(
          studentRegistrationDate: (indDate != -1) ? double.parse(currStud[indDate].toString()) : 0.0,
          studentRegistrationNumber: (indNumb != -1) ? int.parse(currStud[indNumb].toString()) : 0,
          studentCategory: (indCat != -1) ? currStud[indCat].toString() : "A",
          studentName: (indName != -1) ? currStud[indName].toString() : "Sem Nome",
        );
        if (kDebugMode) {
          print(stud);
        }
        //If nothing so far has failed, it will increase the counter of valid Students
        numberOfValidStudents++;
      } on Exception {
        if (kDebugMode) {
          debugPrint("Huhh, no.");
        }
      }
    }

    //Building the widget
    return Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
      AlertDialog(
          backgroundColor: const Color(0xFF242933),
          titlePadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            IconButton(padding: const EdgeInsets.fromLTRB(10.0, 14.0, 10.0, 10.0), alignment: Alignment.topLeft, iconSize: 22, icon: const Icon(Icons.system_update_alt_rounded), color: const Color(0xFFD8DEE9), onPressed: () {}),
            Container(
                padding: const EdgeInsets.all(0.0),
                child: const Text(
                  'Import Details',
                  style: TextStyle(fontFamily: "Montserrat", color: Color(0xFFD8DEE9), fontWeight: FontWeight.w600, fontSize: 20.0),
                ))
          ]),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 0.0),
          actionsPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'Import found the following valid Students:',
              style: TextStyle(fontFamily: "Montserrat", color: Color(0xFFD8DEE9), fontWeight: FontWeight.w300, fontSize: 16.0),
            ),
            const SizedBox(height: 10),
            Text(
              "$numberOfValidStudents students out of ${result.length} total.",
              style: const TextStyle(fontFamily: "Montserrat", color: Color(0xFFD8DEE9), fontWeight: FontWeight.w300, fontSize: 14.0),
            ),
            const SizedBox(height: 10),
          ]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentPage()),
                );
              },
              child: const Text(
                'Abort',
                style: TextStyle(fontFamily: "Montserrat", color: Color(0xFF8FBCBB), fontWeight: FontWeight.w300, fontSize: 16.0),
              ),
            ),
            TextButton(
              onPressed: () async {
                List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllRowsStudents();
                //Inserting the Student into the Database
                for (List<dynamic> currStud in result) {
                  try {
                    Student stud = Student(
                      studentRegistrationDate: (indDate != -1) ? double.parse(currStud[indDate].toString()) : 0.0,
                      studentRegistrationNumber: (indNumb != -1) ? int.parse(currStud[indNumb].toString()) : 0,
                      studentCategory: (indCat != -1) ? currStud[indCat].toString() : "A",
                      studentName: (indName != -1) ? currStud[indName].toString() : "Sem Nome ${++listMap?.length}",
                    );

                    DatabaseController.instance.insertStudent(stud.toMapWithoutId());
                    try{
                      debugPrint("Trying to Parse Lessons and Exams...");
                      List<Lesson> studLessons = tryParseLessons((indLes != -1) ? currStud[indLes].toString() : "", int.parse(currStud[indNumb].toString()));
                      List<Exam> studExams = tryParseExams((indExa != -1) ? currStud[indExa].toString() : "", int.parse(currStud[indNumb].toString()));
                      for(Lesson l in studLessons){
                        DatabaseController.instance.insertLesson(l.toMapWithoutId());
                      }
                      for(Exam e in studExams){
                        DatabaseController.instance.insertExam(e.toMapWithoutId());
                      }

                    }on Exception{
                      if (kDebugMode) {
                        debugPrint("Exception Caught whilst handling Exam and Lesson Parsing");
                      }
                    }
                  } on Exception {
                    if (kDebugMode) {
                      debugPrint("Uhhh, no...");
                    }
                  }
                }

                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentPage()),
                );
              },
              child: const Text(
                'Ok',
                style: TextStyle(fontFamily: "Montserrat", color: Color(0xFF8FBCBB), fontWeight: FontWeight.w300, fontSize: 16.0),
              ),
            ),
          ])
    ]);
  }

  //The method that does all of the hard work, parsing through the headers and identifying errors
  // ignore: missing_return
  Future<List<List<dynamic>>?> loadCSVData(String path, BuildContext context) async {
    //Splitting the Path so we can use every part of it
    List<String> pathSplit = widget.path.split("/");

    //The File Name
    String fileName = pathSplit[pathSplit.length - 1];

    //Opening the File for Reading
    final csvFile = File(path).openRead();
    //Await the conversion (which has already happened once in order to determine if the encoding was the correct one - maybe this can be simplified and all done in the same place?)
    List<List<dynamic>> result = await csvFile
        .transform(utf8.decoder)
        .transform(
          CsvToListConverter(csvSettingsDetector: d),
        )
        .toList();
    Navigator.of(context).pop();
    //Verify if the csv file starts with "sep=,"
    String sepVerify = result.first.first;

    //If it does, remove it
    if (sepVerify.startsWith("sep=") || sepVerify.startsWith('"sep=')) {
      result.removeAt(0);
    }

    //This will analyze the headers
    List<dynamic> headerList = result.removeAt(0);
    int indName = -1;
    int indDate = -1;
    int indNumb = -1;
    int indCat = -1;
    int indLes = -1;
    int indExa = -1;

    //This switch grabs the headers from whatever position they are in, certifying that it is compatible with future headers/the original app
    for (int i = 0; i < headerList.length; i++) {
      dynamic value = headerList[i];
      switch (value.toString().toLowerCase().trim()) {
        case 'nome':
        case 'nome do aluno':
        case 'nomedoaluno':
        case 'name':
        case 'student name':
        case 'studentname':
          {
            indName = i;
          }
          break;
        case 'data de inscrição':
        case 'data de inscricao':
        case 'datadeinscrição':
        case 'datadeinscricao':
        case 'data inscrição':
        case 'data inscricao':
        case 'datainscrição':
        case 'datainscricao':
        case 'inscrição':
        case 'inscricao':
        case 'data':
        case 'registrationdate':
        case 'registration date':
        case 'registration':
        case 'date':
          {
            indDate = i;
          }
          break;
        case 'número de inscrição':
        case 'numero de inscricao':
        case 'númerodeinscrição':
        case 'numerodeinscricao':
        case 'número':
        case 'numero':
        case 'nº':
        case 'n':
        case 'número inscrição':
        case 'numero inscricao':
        case 'númeroinscrição':
        case 'numeroinscricao':
        case 'nº de inscrição':
        case 'n de inscricao':
        case 'nºdeinscrição':
        case 'ndeinscricao':
        case 'n de inscrição':
        case 'nº de inscricao':
        case 'ndeinscrição':
        case 'nºdeinscricao':
        case 'número de aluno':
        case 'numero de aluno':
        case 'númerodealuno':
        case 'numerodealuno':
        case 'nº de aluno':
        case 'n de aluno':
        case 'nºdealuno':
        case 'ndealuno':
        case 'nº inscrição':
        case 'n inscricao':
        case 'nºinscrição':
        case 'ninscricao':
        case 'n inscrição':
        case 'nº inscricao':
        case 'ninscrição':
        case 'nºinscricao':
        case 'aluno nº':
        case 'aluno n':
        case 'alunonº':
        case 'alunon':
        case 'aluno número':
        case 'aluno numero':
        case 'alunonúmero':
        case 'alunonumero':
        case 'registrationnumber':
        case 'registration number':
        case 'number':
        case 'registrationnr':
        case 'registration nr':
        case 'nr':
        case 'registrationno':
        case 'registration no':
        case 'no':
        case 'registrationnr.':
        case 'registration nr.':
        case 'nr.':
        case 'registrationno.':
        case 'registration no.':
        case 'no.':
          {
            indNumb = i;
          }
          break;
        case 'categoria':
        case 'cat':
        case 'cat.':
        case 'ctg':
        case 'ctg.':
        case 'category':
          {
            indCat = i;
          }
          break;
        case 'lições':
        case 'lição':
        case 'liç':
        case 'liç.':
        case 'lic':
        case 'lic.':
        case 'aulas':
        case 'aula':
        case 'aul':
        case 'aul.':
        case 'less':
        case 'less.':
        case 'lessons':
        case 'lesson':
          {
            indLes = i;
          }
          break;
        case 'exames':
        case 'exame':
        case 'ex':
        case 'ex.':
        case 'exm':
        case 'exm.':
        case 'exms':
        case 'exms.':
        case 'exam':
        case 'exams':
          {
            indExa = i;
          }
          break;
        default:
          {
            //Body of default case
          }
          break;
      }
    }
    if (missHeaders.isNotEmpty) {
      missHeaders.clear();
    }

    //Required headers present? If not, -> Error Dialog
    if (indName != -1 && indNumb != -1) {
      //all optional headers present? If not, -> Warning Dialog, with possibility to import anyway (therefore all indexes must be passed to the dialog so it can infer which ones exist)
      if (indCat != -1 && indDate != -1 && indLes != -1 && indExa != -1) {
        int numberOfValidStudents = 0;

        showDialog(
          context: context,
          builder: (BuildContext context) => ImportStatus(context, result, numberOfValidStudents, indName, indNumb, indDate, indCat, indLes, indExa),
        );

        return result;
      }
      if (indDate == -1) {
        missHeaders.add("Data de Inscrição");
      }
      if (indCat == -1) {
        missHeaders.add("Categoria");
      }
      if (indLes == -1) {
        missHeaders.add("Lições");
      }
      if (indExa == -1) {
        missHeaders.add("Exames");
      }

      showDialog(
        context: context,
        builder: (BuildContext context) => WarningScreen(context, result, indName, indNumb, indDate, indCat, indLes, indExa, fileName),
      );
    } else {
      if (indName == -1) {
        missHeaders.add("Nome");
      }
      if (indNumb == -1) {
        missHeaders.add("Número de Inscrição");
      }

      showDialog(
        context: context,
        builder: (BuildContext context) => ErrorScreen(context, fileName),
      );
    }
    return null;
  }
}

//Auxiliary Method that tries to parse a timestamp String into a double, and if not possible due to invalid datetime it returns the current date
List<double> tryParseTime(String s) {
  double? result;
  result = null;
  try {
    DateTime dateTimed = DateTime.parse(s);
    result = dateTimed.millisecondsSinceEpoch.roundToDouble();
    return [result, 1];
  } on FormatException {
    return [DateTime.now().millisecondsSinceEpoch.roundToDouble(), 0];
  }
}

// ignore: non_constant_identifier_names
//Auxiliary Method that tried to parse a Lat or Long String into a double
double tryParseLatLong(String s) {
  try {
    return double.parse(s);
  } on Exception {
    throw const FormatException();
  }
}

//Auxiliary Method that tries to parse a lesson String into a list of Lesson Objects, and if not possible due to invalid datetime it returns an empty list
List<Lesson> tryParseLessons(String s, int studentRegistrationNumber) {
  List<Lesson> listLessons;

  //string format is:
  //%LESSONSTART%${l.lessonDate}%${l.lessonHours}%${l.lessonDistance}%${l.lessonDone}%${l.lessonManoeuvres}%${l.lessonCategory}
  //However, LESSONSTART can be replaced by alternative strings
  //LESSONSSTART
  //STARTLESSON
  //STARTLESSONS
  //INICIOLICAO
  //INICIOLICOES
  //LICAOINICIO
  //LICOESINICIO

  String initializer = "";
  //We will try to find how many types of each valid initializer exist

  List<String> allLessons = [s];
  //extend this using a location file.
  List<String> allInitializers = ["%LESSONSTART%", "%LESSONSSTART%", "%STARTLESSON%", "%STARTLESSONS%", "%INICIOLICAO%", "%INICIOLICOES%", "%LICAOINICIO%", "%LICOESINICIO%"];

  //This recursive split starts with the entire string, and will gradually break it apart into smaller substrings by removing each initialized string from the "pile". The result is a list of all the found strings, regardless of their initializer, as long as it is one of the list above.
  List<String> recursiveSplit(List<String> lessons, int index) {
    //debugPrint("inside recursive split, index: $index");
    if (index >= allInitializers.length) {
      //debugPrint("recursive split bottom case, index: $index");
      return lessons;
    } else {
      List<String> newLessons = [];
      for (String l in recursiveSplit(lessons, index + 1)) {
        //debugPrint("Trying to split string $l based on initializer ${allInitializers[index]}");
        newLessons.addAll(l.split(allInitializers[index]));
      }
      //debugPrint("recursive split recursive case, index: $index, newLessons has: ${newLessons.length} lessons");
      return newLessons;
    }
  }

  try {
    debugPrint("trying recursive split");
    allLessons = recursiveSplit(allLessons, 0);
    //now we will parse each lesson into its constituent parts.
    //as a reminder, string format is:
    //${l.lessonDate}%${l.lessonHours}%${l.lessonDistance}%${l.lessonDone}%${l.lessonManoeuvres}%${l.lessonCategory}
    //so we'll need to split it based on "%"
    listLessons = [];
    for (String s in allLessons) {
      if(s.isNotEmpty){
      debugPrint("trying to split the results of the recursive split");
      List<String> listArguments = [];
      listArguments = s.split("%");
      try {
        listLessons.add(Lesson(lessonStudentId: studentRegistrationNumber,
            lessonDate: double.parse(listArguments[0]),
            lessonHours: double.parse(listArguments[1]),
            lessonDistance: double.parse(listArguments[2]),
            lessonDone: int.parse(listArguments[3]),
            lessonManoeuvres: listArguments[4],
            lessonCategory: listArguments[5]));
        debugPrint("######################################## FOUND LESSON, LESSON WAS PARSED SUCCESSFULLY: $studentRegistrationNumber, ${double.parse(listArguments[0])}, ${double.parse(listArguments[1])}, ${double.parse(listArguments[2])}, ${int.parse(listArguments[3])}, ${listArguments[4]}, ${listArguments[5]}.");
      } on Exception {
        debugPrint("######################################## FOUND LESSON, BUT LESSON NOT PARSED SUCCESSFULLY.");
        listLessons.add(Lesson(lessonStudentId: studentRegistrationNumber,
            lessonDate: DateTime
                .now()
                .millisecondsSinceEpoch
                .toDouble(),
            lessonHours: 0.0,
            lessonDistance: 0.0,
            lessonDone: 0,
            lessonManoeuvres: "",
            lessonCategory: "?"));
      }
    }
    }
  } on FormatException {
    debugPrint("Lessons Format Exception");
    listLessons = [];
  }

  return listLessons;
}

//Auxiliary Method that tries to parse an exam String into a list of Exam Objects, and if not possible due to invalid datetime it returns an empty list
List<Exam> tryParseExams(String s, int studentRegistrationNumber) {
  List<Exam> listExams;

  //string format is:
  //%EXAMSTART%${e.examDate}%${e.examDone}%${e.examPassed}%${e.examCategory}
  //However, EXAMSTART can be replaced by alternative strings
  //EXAMSSTART
  //STARTEXAM
  //STARTEXAMS
  //INICIOEXAME
  //INICIOEXAMES
  //EXAMEINICIO
  //EXAMESINICIO

  String initializer = "";
  //We will try to find how many types of each valid initializer exist

  List<String> allExams = [s];
  //extend this using a location file.
  List<String> allInitializers = ["%EXAMSTART%", "%EXAMSSTART%", "%STARTEXAM%", "%STARTEXAMS%", "%INICIOEXAME%", "%INICIOEXAMES%", "%EXAMEINICIO%", "%EXAMESINICIO%"];

  //This recursive split starts with the entire string, and will gradually break it apart into smaller substrings by removing each initialized string from the "pile". The result is a list of all the found strings, regardless of their initializer, as long as it is one of the list above.
  List<String> recursiveSplit(List<String> exams, int index) {
    if (index >= allInitializers.length) {
      return exams;
    } else {
      List<String> newExams = [];
      for (String l in recursiveSplit(exams, index + 1)) {
        newExams.addAll(l.split(allInitializers[index]));
      }
      return newExams;
    }
  }

  try {

    allExams = recursiveSplit(allExams, 0);
    //now we will parse each exam into its constituent parts.
    //as a reminder, string format is:
    //${e.examDate}%${e.examDone}%${e.examPassed}%${e.examCategory}
    //so we'll need to split it based on "%"
    listExams = [];
    for (String s in allExams) {
      if(s.isNotEmpty){
      List<String> listArguments = [];
      listArguments = s.split("%");
      try {
        listExams.add(Exam(examStudentId: studentRegistrationNumber,
            examDate: double.parse(listArguments[0]),
            examDone: int.parse(listArguments[1]),
            examPassed: int.parse(listArguments[2]),
            examCategory: listArguments[3]));
        debugPrint("######################################## FOUND EXAM, EXAM WAS PARSED SUCCESSFULLY: $studentRegistrationNumber, ${double.parse(listArguments[0])}, ${int.parse(listArguments[1])}, ${int.parse(listArguments[2])}, ${listArguments[3]}.");
      } on Exception {
        debugPrint("######################################## FOUND EXAM, BUT EXAM NOT PARSED SUCCESSFULLY.");
        listExams.add(Exam(examStudentId: studentRegistrationNumber,
            examDate: DateTime
                .now()
                .millisecondsSinceEpoch
                .toDouble(),
            examDone: 0,
            examPassed: 0,
            examCategory: "?"));
      }
    }
    }
  } on FormatException {
    listExams = [];
  }

  return listExams;
}