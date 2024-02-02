/*LessonPage(ID DO ALUNO!!!)*/
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Controller/databaseController.dart';
import '../Model/lesson.dart';
import '../Model/student.dart';
import '../Model/category.dart' as CategoryPackage;

GlobalKey<LessonsListState> _LessonsListKey = GlobalKey();

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

  Student? stateStudent;

  void initState() {
    super.initState();
    stateStudent = widget.studentObject;
    getStudentsWithNumber(widget.studentId);
    setState(() {});
  }

  void updateState() {
    debugPrint("BAN BAN 1");

    setState(() {
      getStudentsWithNumber(widget.studentId);
      _LessonsListKey.currentState!.updateState();
    });
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
                                      "0 km",
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
                                      "0 H",
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
                                      "0",
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
                                      "0",
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
                                      "0000-00-00",
                                      style: TextStyle(fontWeight: FontWeight.w300),
                                    )
                                  ]),
                                ])),
                            Column(children: [
                              Container(
                                  width: 250,
                                  child: FilledButton.tonal(
                                      onPressed: () {},
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
                                        onPressed: () {},
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Icon(Icons.workspace_premium_rounded),
                                          Container(
                                              width: 132,
                                              child: Text(
                                                "Exames Feitos",
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
}

//The dynamic Lessons List widget
class LessonsList extends StatefulWidget {
  LessonsList({Key? key, required this.studentId}) : super(key: key);

  int studentId = 0;

  @override
  State<StatefulWidget> createState() {
    return LessonsListState();
  }

  State<StatefulWidget> updateState() {
    debugPrint("BAN BAN NEW 3");
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

  //Async version of the getStudents method
  // ignore: missing_return
  Future<List<Map<String, dynamic>>?> getLessons() async {
    listLessons = [];
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllRowsLessons();
    setState(() {
      listMap?.forEach((map) => addToList(map));
    });
  }

  //Method that adds Students to the List, in case they are compliant with the search criteria
  addToList(Map<String, dynamic> map) {
    if (Lesson.fromMap(map).lessonStudentId == widget.studentId) {
      listLessons.add(Lesson.fromMap(map));
    }
  }

  @override
  void initState() {
    debugPrint("BAN BAN NEW 1");
    getLessons();
    super.initState();
  }

  @override
  void updateState() {
    debugPrint("BAN BAN NEW 2");
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
            onPressed: () {},
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
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Container(
                      width: 114,
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
                      width: 357,
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
                      width: 208,
                      child: Text(
                        "${getLesson.lessonDistance.toString()} Km",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                      )),
                  Text(
                    "|",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1, color: Theme.of(context).colorScheme.inverseSurface),
                  ),
                  Container(width: 100, child: Icon(boolIconFromIntegerValue(getLesson.lessonDone)))
                ],
              ),
            )),
          );
        });
  }
}

class EditStudentDialog extends StatefulWidget {
  DateTime currentDate = DateTime.now();
  late String currentDateString = currentDate.toIso8601String().split('T').first;
  late String currentCategory = "A";

  void Function() updateStateCallback;
  Student student;

  EditStudentDialog(this.updateStateCallback, this.student,{super.key}) {
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

  EditStudentDialogState(this.stateStudent){

    studentNumber = TextEditingController(text: stateStudent.studentRegistrationNumber.toString());
    studentName = TextEditingController(text: stateStudent.studentName.toString());
  }



  void showDatePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => DatePickerDialog(
        restorationId: 'date_picker_dialog',
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: DateTime.fromMillisecondsSinceEpoch(stateStudent.studentRegistrationDate.toInt()),
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
              Student studentToBeAdded = Student(studentId: stateStudent.studentId,studentName: studentName.text, studentRegistrationNumber: int.parse(studentNumber.text.trim()), studentRegistrationDate: widget.currentDate.millisecondsSinceEpoch.toDouble(), studentCategory: widget.currentCategory);
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

//The dynamic Categories List widget

//State

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
IconData boolIconFromIntegerValue(int value) {
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
}
