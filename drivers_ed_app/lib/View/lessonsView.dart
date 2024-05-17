/*LessonPage(ID DO ALUNO!!!)*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';

import '../Controller/databaseController.dart';
import '../Model/exam.dart';
import '../Model/lesson.dart';

import '../Model/manoeuvre.dart';
import '../Model/student.dart';
import 'package:text_scroll/text_scroll.dart';
import '../Model/category.dart' as CategoryPackage;

GlobalKey<LessonsListState> _LessonsListKey = GlobalKey();

int totalHours = 0;
int totalDistance = 0;
int numberOfLessons = 0;
int numberOfExams = 0;
String nextExam = "0000-00-00";

//experimental: this will cause the page to update its global values after they have been fetched from the list the first time. Otherwise, since the list is created after the values have been introduced, it would only update the global values on the next update.
bool firstUpdate = true;

class LessonsPage extends StatefulWidget {
  int studentId = 0;

  Student? studentObject;

  LessonsPage({super.key, required this.studentId});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  //placing it in a variable so it can be manually updated whenever the page itself updates
  late List<Lesson> listLessons;
  Student? stateStudent;

  void initState() {
    listLessons = [];
    resetGlobalsLessons();
    super.initState();
    stateStudent = widget.studentObject;
    getStudentsWithNumber(widget.studentId);
    getLessons();
    setState(() {});
  }

  void updateState() {
    listLessons = [];
    resetGlobalsLessons();
    debugPrint("BAN BAN 1");
    debugPrint("current number of hours: $totalHours");
    setState(() {
      getStudentsWithNumber(widget.studentId);
      getLessons();
      _LessonsListKey.currentState!.updateState();
    });
    debugPrint("current number of hours: $totalHours");
  }

  //Async version of the getStudents method, that only returns students with a certain registration Number
  Future<List<Map<String, dynamic>>?> getStudentsWithNumber(int number) async {
    List<Map<String, dynamic>>? studentList = await DatabaseController.instance.queryAllStudentsWithId(number);
    setState(() {
      studentList?.forEach((map) => stateStudent = Student.fromMap(map));
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        elevation: 0,
        onPressed: () {},
        child: const Icon(Icons.calendar_month_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.background,

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        toolbarHeight: 0,
      ),
      body: Container(
          color: Theme.of(context).colorScheme.background,
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                          child: IconButton.filledTonal(
                            icon: Icon(
                              Icons.settings_rounded,
                              color: Theme.of(context).colorScheme.scrim,
                            ),
                            tooltip: 'Definições',
                            onPressed: () {
                              setState(() {});
                            },
                            padding: const EdgeInsets.all(12.0),
                          )),
                      Container(
                        width: 400,
                        height: 50,
                      )
                    ]),
                    Container(
                        height: 600,
                        width: 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                  color: Theme.of(context).colorScheme.onInverseSurface,
                                ),
                                width: 400,
                                padding: EdgeInsets.all(10),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(
                                    stateStudent!.studentName,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 30, height: 1.5, color: Theme.of(context).colorScheme.inverseSurface),
                                  ),
                                  Text(
                                    "_____________________________",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(height: -1, fontSize: 30, fontWeight: FontWeight.w200),
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(
                                      "Nº Inscrição: ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.inverseSurface),
                                    ),
                                    Text(
                                      stateStudent!.studentRegistrationNumber.toString(),
                                      style: TextStyle(fontWeight: FontWeight.w300),
                                    )
                                  ]),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(
                                      "Data Inscrição: ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.inverseSurface),
                                    ),
                                    Text(
                                      DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(stateStudent!.studentRegistrationDate.toInt())),
                                      style: TextStyle(fontWeight: FontWeight.w300),
                                    )
                                  ]),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(
                                      "Categoria: ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.inverseSurface),
                                    ),
                                    Text(
                                      stateStudent!.studentCategory,
                                      style: TextStyle(fontWeight: FontWeight.w300),
                                    )
                                  ]),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(
                                      "Distância Total: ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.inverseSurface),
                                    ),
                                    Text(
                                      "$totalDistance km",
                                      style: TextStyle(fontWeight: FontWeight.w300),
                                    )
                                  ]),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(
                                      "Tempo Total: ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.inverseSurface),
                                    ),
                                    Text(
                                      "$totalHours h",
                                      style: TextStyle(fontWeight: FontWeight.w300),
                                    )
                                  ]),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(
                                      "Nº Aulas: ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.inverseSurface),
                                    ),
                                    Text(
                                      numberOfLessons.toString(),
                                      style: TextStyle(fontWeight: FontWeight.w300),
                                    )
                                  ]),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(
                                      "Nº Exames: ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.inverseSurface),
                                    ),
                                    Text(
                                      numberOfExams.toString(),
                                      style: TextStyle(fontWeight: FontWeight.w300),
                                    )
                                  ]),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(
                                      "Próximo Exame: ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.inverseSurface),
                                    ),
                                    Text(
                                      nextExam,
                                      style: TextStyle(fontWeight: FontWeight.w300),
                                    )
                                  ]),
                                ])),
                            Column(children: [
                              Container(
                                  width: 250,
                                  child: FilledButton.tonal(
                                      onPressed: () {
                                        debugPrint("CLICKED ON NEW LESSON BUTTON");
                                        showNewLessonDialog(updateStateCallback, stateStudent!);
                                      },
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Icon(Icons.school_rounded),
                                        Container(
                                            width: 170,
                                            child: Text(
                                              "Marcar Aula",
                                              textAlign: TextAlign.center,
                                            ))
                                      ]))),
                              Container(
                                  width: 250,
                                  child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Container(
                                        child: IconButton.filledTonal(
                                      style: ButtonStyle(
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () {},
                                      icon: Icon(Icons.add_rounded),
                                    )),
                                    FilledButton.tonal(
                                        onPressed: () {
                                          showExamListDialog();
                                        },
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Icon(Icons.workspace_premium_rounded),
                                          Container(
                                              width: 132,
                                              child: Text(
                                                "Exames",
                                                textAlign: TextAlign.center,
                                              ))
                                        ]))
                                  ])),
                              Container(
                                  width: 250,
                                  child: FilledButton.tonal(
                                      onPressed: () {
                                        debugPrint("CLICKED ON EDIT STUDENT BUTTON");
                                        debugPrint("STUDENT 1: " + stateStudent!.studentName);
                                        showEditStudentDialog(updateStateCallback, stateStudent!);
                                      },
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Icon(Icons.edit_note_rounded),
                                        Container(
                                            width: 170,
                                            child: Text(
                                              "Editar Detalhes",
                                              textAlign: TextAlign.center,
                                            ))
                                      ]))),
                              Container(
                                  width: 250,
                                  child: FilledButton.tonal(
                                      onPressed: () {},
                                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent)),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Icon(Icons.delete_forever_rounded),
                                        Container(
                                            width: 170,
                                            child: Text(
                                              "Apagar Aluno",
                                              textAlign: TextAlign.center,
                                            ))
                                      ])))
                            ]),
                            SizedBox(width: 50, height: 50)
                          ],
                        )),
                  ],
                ),
                Container(
                  width: (MediaQuery.of(context).size.width - 458),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                  child: (Container(
                    child: Column(children: [
                      Container(
                          height: 50,
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
                          child: Container(
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            Container(width: 50, child: Text("Aula Nº", textAlign: TextAlign.center)),
                            Text(
                              "|",
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
                            ),
                            Container(width: 70, child: Text("Data", textAlign: TextAlign.center)),
                            Text(
                              "|",
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
                            ),
                            Container(width: 70, child: Text("Distância", textAlign: TextAlign.center)),
                            Text(
                              "|",
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
                            ),
                            Container(width: 50, child: Text("Horas", textAlign: TextAlign.center)),
                            Text(
                              "|",
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
                            ),
                            Container(width: 150, child: Text("Manobras", textAlign: TextAlign.center)),
                            Text(
                              "|",
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
                            ),
                            Container(width: 60, child: Text("Ações", textAlign: TextAlign.center))
                          ]))),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                            color: Theme.of(context).colorScheme.onInverseSurface,
                          ),
                          height: (MediaQuery.of(context).size.height - 86),
                          child: LessonsList(
                            updateStateCallback,
                            key: _LessonsListKey,
                            studentId: widget.studentId,
                          ))
                    ]),
                  )),
                ),
              ],
            ),
          )),
    );
  }

  //SetState Callback
  void updateStateCallback() {
    debugPrint("UPDATE STATE CALLBACK CALLED IN THE LESSONS PAGE STATE");
    updateState();
  }

  void showEditStudentDialog(void Function() updateStateCallbackFunction, Student student) {
    updateStateCallbackFunction();
    debugPrint("STUDENT 2: " + student.studentName);
    showDialog(
      context: context,
      builder: (BuildContext context) => EditStudentDialog(updateStateCallbackFunction, student),
    );
  }

  void showExamListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => ExamListDialog(widget.studentId),
    );
  }

  void showNewLessonDialog(void Function() updateStateCallbackFunction, Student currentStudent) {
    debugPrint("callback in showNewLessonDialog");
    updateStateCallbackFunction();
    showDialog(
      context: context,
      builder: (BuildContext context) => NewLessonDialog(updateStateCallbackFunction, currentStudent),
    );
  }

  //Async version of the getLessons method. This is a copy of the one in the LessonsList widget. However, due to race conditions, a new copy was needed here
  // ignore: missing_return
  Future<List<Map<String, dynamic>>?> getLessons() async {
    resetGlobalsLessons();
    listLessons = [];
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllRowsLessons();
    setState(() {
      listMap?.forEach((map) => addToList(map));
    });
  }

  //Method that adds Students to the List, in case they are compliant with the search criteria
  addToList(Map<String, dynamic> map) {
    debugPrint("LESSON FOUIND IN DATABASE! Student ID is: " + Lesson.fromMap(map).lessonStudentId.toString());

    if (Lesson.fromMap(map).lessonStudentId == widget.studentId) {
      listLessons.add(Lesson.fromMap(map));
      incrementGlobalsLessons(Lesson.fromMap(map));
    }
  }
}

class NewLessonDialog extends StatefulWidget {
  DateTime currentDate = DateTime.now().copyWith(second: 0, millisecond: 0, microsecond: 0);
  late String currentDateString = currentDate.toIso8601String().split('T').first;
  late String currentHourString = currentDate.hour.toString().padLeft(2, '0') + ":" + currentDate.minute.toString().padLeft(2, '0');

  /*currentDate.toIso8601String().split('T').last.split('.').first;*/
  late String currentCategory = "A";
  Student currentStudent;

  void Function() updateStateCallback;

  NewLessonDialog(this.updateStateCallback, this.currentStudent, {super.key}) {}

  @override
  NewLessonDialogState createState() => NewLessonDialogState();
}

