/*LessonPage(ID DO ALUNO!!!)*/
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Controller/databaseController.dart';
import '../Model/lesson.dart';
import '../Model/student.dart';

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
                                  ),Text("_____________________________", textAlign: TextAlign.center,style: TextStyle(height: -1, fontSize: 30, fontWeight: FontWeight.w200),),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[Text(
                                    "Nº Inscrição: ",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900,color: Theme.of(context).colorScheme.inverseSurface),
                                  ),Text(stateStudent!.studentRegistrationNumber.toString(), style: TextStyle( fontWeight: FontWeight.w300),)]),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[Text(
                                    "Data Inscrição: ",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900,color: Theme.of(context).colorScheme.inverseSurface),
                                  ),Text(DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(stateStudent!.studentRegistrationDate.toInt())), style: TextStyle( fontWeight: FontWeight.w300),)]),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[Text(
                                    "Categoria: ",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900,color: Theme.of(context).colorScheme.inverseSurface),
                                  ),Text(stateStudent!.studentCategory, style: TextStyle( fontWeight: FontWeight.w300),)]),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[Text(
                                    "Distância Total: ",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900,color: Theme.of(context).colorScheme.inverseSurface),
                                  ),Text("0 km", style: TextStyle( fontWeight: FontWeight.w300),)]),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[Text(
                                    "Tempo Total: ",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900,color: Theme.of(context).colorScheme.inverseSurface),
                                  ),Text("0 H", style: TextStyle( fontWeight: FontWeight.w300),)]),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[Text(
                                    "Nº Aulas: ",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900,color: Theme.of(context).colorScheme.inverseSurface),
                                  ),Text("0", style: TextStyle( fontWeight: FontWeight.w300),)]),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[Text(
                                    "Nº Exames: ",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900,color: Theme.of(context).colorScheme.inverseSurface),
                                  ),Text("0", style: TextStyle( fontWeight: FontWeight.w300),)]),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[Text(
                                    "Próximo Exame: ",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900,color: Theme.of(context).colorScheme.inverseSurface),
                                  ),Text("0000-00-00", style: TextStyle( fontWeight: FontWeight.w300),)]),
                                ])),
                            Column(children:[Container(
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
                                    onPressed: () {},
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
                                    ])))]),
                            SizedBox(width: 50, height: 50)],
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
