import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:drivers_ed_app/Model/student.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  Widget WarningScreen(BuildContext context, List<List> result, int indName, int indNumb, int indDate, int indCat, String fileName) {
    int numberOfValidStudents= 0;
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
                  builder: (BuildContext context) => ImportStatus(context, result, numberOfValidStudents, indName, indNumb, indDate, indCat),
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
  Widget ImportStatus(BuildContext context, List<List<dynamic>> result, int numberOfValidStudents, int indName, int indNumb, int indDate, int indCat) {
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
      } on Exception {if (kDebugMode) {
        print("Huhh, no.");
      }}
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
                  MaterialPageRoute(builder: (context) => const StudentPage()),
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
                  } on Exception {if (kDebugMode) {
                    print("Uhhh, no...");
                  }}
                }

                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentPage()),
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

    //This switch grabs the headers from whatever position they are in, certifying that it is compatible with future headers/the original app
    for (int i = 0; i < headerList.length; i++) {
      dynamic value = headerList[i];
      switch (value.toString().toLowerCase().trim()) {
        case 'nome':
          {
            indName = i;
          }
          break;
        case 'data de inscrição':
        case 'data inscrição':
        case 'inscrição':
        case 'data':
          {
            indDate = i;
          }
          break;
        case 'número de inscrição':
        case 'número':
        case 'nº':
        case 'número inscrição':
        case 'nº de inscrição':
        case 'número de aluno':
        case 'nº de aluno':
        case 'nº inscrição':
        case 'aluno nº':
        case 'aluno número':
          {
            indNumb = i;
          }
          break;
        case 'categoria':
        case 'cat':
        case 'ctg':
        case 'ctg.':
          {
            indCat = i;
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
      if (indCat != -1 && indDate != -1) {
        int numberOfValidStudents= 0;

        showDialog(
          context: context,
          builder: (BuildContext context) => ImportStatus(context, result, numberOfValidStudents, indName, indNumb, indDate, indCat),
        );

        return result;
      }
      if (indDate == -1) {
        missHeaders.add("Data de Inscrição");
      }
      if (indCat == -1) {
        missHeaders.add("Categoria");
      }

      showDialog(
        context: context,
        builder: (BuildContext context) => WarningScreen(context, result, indName, indNumb, indDate, indCat, fileName),
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