class NewLessonDialogState extends State<NewLessonDialog> {
  NewLessonDialogState();

  /*TextEditingController studentNumber = TextEditingController(text: "");
  TextEditingController studentName = TextEditingController(text: "");*/

  void showDatePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => DatePickerDialog(
        restorationId: 'date_picker_dialog',
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2100),
        cancelText: "Cancelar",
        confirmText: "Confirmar",
        helpText: "Escolher Data",
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: widget.currentDate, firstDate: DateTime(1970), lastDate: DateTime(2100));
    if (picked != null && picked != widget.currentDate) {
      setState(() {
        //setting each field invididually instead of just making it equal to "picked" allows us to preserve any changes made to the time, in case those changes were made before the date
        widget.currentDate = widget.currentDate.copyWith(year: picked.year, month: picked.month, day: picked.day);
        debugPrint("NEW DATETIME IS: " + widget.currentDate.toIso8601String());
        widget.currentDateString = picked.toIso8601String().split('T').first;
      });
    }
  }

  Future<void> _selectHour(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(widget.currentDate));
    if (picked != null && picked != widget.currentDate) {
      setState(() {
        //this will keep the current date, but will change the time on the dateTime object
        widget.currentDate = widget.currentDate.copyWith(hour: picked.hour, minute: picked.minute, second: 0, millisecond: 0, microsecond: 0);
        debugPrint("NEW DATETIME IS: " + widget.currentDate.toIso8601String());
        widget.currentHourString = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      title: const Text(
        "Marcar Aula",
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 5,
            width: 300,
          ),
          /*SizedBox(
                      height: 50,
                      child: TextField(
                        maxLines: 1,
                        controller: studentNumber,
                        keyboardType: TextInputType.number,
                        selectionControls: desktopTextSelectionControls,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.onInverseSurface,
                          labelText: "Número de Inscrição",
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onInverseSurface,
                              ),
                              borderRadius: BorderRadius.circular(90.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onInverseSurface,
                              ),
                              borderRadius: BorderRadius.circular(90.0)),
                        ),
                      )),
                  SizedBox(height: 5),
                  SizedBox(height: 5),
                  Container(
                      height: 50,
                      child: TextField(
                        maxLines: 1,
                        controller: studentName,
                        keyboardType: TextInputType.name,
                        selectionControls: desktopTextSelectionControls,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.onInverseSurface,
                          labelText: "Nome Completo",
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onInverseSurface,
                              ),
                              borderRadius: BorderRadius.circular(90.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onInverseSurface,
                              ),
                              borderRadius: BorderRadius.circular(90.0)),
                        ),
                      )),*/
          Row(children: [
            Container(padding: EdgeInsets.all(5.0), child: Text("Data")),
            Container(
                margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                child: FilledButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onInverseSurface)),
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text(
                    widget.currentDateString,
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                )),
          ]),
          Row(children: [
            Container(padding: EdgeInsets.all(5.0), child: Text("Hora")),
            Container(
                margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                child: FilledButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onInverseSurface)),
                  onPressed: () {
                    _selectHour(context);
                  },
                  child: Text(
                    widget.currentHourString,
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                )),
          ]),
          /*Row(children: [
            Container(padding: EdgeInsets.all(5.0), child: Text("Categoria")),
            PopupMenuExample(
              callback: (String s) => changeCategory(s),
              currentValue: widget.currentCategory,
            )
          ])*/
        ],
      ),
      actions: <Widget>[
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FilledButton.tonal(
            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          FilledButton.tonal(
            onPressed: () {
              Lesson lessonToBeAdded = Lesson(lessonStudentId: widget.currentStudent.studentRegistrationNumber, lessonDate: widget.currentDate.millisecondsSinceEpoch.toDouble(), lessonCategory: widget.currentStudent.studentCategory, lessonDistance: 0, lessonHours: 0, lessonDone: 0, lessonManoeuvres: "");
              DatabaseController.instance.insertLesson(lessonToBeAdded.toMapWithoutId());
              setState(() {
                debugPrint("CLICKED ON CONFIRM BUTTON");
                widget.updateStateCallback();
              });
              Navigator.of(context).pop();
            },
            child: Text(
              'Confirmar',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ])
      ],
    )));
  }

  void changeCategory(String newCategory) {
    widget.currentCategory = newCategory;
    if (kDebugMode) {
      debugPrint("CHANGED CATEGORY TO... " + newCategory);
    }
  }
}

class EditLessonDialog extends StatefulWidget {
  late DateTime currentDate = DateTime.fromMillisecondsSinceEpoch(currentLesson.lessonDate.toInt());
  late String currentDateString = currentDate.toIso8601String().split('T').first;
  late String currentHourString = currentDate.hour.toString().padLeft(2, '0') + ":" + currentDate.minute.toString().padLeft(2, '0');
  late List<String> currentlySelectedManoeuvres = [];

  /*currentDate.toIso8601String().split('T').last.split('.').first;*/
  late String currentCategory = "A";

  Lesson currentLesson;

  void Function() updateStateCallback;

  EditLessonDialog(this.updateStateCallback, this.currentLesson, {super.key}) {}

  @override
  EditLessonDialogState createState() => EditLessonDialogState();
}

class EditLessonDialogState extends State<EditLessonDialog> {
  late Lesson stateLesson;

  //Done
  //Horas
  //Distância
  //Manobras

  late TextEditingController lessonHours;
  late TextEditingController lessonDistance;
  late int isDone;

  @override
  void initState() {
    super.initState();
    stateLesson = widget.currentLesson;
    lessonHours = TextEditingController(text: stateLesson.lessonHours.toString());
    lessonDistance = TextEditingController(text: stateLesson.lessonDistance.toString());
    isDone = stateLesson.lessonDone;
  }

  void showDatePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => DatePickerDialog(
        restorationId: 'date_picker_dialog',
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2100),
        cancelText: "Cancelar",
        confirmText: "Confirmar",
        helpText: "Escolher Data",
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: widget.currentDate, firstDate: DateTime(1970), lastDate: DateTime(2100));
    if (picked != null && picked != widget.currentDate) {
      setState(() {
        //setting each field invididually instead of just making it equal to "picked" allows us to preserve any changes made to the time, in case those changes were made before the date
        widget.currentDate = widget.currentDate.copyWith(year: picked.year, month: picked.month, day: picked.day);
        debugPrint("NEW DATETIME IS: " + widget.currentDate.toIso8601String());
        widget.currentDateString = picked.toIso8601String().split('T').first;
      });
    }
  }

  Future<void> _selectHour(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(widget.currentDate));
    if (picked != null && picked != widget.currentDate) {
      setState(() {
        //this will keep the current date, but will change the time on the dateTime object
        widget.currentDate = widget.currentDate.copyWith(hour: picked.hour, minute: picked.minute, second: 0, millisecond: 0, microsecond: 0);
        debugPrint("NEW DATETIME IS: " + widget.currentDate.toIso8601String());
        widget.currentHourString = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      title: const Text(
        "Editar Aula",
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 5,
            width: 300,
          ),
          Row(
            children: [
              Container(padding: EdgeInsets.all(5.0), child: Text("Realizada")),
              IconButton(
                  padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  onPressed: () {
                    setState(() {
                      isDone = (isDone - 1).abs();
                    });
                  },
                  icon: Icon(
                    boolIconFromIntegerValue(isDone, true),
                    color: Theme.of(context).colorScheme.inverseSurface,
                  )),
            ],
          ),
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
                width: 150,
                height: 50,
                child: TextField(
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  controller: lessonHours,
                  keyboardType: TextInputType.number,
                  selectionControls: desktopTextSelectionControls,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onInverseSurface,
                    labelText: "Duração da Aula",
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                        borderRadius: BorderRadius.circular(90.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                        borderRadius: BorderRadius.circular(90.0)),
                  ),
                )),
            Container(padding: EdgeInsets.all(5.0), child: Text("Horas")),
          ]),
          SizedBox(height: 5),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
                width: 150,
                height: 50,
                child: TextField(
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  controller: lessonDistance,
                  keyboardType: TextInputType.name,
                  selectionControls: desktopTextSelectionControls,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onInverseSurface,
                    labelText: "Distância Percorrida",
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                        borderRadius: BorderRadius.circular(90.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                        borderRadius: BorderRadius.circular(90.0)),
                  ),
                )),
            Container(padding: EdgeInsets.all(5.0), child: Text("km")),
          ]),
          Row(children: [
            Container(padding: EdgeInsets.all(5.0), child: Text("Data")),
            Container(
                margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                child: FilledButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onInverseSurface)),
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text(
                    widget.currentDateString,
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                )),
          ]),
          Row(children: [
            Container(padding: EdgeInsets.all(5.0), child: Text("Hora")),
            Container(
                margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                child: FilledButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onInverseSurface)),
                  onPressed: () {
                    _selectHour(context);
                  },
                  child: Text(
                    widget.currentHourString,
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                )),
          ]),
          Container(
            child: Column(children: [
              Container(
                  height: 50,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
                  child: Container(
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    Container(width: 600, child: Text("Manobras", textAlign: TextAlign.center)),
                  ]))),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
                  height: (MediaQuery.of(context).size.height - 600),
                  width: (600),
                  child: ManoeuvresList(changeSelectedManoeuvres, lesson: stateLesson))
            ]),
          )
          /*Row(children: [
            Container(padding: EdgeInsets.all(5.0), child: Text("Categoria")),
            PopupMenuExample(
              callback: (String s) => changeCategory(s),
              currentValue: widget.currentCategory,
            )
          ])*/
        ],
      ),
      actions: <Widget>[
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FilledButton.tonal(
            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          FilledButton.tonal(
            onPressed: () {
              Lesson lessonToBeAdded = Lesson(lessonId: stateLesson.lessonId, lessonStudentId: stateLesson.lessonStudentId, lessonDate: widget.currentDate.millisecondsSinceEpoch.toDouble(), lessonCategory: stateLesson.lessonCategory, lessonDistance: double.parse(lessonDistance.text), lessonHours: double.parse(lessonHours.text), lessonDone: isDone, lessonManoeuvres: compressManoeuvres());
              DatabaseController.instance.updateLesson(lessonToBeAdded.toMap());
              setState(() {
                debugPrint("CLICKED ON CONFIRM BUTTON");
                widget.updateStateCallback();
              });
              Navigator.of(context).pop();
            },
            child: Text(
              'Confirmar',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ])
      ],
    )));
  }

  void changeSelectedManoeuvres(List<String> newManoeuvres) {
    widget.currentlySelectedManoeuvres = newManoeuvres;
  }

  //will compress all manoeuvres in a list into a single string, separated by ';', so it can be stored in the lesson object.
  String compressManoeuvres() {
    String returnedString = "";
    for (String s in widget.currentlySelectedManoeuvres) {
      if (s.isNotEmpty) {
        debugPrint("FOUND STRING $s");
        returnedString += ("$s;");
      }
    }
    debugPrint("RETURNED STRING IS $returnedString");
    return returnedString;
  }

  void changeCategory(String newCategory) {
    widget.currentCategory = newCategory;
    if (kDebugMode) {
      debugPrint("CHANGED CATEGORY TO... " + newCategory);
    }
  }
}

class LessonDetailsDialog extends StatefulWidget {
  late DateTime currentDate = DateTime.fromMillisecondsSinceEpoch(currentLesson.lessonDate.toInt());
  late String currentDateString = currentDate.toIso8601String().split('T').first;
  late String currentHourString = currentDate.hour.toString().padLeft(2, '0') + ":" + currentDate.minute.toString().padLeft(2, '0');
  late List<String> currentlySelectedManoeuvres = [];

  /*currentDate.toIso8601String().split('T').last.split('.').first;*/
  late String currentCategory = "A";

  Lesson currentLesson;

  LessonDetailsDialog(this.currentLesson, {super.key}) {}

  @override
  LessonDetailsDialogState createState() => LessonDetailsDialogState();
}

class LessonDetailsDialogState extends State<LessonDetailsDialog> {
  late Lesson stateLesson;

  //Done
  //Horas
  //Distância
  //Manobras

  late TextEditingController lessonHours;
  late TextEditingController lessonDistance;
  late int isDone;

  @override
  void initState() {
    super.initState();
    stateLesson = widget.currentLesson;
    lessonHours = TextEditingController(text: stateLesson.lessonHours.toString());
    lessonDistance = TextEditingController(text: stateLesson.lessonDistance.toString());
    isDone = stateLesson.lessonDone;
  }

  void showDatePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => DatePickerDialog(
        restorationId: 'date_picker_dialog',
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2100),
        cancelText: "Cancelar",
        confirmText: "Confirmar",
        helpText: "Escolher Data",
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: widget.currentDate, firstDate: DateTime(1970), lastDate: DateTime(2100));
    if (picked != null && picked != widget.currentDate) {
      setState(() {
        //setting each field invididually instead of just making it equal to "picked" allows us to preserve any changes made to the time, in case those changes were made before the date
        widget.currentDate = widget.currentDate.copyWith(year: picked.year, month: picked.month, day: picked.day);
        debugPrint("NEW DATETIME IS: " + widget.currentDate.toIso8601String());
        widget.currentDateString = picked.toIso8601String().split('T').first;
      });
    }
  }

  Future<void> _selectHour(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(widget.currentDate));
    if (picked != null && picked != widget.currentDate) {
      setState(() {
        //this will keep the current date, but will change the time on the dateTime object
        widget.currentDate = widget.currentDate.copyWith(hour: picked.hour, minute: picked.minute, second: 0, millisecond: 0, microsecond: 0);
        debugPrint("NEW DATETIME IS: " + widget.currentDate.toIso8601String());
        widget.currentHourString = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      title: const Text(
        "Detalhes da Aula",
      ),
      content: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: Theme.of(context).colorScheme.onInverseSurface,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 5,
                width: 300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(padding: EdgeInsets.all(10.0), child: Text("Realizada? ", style: TextStyle(fontWeight: FontWeight.w900))),
                  Container(padding: EdgeInsets.all(10.0), child: (isDone > 0) ? Text("Sim", style: TextStyle(fontWeight: FontWeight.w300)) : Text("Não", style: TextStyle(fontWeight: FontWeight.w300))),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(padding: EdgeInsets.all(10.0), child: Text("Duração: ", style: TextStyle(fontWeight: FontWeight.w900))),
                Container(padding: EdgeInsets.all(10.0), child: Text("${lessonHours.text} Horas", style: TextStyle(fontWeight: FontWeight.w300))),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(padding: EdgeInsets.all(10.0), child: Text("Distância Percorrida: ", style: TextStyle(fontWeight: FontWeight.w900))),
                Container(padding: EdgeInsets.all(10.0), child: Text("${lessonDistance.text} Km", style: TextStyle(fontWeight: FontWeight.w300))),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(padding: EdgeInsets.all(10.0), child: Text("Data: ", style: TextStyle(fontWeight: FontWeight.w900))),
                Container(padding: EdgeInsets.all(10.0), child: Text(widget.currentDateString, style: TextStyle(fontWeight: FontWeight.w300))),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(padding: EdgeInsets.all(10.0), child: Text("Hora: ", style: TextStyle(fontWeight: FontWeight.w900))),
                Container(padding: EdgeInsets.all(10.0), child: Text(widget.currentHourString, style: TextStyle(fontWeight: FontWeight.w300))),
              ]),
              Container(
                child: Column(children: [
                  Container(
                      height: 50,
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
                      child: Container(
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        Container(width: 600, child: Text("Manobras", textAlign: TextAlign.center)),
                      ]))),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                      height: (MediaQuery.of(context).size.height - 600),
                      width: (600),
                      child: ManoeuvresListStatic(lesson: stateLesson))
                ]),
              )
            ],
          )),
      actions: <Widget>[
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FilledButton.tonal(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Fechar',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ])
      ],
    )));
  }

  void changeSelectedManoeuvres(List<String> newManoeuvres) {
    widget.currentlySelectedManoeuvres = newManoeuvres;
  }

  //will compress all manoeuvres in a list into a single string, separated by ';', so it can be stored in the lesson object.
  String compressManoeuvres() {
    String returnedString = "";
    for (String s in widget.currentlySelectedManoeuvres) {
      if (s.isNotEmpty) {
        debugPrint("FOUND STRING $s");
        returnedString += ("$s;");
      }
    }
    debugPrint("RETURNED STRING IS $returnedString");
    return returnedString;
  }

  void changeCategory(String newCategory) {
    widget.currentCategory = newCategory;
    if (kDebugMode) {
      debugPrint("CHANGED CATEGORY TO... " + newCategory);
    }
  }
}

//The dynamic Manoeuvres List widget
class ManoeuvresList extends StatefulWidget {
  ManoeuvresList(this.updateStateCallbackFunction, {super.key, required this.lesson}) {
    listSelected = lesson.lessonManoeuvres.split(';');
  }

  void Function(List<String>) updateStateCallbackFunction;

  Lesson lesson;

  //list of currently selected Manoeuvres
  late List<String> listSelected;

  @override
  State<StatefulWidget> createState() {
    return ManoeuvresListState();
  }

  State<StatefulWidget> updateState() {
    debugPrint("BAN BAN NEW 3");

    return ManoeuvresListState();
  }
}

//State
class ManoeuvresListState extends State<ManoeuvresList> {
  //The list of all Manoeuvres to be shown on the Widget
  late List<String> listManoeuvres;

  ManoeuvresListState() {
    debugPrint("BAN BAN NEW 4");
    listManoeuvres = [];
  }

  //Async version of the getLessons method
  // ignore: missing_return
  Future<List<Map<String, dynamic>>?> getManoeuvres() async {
    resetGlobalsLessons();
    listManoeuvres = [];
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllRowsManoeuvres();
    setState(() {
      listMap?.forEach((map) => addToList(map));
      addLessonManoeuvres();
    });
  }

  //adds manoeuvres present on the lesson, but that are not present on the database (for instance, if they were imported from somewhere else)
  void addLessonManoeuvres() {
    for (String s1 in widget.lesson.lessonManoeuvres.split(";")) {
      if (s1.isNotEmpty) {
        bool found = false;
        for (String s2 in listManoeuvres) {
          if (s2.trim().toLowerCase().contains(s1.trim().toLowerCase())) {
            found = true;
          }
        }
        if (!found) listManoeuvres.add(s1);
      }
    }
  }

  //Method that adds Lessons to the List, in case they are compliant with the search criteria
  addToList(Map<String, dynamic> map) {
    if (Manoeuvre.fromMap(map).manoeuvreCategory == widget.lesson.lessonCategory) {
      listManoeuvres.add(Manoeuvre.fromMap(map).manoeuvreName);
    }
  }

  @override
  void initState() {
    debugPrint("BAN BAN NEW 1");

    getManoeuvres();
    super.initState();
  }

  @override
  void updateState() {
    debugPrint("BAN BAN NEW 2");
    setState(() {
      getManoeuvres();
    });
  }

  //Building the Widget
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listManoeuvres.length,
        itemBuilder: (context, position) {
          String getManoeuvre = listManoeuvres[position];

          return TextButton(
            onLongPress: () {
              setState(() {});
            },
            onPressed: () {},
            child: Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 560,
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    borderRadius: BorderRadius.circular(90),
                    color: Theme.of(context).colorScheme.secondaryContainer),
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Row(
                  children: <Widget>[
                    Container(
                      transformAlignment: Alignment.bottomRight,
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                      child: Checkbox(
                        activeColor: Theme.of(context).colorScheme.inverseSurface,
                        value: widget.listSelected.contains(getManoeuvre.trim().toLowerCase()),
                        onChanged: (value) {
                          setState(() {
                            (widget.listSelected.contains(getManoeuvre.trim().toLowerCase())) ? widget.listSelected.remove(getManoeuvre.trim().toLowerCase()) : widget.listSelected.add(getManoeuvre.trim().toLowerCase());
                            widget.updateStateCallbackFunction(widget.listSelected);
                          });
                        },
                      ),
                    ),
                    Container(
                        width: 400,
                        child: Text(
                          getManoeuvre,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                        )),
                  ],
                ),
              ),
            ])),
          );
        });
  }

  String GetManoeuvres(Lesson lesson) {
    String returnString = "";
    for (String lessonName in lesson.lessonManoeuvres.split(';')) {
      returnString += lessonName + "\n";
    }
    return returnString;
  }
}

//static copy of the widget, with some features removed since it is not supposed to be edited
class ManoeuvresListStatic extends StatefulWidget {
  ManoeuvresListStatic({super.key, required this.lesson}) {
    listSelected = lesson.lessonManoeuvres.split(';');
  }

  Lesson lesson;

  //list of currently selected Manoeuvres
  late List<String> listSelected;

  @override
  State<StatefulWidget> createState() {
    return ManoeuvresListStaticState();
  }

  State<StatefulWidget> updateState() {
    debugPrint("BAN BAN NEW 3");

    return ManoeuvresListStaticState();
  }
}

class ManoeuvresListStaticState extends State<ManoeuvresListStatic> {
  //The list of all Manoeuvres to be shown on the Widget
  late List<String> listManoeuvres;

  ManoeuvresListStaticState() {
    debugPrint("BAN BAN NEW 4");
    listManoeuvres = [];
  }

  //Async version of the getLessons method
  // ignore: missing_return
  Future<List<Map<String, dynamic>>?> getManoeuvres() async {
    resetGlobalsLessons();
    listManoeuvres = [];
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllRowsManoeuvres();
    setState(() {
      listMap?.forEach((map) => addToList(map));
      addLessonManoeuvres();
    });
  }

  //adds manoeuvres present on the lesson, but that are not present on the database (for instance, if they were imported from somewhere else)
  void addLessonManoeuvres() {
    for (String s1 in widget.lesson.lessonManoeuvres.split(";")) {
      if (s1.isNotEmpty) {
        bool found = false;
        for (String s2 in listManoeuvres) {
          if (s2.trim().toLowerCase().contains(s1.trim().toLowerCase())) {
            found = true;
          }
        }
        if (!found) listManoeuvres.add(s1);
      }
    }
  }

  //Method that adds Lessons to the List, in case they are compliant with the search criteria
  addToList(Map<String, dynamic> map) {
    if (Manoeuvre.fromMap(map).manoeuvreCategory == widget.lesson.lessonCategory) {
      listManoeuvres.add(Manoeuvre.fromMap(map).manoeuvreName);
    }
  }

  @override
  void initState() {
    debugPrint("BAN BAN NEW 1");

    getManoeuvres();
    super.initState();
  }

  @override
  void updateState() {
    debugPrint("BAN BAN NEW 2");
    setState(() {
      getManoeuvres();
    });
  }

  //Building the Widget
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listManoeuvres.length,
        itemBuilder: (context, position) {
          String getManoeuvre = listManoeuvres[position];

          return Container(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 560,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      borderRadius: BorderRadius.circular(90),
                      color: Theme.of(context).colorScheme.secondaryContainer),
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: 400,
                          child: Text(
                            getManoeuvre,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface, fontWeight: FontWeight.w600),
                          )),
                    ],
                  ),
                ),
              ]));
        });
  }

  String GetManoeuvres(Lesson lesson) {
    String returnString = "";
    for (String lessonName in lesson.lessonManoeuvres.split(';')) {
      returnString += lessonName + "\n";
    }
    return returnString;
  }
}

//The dynamic Lessons List widget
class LessonsList extends StatefulWidget {
  LessonsList(this.updateStateCallbackFunction, {Key? key, required this.studentId}) : super(key: key);

  void Function() updateStateCallbackFunction;

  int studentId = 0;

  @override
  State<StatefulWidget> createState() {
    debugPrint("STUDENT ID IS: " + studentId.toString());
    return LessonsListState();
  }

  State<StatefulWidget> updateState() {
    debugPrint("BAN BAN NEW 3");
    debugPrint("STUDENT ID IS: " + studentId.toString());
    return LessonsListState();
  }
}

//State
class LessonsListState extends State<LessonsList> {
  //The list of Lessons to be shown on the Widget
  late List<Lesson> listLessons;

  StudentsListState() {
    debugPrint("BAN BAN NEW 4");
    listLessons = [];
  }

  //Async version of the getLessons method
  // ignore: missing_return
  Future<List<Map<String, dynamic>>?> getLessons() async {
    resetGlobalsLessons();
    listLessons = [];
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllRowsLessons();
    setState(() {
      listMap?.forEach((map) => addToList(map));
    });
  }

  //Method that adds Lessons to the List, in case they are compliant with the search criteria
  addToList(Map<String, dynamic> map) {
    debugPrint("LESSON FOUIND IN DATABASE! Student ID is: ${Lesson.fromMap(map).lessonStudentId}");

    if (Lesson.fromMap(map).lessonStudentId == widget.studentId) {
      listLessons.add(Lesson.fromMap(map));
    }
  }

  @override
  void initState() {
    debugPrint("BAN BAN NEW 1");
    debugPrint("STUDENT ID IS: " + widget.studentId.toString());
    getLessons();
    super.initState();
  }

  @override
  void updateState() {
    debugPrint("BAN BAN NEW 2");
    debugPrint("STUDENT ID IS: " + widget.studentId.toString());
    setState(() {
      getLessons();
    });
  }

  //Building the Widget
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listLessons.length,
        itemBuilder: (context, position) {
          Lesson getLesson = listLessons[position];
          var lessonDate = getLesson.lessonDate;
          var lessonHours = getLesson.lessonHours;
          var lessonDistance = getLesson.lessonDistance;
          var lessonDone = getLesson.lessonDone;
          var lessonManoeuvres = getLesson.lessonManoeuvres;
          var lessonCategory = getLesson.lessonCategory;
          return TextButton(
            onLongPress: () {
              setState(() {});
            },
            onPressed: () {
              showLessonDetailsDialog(getLesson);
            },
            child: Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    borderRadius: BorderRadius.circular(90),
                    color: Theme.of(context).colorScheme.secondaryContainer),
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Row(
                  children: <Widget>[
                    Container(
                      transformAlignment: Alignment.bottomRight,
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                      child: IconButton(
                          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                          onPressed: () {},
                          icon: Icon(
                            boolIconFromIntegerValue(getLesson.lessonDone, false),
                            color: (getLesson.lessonDone > 0) ? Colors.green : Colors.red,
                          )),
                    ),
                    Container(
                        width: 40,
                        child: Text(
                          (position + 1).toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                        )),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1, color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                    Container(
                        width: 130,
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(getLesson.lessonDate.toInt())),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                        )),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1, color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                    Container(
                        width: 130,
                        child: Text(
                          "${getLesson.lessonDistance.toString()} km",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                        )),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1, color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                    Container(
                        width: 110,
                        child: Text(
                          "${getLesson.lessonHours.toString()} Horas",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                        )),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1, color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                    Container(
                        width: 210,
                        child: Marquee(
                          text: GetManoeuvres(getLesson),
                          scrollAxis: Axis.vertical,
                          numberOfRounds: null,
                          blankSpace: 0,
                          fadingEdgeStartFraction: 0.5,
                          startAfter: Duration(seconds: 1),
                          pauseAfterRound: Duration(seconds: 3),
                          startPadding: -20,
                          showFadingOnlyWhenScrolling: false,
                          fadingEdgeEndFraction: 0.5,
                          velocity: 15,
                          style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                        ) /*TextScroll(
                        "Manobra mesmo muito muito muito muito muito muito muito longa",
                        mode: TextScrollMode.endless,
                        velocity: Velocity(pixelsPerSecond: Offset(30, 0)),
                        delayBefore: Duration(milliseconds: 500),

                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                      )*/
                        ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: IconButton.filledTonal(
                    style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      showEditLessonDialog(widget.updateStateCallbackFunction, getLesson);
                    },
                    icon: Icon(Icons.mode_edit_outline_rounded, color: Theme.of(context).colorScheme.inverseSurface),
                  )),
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: IconButton.filledTonal(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      showDeleteLessonDialog(getLesson);
                    },
                    icon: Icon(Icons.delete_forever_rounded, color: Theme.of(context).colorScheme.inverseSurface)),
              )
            ])),
          );
        });
  }

  String GetManoeuvres(Lesson lesson) {
    String returnString = "";
    for (String lessonName in lesson.lessonManoeuvres.split(';')) {
      if (lessonName.isNotEmpty) {
        returnString += lessonName + "\n";
      }
    }

    //this can be done better, perhaps with a counter keeping track of the current index, but here's how I remove the last linebreak:
    if (returnString.isNotEmpty && returnString.length >= 1) {
      returnString = returnString.substring(0, returnString.length - 1);
    }
    debugPrint("RETURNED STRING IS (MARQUEE): ${returnString}");
    if (returnString.isEmpty) {
      returnString = "Nenhuma Manobra Definida";
    }
    return returnString;
  }

  void showEditLessonDialog(void Function() updateStateCallbackFunction, Lesson currentLesson) {
    debugPrint("callback in showEditLessonDialog");
    updateStateCallbackFunction();
    showDialog(
      context: context,
      builder: (BuildContext context) => EditLessonDialog(updateStateCallbackFunction, currentLesson),
    );
  }

  //Type had to be obfuscated since dart was not letting me insert this into the DeleteConfirmationDialog function call
  void deleteLesson<T>(T getLesson) {
    //delete lesson getLesson
    //update state
    setState(() {
      DatabaseController.instance.deleteLesson((getLesson as Lesson).lessonId!);
      widget.updateStateCallbackFunction();
      debugPrint("UPDATE STATE CALLBACK CALLED IN THE LESSONS LIST STATE");
    });

  }

  void showDeleteLessonDialog(Lesson lesson) {
    showDialog(
      context: context,
      builder: (BuildContext context) => DeleteConfirmationDialog(deleteLesson, 0, lesson),
    );
  }

  void showLessonDetailsDialog(Lesson currentLesson) {
    debugPrint("callback in showLessonDetailsDialog");

    showDialog(
      context: context,
      builder: (BuildContext context) => LessonDetailsDialog(currentLesson),
    );
  }
}

class EditStudentDialog extends StatefulWidget {
  DateTime currentDate = DateTime.now();
  late String currentDateString = currentDate.toIso8601String().split('T').first;
  late String currentCategory = "A";

  void Function() updateStateCallback;
  Student student;

  EditStudentDialog(this.updateStateCallback, this.student, {super.key}) {
    currentDate = DateTime.fromMillisecondsSinceEpoch(student.studentRegistrationDate.toInt());
    currentCategory = student.studentCategory;
    debugPrint("STUDENT 3: " + student.studentName);
  }

  @override
  EditStudentDialogState createState() => EditStudentDialogState(student);
}

class EditStudentDialogState extends State<EditStudentDialog> {
  late Student stateStudent;

  TextEditingController studentNumber = TextEditingController(text: "");
  TextEditingController studentName = TextEditingController(text: "");

  EditStudentDialogState(this.stateStudent) {
    studentNumber = TextEditingController(text: stateStudent.studentRegistrationNumber.toString());
    studentName = TextEditingController(text: stateStudent.studentName.toString());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: widget.currentDate, firstDate: DateTime(1970), lastDate: DateTime(2100));
    if (picked != null && picked != widget.currentDate) {
      setState(() {
        widget.currentDate = picked;
        widget.currentDateString = picked.toIso8601String().split('T').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      title: const Text(
        "Editar Detalhes do Aluno",
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 5,
            width: 600,
          ),
          SizedBox(
              height: 50,
              child: TextField(
                enabled: false,
                maxLines: 1,
                controller: studentNumber,
                keyboardType: TextInputType.number,
                selectionControls: desktopTextSelectionControls,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onInverseSurface,
                  labelText: "Número de Inscrição (Não Editável)",
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                      borderRadius: BorderRadius.circular(90.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                      borderRadius: BorderRadius.circular(90.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                      borderRadius: BorderRadius.circular(90.0)),
                ),
              )),
          SizedBox(height: 5),
          SizedBox(height: 5),
          Container(
              height: 50,
              child: TextField(
                maxLines: 1,
                controller: studentName,
                keyboardType: TextInputType.name,
                selectionControls: desktopTextSelectionControls,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onInverseSurface,
                  labelText: "Nome Completo",
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                      borderRadius: BorderRadius.circular(90.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                      borderRadius: BorderRadius.circular(90.0)),
                ),
              )),
          Row(children: [
            Container(padding: EdgeInsets.all(5.0), child: Text("Data de Inscrição")),
            Container(
                margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                child: FilledButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onInverseSurface)),
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text(
                    widget.currentDateString,
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                )),
          ]),
          Row(children: [
            Container(padding: EdgeInsets.all(5.0), child: Text("Categoria")),
            PopupMenuExample(
              callback: (String s) => changeCategory(s),
              currentValue: widget.currentCategory,
            )
          ])
        ],
      ),
      actions: <Widget>[
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FilledButton.tonal(
            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          FilledButton.tonal(
            onPressed: () {
              Student studentToBeAdded = Student(studentId: stateStudent.studentId, studentName: studentName.text, studentRegistrationNumber: int.parse(studentNumber.text.trim()), studentRegistrationDate: widget.currentDate.millisecondsSinceEpoch.toDouble(), studentCategory: widget.currentCategory);
              DatabaseController.instance.updateStudent(studentToBeAdded.toMap());
              setState(() {
                debugPrint("CLICKED ON CONFIRM BUTTON");
                widget.updateStateCallback();
              });
              Navigator.of(context).pop();
            },
            child: Text(
              'Confirmar',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ])
      ],
    )));
  }

  void changeCategory(String newCategory) {
    widget.currentCategory = newCategory;
    if (kDebugMode) {
      debugPrint("CHANGED CATEGORY TO... " + newCategory);
    }
  }
}

class ExamListDialog extends StatefulWidget {
  ExamListDialog(this.studentId, {super.key});

  int studentId = 0;

  @override
  _ExamListDialogState createState() => _ExamListDialogState();
}

class _ExamListDialogState extends State<ExamListDialog> {
  _ExamListDialogState();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const Text(
        "Exames",
      ),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            height: 50,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
            child: Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(width: 280, child: Text("Data", textAlign: TextAlign.center)),
              Text(
                "|",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
              ),
              Container(width: 100, child: Text("Categoria", textAlign: TextAlign.center)),
              Text(
                "|",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
              ),
              Container(width: 100, child: Text("Realizado", textAlign: TextAlign.center)),
              Text(
                "|",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
              ),
              Container(width: 100, child: Text("Aprovado", textAlign: TextAlign.center)),
            ]))),
        Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
            height: (MediaQuery.of(context).size.height - 400),
            child: ExamsList(widget.studentId))
      ]),
      actions: <Widget>[
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, children: [
          FilledButton.tonal(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Fechar',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ])
      ],
    )));
  }
}

//The dynamic Exams List widget
class ExamsList extends StatefulWidget {
  ExamsList(this.studentId, {Key? key}) : super(key: key);

  int studentId = 0;

  @override
  State<StatefulWidget> createState() {
    return ExamsListState();
  }

  State<StatefulWidget> updateState() {
    debugPrint("BAN BAN NEW 3");
    return ExamsListState();
  }
}

//State
class ExamsListState extends State<ExamsList> {
  //The list of Exams to be shown on the Widget
  late List<Exam> listExams;

  ExamsListState() {
    debugPrint("BAN BAN NEW 4");
    listExams = [];
  }

  //Async version of the getExams method
  // ignore: missing_return
  Future<List<Map<String, dynamic>>?> getExams() async {
    listExams = [];
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllExamsFromStudent(widget.studentId);
    setState(() {
      listMap?.forEach((map) => addToList(map));
    });
    setState(() {
      mergeSortList(listExams);
    });
  }

  //Method that adds Exams to the List, in case they are compliant with the search criteria
  addToList(Map<String, dynamic> map) {
    listExams.add(Exam.fromMap(map));
  }

  @override
  void initState() {
    debugPrint("BAN BAN NEW 1");
    getExams();
    super.initState();
  }

  @override
  void updateState() {
    debugPrint("BAN BAN NEW 2");
    setState(() {
      getExams();
    });
  }

  //Building the Widget
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 630,
        child: ListView.builder(
            itemCount: listExams.length,
            itemBuilder: (context, position) {
              Exam getExam = listExams[position];
              var examCategory = getExam.examCategory;
              var examDate = getExam.examDate.toStringAsFixed(2);

              return Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                TextButton(
                  onLongPress: () {
                    setState(() {});
                  },
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LessonsPage(studentId: 0)),
                    ).then((_) {
                      updateState();
                    });
                  },
                  child: Container(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).colorScheme.secondaryContainer,
                        ),
                        borderRadius: BorderRadius.circular(90),
                        color: Theme.of(context).colorScheme.secondaryContainer),
                    height: 40,
                    padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: 114,
                            child: Text(
                              getExam.examCategory,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                            )),
                        Text(
                          "|",
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1, color: Theme.of(context).colorScheme.inverseSurface),
                        ),
                        Container(
                            width: 430,
                            child: Text(
                              getExam.examDate.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                            )),
                      ],
                    ),
                  )),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: IconButton.filledTonal(
                      style: ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {},
                      icon: Icon(Icons.mode_edit_outline_rounded),
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                    child: IconButton.filledTonal(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {},
                      icon: Icon(Icons.delete_forever_rounded),
                    ))
              ]);
            }));
  }
}

class PopupMenuExample extends StatefulWidget {
  final void Function(String) callback;
  final String currentValue;

  const PopupMenuExample({super.key, required void this.callback(String s), required this.currentValue});

  @override
  State<PopupMenuExample> createState() => _PopupMenuExampleState(currentValue);
}

class _PopupMenuExampleState extends State<PopupMenuExample> {
  List<CategoryPackage.Category> listCategories = [];
  String currentValue;

  _PopupMenuExampleState(this.currentValue) {
    getCategories();
  }

  //Async version of the getCategories method
  // ignore: missing_return
  Future<List<Map<String, dynamic>>?> getCategories() async {
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllRowsCategories();
    setState(() {
      listMap?.forEach((map) => addToList(map));
    });
  }

  //Method that adds Students to the List, in case they are compliant with the search criteria
  addToList(Map<String, dynamic> map) {
    listCategories.add(CategoryPackage.Category.fromMap(map));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Number of categories: ${listCategories.length}");
    return PopupMenuButton<String>(
        icon: Container(
            margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            width: 41,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onInverseSurface,
              border: Border.all(
                color: Theme.of(context).colorScheme.onInverseSurface,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(90),
            ),
            alignment: Alignment.center,
            child: Text(currentValue)),
        initialValue: "A",
        onSelected: (value) {
          currentValue = value;
          debugPrint("BOINGUS $value selected...");
          setState(() {});
        },
        // This transformation maps listCategories items (thus Categories) into buttons

        itemBuilder: (context) => listCategories
            .map(
              (item) => PopupMenuItem<String>(
                onTap: () => widget.callback(item.categoryName),
                value: item.categoryName,
                child: Text('${item.categoryName}'),
              ),
            )
            .toList());
  }
}

//if 0 -> X, if 1 -> V
IconData boolIconFromIntegerValue(int value, bool isCheckbox) {
  if (isCheckbox) {
    IconData result = Icons.indeterminate_check_box_outlined;
    switch (value) {
      case 0:
        result = Icons.check_box_outline_blank_rounded;
        break;
      case 1:
        result = Icons.check_box_rounded;
        break;
      default:
        result = Icons.indeterminate_check_box_outlined;
        break;
    }

    return result;
  } else {
    IconData result = Icons.horizontal_rule_rounded;
    switch (value) {
      case 0:
        result = Icons.close_rounded;
        break;
      case 1:
        result = Icons.check_rounded;
        break;
      default:
        result = Icons.horizontal_rule_rounded;
        break;
    }

    return result;
  }
}

//The dialog that shows up asking if the user is really sure that they want to delete a lesson/exam/student
class DeleteConfirmationDialog extends StatelessWidget {
  void Function<T>(T) updateStateCallback;

  //is it a lesson (0), an exam (1), or a student (2)?
  int objectType = 0;

  //can either be a category or a manoeuvre. However, it is only here so it can be passed back to the callback function, since by default it doesn't know which exact category or manoeuvre we want to delete, as this process is done dynamically upon list building
  dynamic objectToDelete;

  DeleteConfirmationDialog(this.updateStateCallback, this.objectType, this.objectToDelete, {super.key});

  @override
  Widget build(BuildContext context) {
    String deletedObjectTypeString = "a Aula selecionada";
    switch (objectType) {
      case 0:
        deletedObjectTypeString = "a Aula selecionada";
        break;
      case 1:
        deletedObjectTypeString = "o Exame selecionado";
        break;
      case 2:
        deletedObjectTypeString = "o Aluno selecionado";
        break;
    }

    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const Text(
        "Confirmação",
      ),
      content: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  height: 50,
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      "Tem a certeza que pretende eliminar $deletedObjectTypeString?",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20, height: 1.5, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                    Text(
                      "Esta ação é irreversível.",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                  ])),
            ],
          )),
      actions: <Widget>[
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FilledButton.tonal(
            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent)),
            onPressed: () {
              updateStateCallback(objectToDelete);
              Navigator.of(context).pop();
            },
            child: const Text(
              'SIM',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          FilledButton.tonal(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Não',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ])
      ],
    )));
  }
}

//reset this student's global lesson variables (distance travelled, total lesson hours, number of lessons. DOES NOT CHANGE THE NEXT EXAM VARIABLE OR NUMBER OF EXAMS)
void resetGlobalsLessons() {
  debugPrint("GLOBAL LESSONS RESET");
  totalHours = 0;
  totalDistance = 0;
  numberOfLessons = 0;
}

//Add a new lesson to the global variables
void incrementGlobalsLessons(Lesson lesson) {
  debugPrint("GLOBAL LESSONS INCREMENTED");
  totalHours += lesson.lessonHours.ceil();
  totalDistance += lesson.lessonDistance.ceil();
  numberOfLessons++;
}

//reset this student's global exam variables ( number of exams, next exam date )
void resetGlobalsExams() {
  numberOfExams = 0;
  nextExam = "0000-00-00";
}

List<T> mergeSortList<T>(List<T> list) {
  List<T> listCopy = List<T>.from(list);
  CopyList(list, 0, list.length, listCopy); // one time copy of A[] to B[]
  TopDownSplitMerge(list, 0, list.length, listCopy); // sort data from B[] into A[]
  return listCopy;
}

// Split ListA into 2 runs, sort both runs into ListB merge both runs from ListB to ListA
// iBegin is inclusive; iEnd is exclusive (listA[iEnd] is not in the set).
void TopDownSplitMerge<T>(List<T> listB, int iBegin, int iEnd, List<T> listA) {
  if (iEnd - iBegin <= 1) // if run size == 1
    return; //   consider it sorted
// split the run longer than 1 item into halves
  int iMiddle = ((iEnd + iBegin) / 2).floor(); // iMiddle = mid point
// recursively sort both runs from list ListA into ListB
  TopDownSplitMerge(listA, iBegin, iMiddle, listB); // sort the left  run
  TopDownSplitMerge(listA, iMiddle, iEnd, listB); // sort the right run
// merge the resulting runs from list ListB into ListA
  TopDownMerge(listB, iBegin, iMiddle, iEnd, listA);
}

// Left source half is listA[iBegin:iMiddle-1].
// Right source half is listA[iMiddle:iEnd-1].
// Result is listB[iBegin:iEnd-1].
void TopDownMerge<T>(List<T> listB, int iBegin, int iMiddle, int iEnd, List<T> listA) {
  int i = iBegin, j = iMiddle;

  // While there are elements in the left or right runs...
  for (int k = iBegin; k < iEnd; k++) {
    // If left run head exists and is <= existing right run head.
    if (i < iMiddle && (j >= iEnd || (listA[i]! as Exam).examDate.compareTo((listA[j]! as Exam).examDate) <= 0)) {
      listB[k] = listA[i];
      i = i + 1;
    } else {
      listB[k] = listA[j];
      j = j + 1;
    }
  }
}

void CopyList<T>(List<T> listA, int iBegin, int iEnd, List<T> listB) {
  for (int k = iBegin; k < iEnd; k++) {
    listB[k] = listA[k];
  }
}
