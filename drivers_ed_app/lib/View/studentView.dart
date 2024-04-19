import 'package:drivers_ed_app/Model/lesson.dart';
import 'package:drivers_ed_app/Model/manoeuvre.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Controller/databaseController.dart';
import '../Model/category.dart' as CategoryPackage;
import '../Model/student.dart';
import 'package:intl/intl.dart';

import 'lessonsView.dart';

String searchQuery = "";

//List<Student> listStudents = [];

GlobalKey<StudentsListState> _StudentsListKey = GlobalKey();

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  //placing it in a variable so it can be manually updated whenever the page itself updates

  void initState() {
    super.initState();
    setState(() {});
  }

  void updateState() {
    debugPrint("BAN BAN 1");

    setState(() {
      _StudentsListKey.currentState!.updateState();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController studentName = TextEditingController(text: searchQuery);
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
        onPressed: () {
          showWeekDialog();
        },
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
                          child: TextField(
                              controller: studentName,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context).colorScheme.onInverseSurface,
                                contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                hintStyle: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  overflow: TextOverflow.fade,
                                ),
                                prefixIcon: Container(
                                    margin: const EdgeInsets.fromLTRB(0.0, 0.0, 1.0, 0.0),
                                    child: IconButton.filledTonal(
                                      icon: Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.scrim),
                                      tooltip: 'Pesquisar',
                                      onPressed: () {
                                        setState(() {
                                          searchQuery = studentName.text;
                                          debugPrint(searchQuery);
                                        });
                                      },
                                    )),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear_rounded),
                                  tooltip: 'Limpar Pesquisa',
                                  onPressed: () {
                                    setState(() {
                                      searchQuery = "";
                                    });
                                  },
                                ),
                                hintText: 'Pesquisar Aluno...',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(90.0),
                                ),
                              )))
                    ]),
                    Container(
                        height: 300,
                        width: 250,
                        child: Column(
                          children: [
                            FilledButton.tonal(
                                onPressed: () {
                                  debugPrint("CLICKED ON ADD STUDENT BUTTON");
                                  showAddStudentDialog(updateStateCallback);
                                },
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Icon(Icons.person_add),
                                  Container(
                                      width: 170,
                                      child: Text(
                                        "Novo Aluno",
                                        textAlign: TextAlign.center,
                                      ))
                                ])),
                            Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Container(
                                  child: IconButton.filledTonal(
                                style: ButtonStyle(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  showAddCategoryDialog();
                                },
                                icon: Icon(Icons.add_rounded),
                              )),
                              FilledButton.tonal(
                                  onPressed: () {
                                    showCategoryListDialog();
                                  },
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Icon(Icons.minor_crash_rounded),
                                    Container(
                                        width: 132,
                                        child: Text(
                                          "Categorias",
                                          textAlign: TextAlign.center,
                                        ))
                                  ]))
                            ]),
                            Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Container(
                                  child: IconButton.filledTonal(
                                style: ButtonStyle(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  showAddManoeuvreDialog();
                                },
                                icon: Icon(Icons.add_rounded),
                              )),
                              FilledButton.tonal(
                                  onPressed: () {
                                    showManoeuvreListDialog();
                                  },
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Icon(Icons.signpost_rounded),
                                    Container(
                                        width: 132,
                                        child: Text(
                                          "Manobras",
                                          textAlign: TextAlign.center,
                                        ))
                                  ]))
                            ]),
                            FilledButton.tonal(
                                onPressed: () {},
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Icon(Icons.download_rounded),
                                  Container(
                                      width: 170,
                                      child: Text(
                                        "Importar Alunos",
                                        textAlign: TextAlign.center,
                                      ))
                                ])),
                            FilledButton.tonal(
                                onPressed: () {},
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Icon(Icons.upload_rounded),
                                  Container(
                                      width: 170,
                                      child: Text(
                                        "Exportar Alunos",
                                        textAlign: TextAlign.center,
                                      ))
                                ])),
                            FilledButton.tonal(
                                onPressed: () {},
                                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent)),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Icon(Icons.delete_forever_rounded),
                                  Container(
                                      width: 170,
                                      child: Text(
                                        "Apagar Tudo",
                                        textAlign: TextAlign.center,
                                      ))
                                ])),
                          ],
                        )),
                    SizedBox(width: 50, height: 50)
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
                            Container(width: 80, child: Text("Aluno Nº", textAlign: TextAlign.center)),
                            Text(
                              "|",
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
                            ),
                            Container(width: 300, child: Text("Nome Completo", textAlign: TextAlign.center)),
                            Text(
                              "|",
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
                            ),
                            Container(width: 150, child: Text("Data de Inscrição", textAlign: TextAlign.center)),
                            Text(
                              "|",
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
                            ),
                            Container(width: 70, child: Text("Categoria", textAlign: TextAlign.center))
                          ]))),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                            color: Theme.of(context).colorScheme.onInverseSurface,
                          ),
                          height: (MediaQuery.of(context).size.height - 86),
                          child: StudentsList(
                            key: _StudentsListKey,
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

  void showAddStudentDialog(void Function() updateStateCallbackFunction) {
    debugPrint("callback in showAddStudentDialog");
    updateStateCallbackFunction();
    showDialog(
      context: context,
      builder: (BuildContext context) => AddStudentDialog(updateStateCallbackFunction),
    );
  }

  void showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AddCategoryDialog(),
    );
  }

  void showCategoryListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CategoryListDialog(),
    );
  }

  void showWeekDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => WeekDialog(DateTime.now()),
    );
  }

  void showAddManoeuvreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AddManoeuvreDialog(),
    );
  }

  void showManoeuvreListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => ManoeuvreListDialog(),
    );
  }
}

class AddStudentDialog extends StatefulWidget {
  DateTime currentDate = DateTime.now();
  late String currentDateString = currentDate.toIso8601String().split('T').first;
  late String currentCategory = "A";

  void Function() updateStateCallback;

  AddStudentDialog(this.updateStateCallback, {super.key}) {}

  @override
  AddStudentDialogState createState() => AddStudentDialogState();
}

class AddStudentDialogState extends State<AddStudentDialog> {
  AddStudentDialogState();

  TextEditingController studentNumber = TextEditingController(text: "");
  TextEditingController studentName = TextEditingController(text: "");

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
        "Novo Aluno",
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
              Student studentToBeAdded = Student(studentName: studentName.text, studentRegistrationNumber: int.parse(studentNumber.text.trim()), studentRegistrationDate: widget.currentDate.millisecondsSinceEpoch.toDouble(), studentCategory: widget.currentCategory);
              DatabaseController.instance.insertStudent(studentToBeAdded.toMapWithoutId());
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

class AddCategoryDialog extends StatefulWidget {
  AddCategoryDialog({super.key});

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  _AddCategoryDialogState();

  TextEditingController categoryName = TextEditingController(text: "");
  TextEditingController categoryDescription = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const Text(
        "Nova Categoria",
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
                maxLines: 1,
                controller: categoryName,
                keyboardType: TextInputType.name,
                selectionControls: desktopTextSelectionControls,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onInverseSurface,
                  labelText: "Nome da Categoria",
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
                controller: categoryDescription,
                keyboardType: TextInputType.name,
                selectionControls: desktopTextSelectionControls,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onInverseSurface,
                  labelText: "Descrição (ex: Ligeiros)",
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
              CategoryPackage.Category categoryToBeAdded = CategoryPackage.Category(categoryName: categoryName.text, categoryDescription: categoryDescription.text);
              DatabaseController.instance.insertCategory(categoryToBeAdded.toMapWithoutId());
              Navigator.of(context).pop();
              setState(() {});
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
}

class CategoryListDialog extends StatefulWidget {
  CategoryListDialog({super.key});

  @override
  _CategoryListDialogState createState() => _CategoryListDialogState();
}

class _CategoryListDialogState extends State<CategoryListDialog> {
  _CategoryListDialogState();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const Text(
        "Categorias",
      ),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            height: 50,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
            child: Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(width: 80, child: Text("Nome", textAlign: TextAlign.center)),
              Text(
                "|",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
              ),
              Container(width: 500, child: Text("Descrição", textAlign: TextAlign.center)),
            ]))),
        Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
            height: (MediaQuery.of(context).size.height - 400),
            child: CategoriesList())
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

class WeekDialog extends StatefulWidget {
  DateTime date;

  WeekDialog(this.date, {super.key});

  @override
  _WeekDialogState createState() => _WeekDialogState();
}

class _WeekDialogState extends State<WeekDialog> {
  _WeekDialogState();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const Text(
        "Próximas Aulas",
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 1000,
            child: WeekDisplay(date: widget.date),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 1000,
            child: WeekDisplay(date: widget.date.add(Duration(days: 7))),
          ),
        ],
      ),
      actions: <Widget>[
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, children: [
          FilledButton.tonal(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {});
            },
            child: Text(
              'Fechar',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ])
      ],
    )));
  }
}

class WeekDisplay extends StatefulWidget {
  DateTime date;

  WeekDisplay({super.key, required this.date});

  @override
  _WeekDisplayState createState() => _WeekDisplayState(date);
}

class _WeekDisplayState extends State<WeekDisplay> {
  DateTime lastSundayDate;

  _WeekDisplayState(this.lastSundayDate) {
    lastSundayDate = lastSunday(lastSundayDate);
    getDates(lastSundayDate);
  }

  Map<Lesson, Student> lessons = {};
  List<DateTime> dates = [];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: dates
          .map((item) => Container(
              padding: EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 0.0),
              decoration: BoxDecoration(
                color: (roundDateTime(item).toString() == roundDateTime(DateTime.now()).toString()) ? Theme.of(context).colorScheme.tertiaryContainer : Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (roundDateTime(item).toString() == roundDateTime(DateTime.now()).toString()) ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondaryContainer,
                  width: 1,
                ),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Container(
                    width: 130,
                    child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      Text(
                        weekdayString(item),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: (roundDateTime(item).toString() == roundDateTime(DateTime.now()).toString()) ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary),
                      ),
                      Text(
                        "|",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: (roundDateTime(item).toString() == roundDateTime(DateTime.now()).toString()) ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary),
                      ),
                      Text(
                        DateFormat(
                          'yyyy-MM-dd',
                        ).format(item),
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.w600, color: (roundDateTime(item).toString() == roundDateTime(DateTime.now()).toString()) ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary),
                      )
                    ])),
                Container(
                    width: 130,
                    height: 100,
                    child: Column(
                        children: lessons.keys
                            .where((item3) => roundDateTime(item).toString() == roundDateTime(DateTime.fromMillisecondsSinceEpoch(item3.lessonDate.toInt())).toString())
                            .map((item2) => Container(
                                    child: Row(
                                  children: [Text(DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(item2.lessonDate.toInt()))), const Text("|"), Text(lessons[item2]!.studentName)],
                                )))
                            .toList()))
              ])))
          .toList(),
    );
  }

  void getDates(DateTime date) {
    for (int i = 0; i < 7; i++) {
      dates.add(date.add(Duration(days: i)));
    }
  }

  //Async version of the getLessons method
  // ignore: missing_return
  Future<List<Map<String, dynamic>>?> getLessons() async {
    lessons = {};
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllLessonsBetween(dates[0], dates[dates.length - 1]);
    setState(() {
      listMap?.forEach((map) => addToListLesson(map));
    });
  }

  //Method that adds Students to the List, in case they are compliant with the search criteria
  addToListLesson(Map<String, dynamic> map) {
    //if (DateTime.fromMillisecondsSinceEpoch(Lesson.fromMap(map).lessonDate.toInt()).isAfter(other) || Student.fromMap(map).studentRegistrationNumber.toString().toLowerCase().contains(searchQuery.trim().toLowerCase())) {
    int number = Lesson.fromMap(map).lessonStudentId;

    getStudentsWithNumber(number, Lesson.fromMap(map));
    //}
  }

  //Async version of the getStudents method, that only returns students with a certain registration Number
  Future<List<Map<String, dynamic>>?> getStudentsWithNumber(int number, Lesson lesson) async {
    lessons = {};
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllStudentsWithId(number);
    setState(() {
      listMap?.forEach((map) => addToListStudent(map, lesson));
    });
  }

  //Method that adds Students to the List, in case they are compliant with the search criteria
  addToListStudent(Map<String, dynamic> map, Lesson lesson) {
    lessons.addEntries([MapEntry(lesson, Student.fromMap(map))]);
  }
}

class AddManoeuvreDialog extends StatefulWidget {
  AddManoeuvreDialog({super.key});

  late String currentCategory = "A";

  @override
  _AddManoeuvreDialogState createState() => _AddManoeuvreDialogState();
}

class _AddManoeuvreDialogState extends State<AddManoeuvreDialog> {
  _AddManoeuvreDialogState();

  TextEditingController manoeuvreName = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const Text(
        "Nova Categoria",
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
                maxLines: 1,
                controller: manoeuvreName,
                keyboardType: TextInputType.name,
                selectionControls: desktopTextSelectionControls,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onInverseSurface,
                  labelText: "Nome da Manobra",
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
          Row(children: [
            Container(padding: EdgeInsets.all(5.0), child: Text("Categoria")),
            PopupMenuExample(
              callback: (String s) => changeCategory(s),
              currentValue: widget.currentCategory,
            )
          ]),
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
              Manoeuvre manoeuvreToBeAdded = Manoeuvre(manoeuvreName: manoeuvreName.text, manoeuvreCategory: widget.currentCategory);
              DatabaseController.instance.insertManoeuvre(manoeuvreToBeAdded.toMapWithoutId());
              Navigator.of(context).pop();
              setState(() {});
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

class ManoeuvreListDialog extends StatefulWidget {
  ManoeuvreListDialog({super.key});

  @override
  _ManoeuvreListDialogState createState() => _ManoeuvreListDialogState();
}

class _ManoeuvreListDialogState extends State<ManoeuvreListDialog> {
  _ManoeuvreListDialogState();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const Text(
        "Manobras",
      ),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            height: 50,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
            child: Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(width: 80, child: Text("Categoria", textAlign: TextAlign.center)),
              Text(
                "|",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
              ),
              Container(width: 500, child: Text("Nome", textAlign: TextAlign.center)),
            ]))),
        Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
            height: (MediaQuery.of(context).size.height - 400),
            child: ManoeuvresList())
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

//The dynamic Students List widget
class StudentsList extends StatefulWidget {
  StudentsList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StudentsListState();
  }

  State<StatefulWidget> updateState() {
    debugPrint("BAN BAN NEW 3");
    return StudentsListState();
  }
}

//State
class StudentsListState extends State<StudentsList> {
  //The list of Students to be shown on the Widget
  late List<Student> listStudents;

  StudentsListState() {
    debugPrint("BAN BAN NEW 4");
    listStudents = [];
  }

  //Async version of the getStudents method
  // ignore: missing_return
  Future<List<Map<String, dynamic>>?> getStudents() async {
    listStudents = [];
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllRowsStudents();
    setState(() {
      listMap?.forEach((map) => addToList(map));
    });
  }

  //Method that adds Students to the List, in case they are compliant with the search criteria
  addToList(Map<String, dynamic> map) {
    if (Student.fromMap(map).studentName.toLowerCase().contains(searchQuery.trim().toLowerCase()) || Student.fromMap(map).studentRegistrationNumber.toString().toLowerCase().contains(searchQuery.trim().toLowerCase())) {
      listStudents.add(Student.fromMap(map));
    }
  }

  @override
  void initState() {
    debugPrint("BAN BAN NEW 1");
    getStudents();
    super.initState();
  }

  @override
  void updateState() {
    debugPrint("BAN BAN NEW 2");
    setState(() {
      getStudents();
    });
  }

  //Building the Widget
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listStudents.length,
        itemBuilder: (context, position) {
          Student getStudent = listStudents[position];
          var studentNumber = getStudent.studentRegistrationNumber.toString();
          var studentName = getStudent.studentName;
          return TextButton(
            onLongPress: () {
              setState(() {});
            },
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LessonsPage(studentId: getStudent.studentRegistrationNumber)),
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
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Container(
                      width: 114,
                      child: Text(
                        getStudent.studentRegistrationNumber.toString(),
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
                        getStudent.studentName,
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
                        DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(getStudent.studentRegistrationDate.toInt())),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                      )),
                  Text(
                    "|",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1, color: Theme.of(context).colorScheme.inverseSurface),
                  ),
                  Container(
                      width: 100,
                      child: Text(
                        getStudent.studentCategory,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                      ))
                ],
              ),
            )),
          );
        });
  }
}

//The dynamic Categories List widget
class CategoriesList extends StatefulWidget {
  CategoriesList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CategoriesListState();
  }

  State<StatefulWidget> updateState() {
    debugPrint("BAN BAN NEW 3");
    return CategoriesListState();
  }
}

//State
class CategoriesListState extends State<CategoriesList> {
  //The list of Students to be shown on the Widget
  late List<CategoryPackage.Category> listCategories;

  CategoriesListState() {
    debugPrint("BAN BAN NEW 4");
    listCategories = [];
  }

  //Async version of the getCategories method
  // ignore: missing_return
  Future<List<Map<String, dynamic>>?> getCategories() async {
    listCategories = [];
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllRowsCategories();
    setState(() {
      listMap?.forEach((map) => addToList(map));
    });
    setState(() {
      mergeSortList(listCategories);
    });
  }

  //Method that adds Categories to the List, in case they are compliant with the search criteria
  addToList(Map<String, dynamic> map) {
    // if (CategoryPackage.Category.fromMap(map).categoryName.toLowerCase().contains(searchQuery.trim().toLowerCase()) || CategoryPackage.Category.fromMap(map).categoryDescription.toString().toLowerCase().contains(searchQuery.trim().toLowerCase())) {
    listCategories.add(CategoryPackage.Category.fromMap(map));
    //}
  }

  @override
  void initState() {
    debugPrint("BAN BAN NEW 1");
    getCategories();
    super.initState();
  }

  @override
  void updateState() {
    debugPrint("BAN BAN NEW 2");
    setState(() {
      getCategories();
    });
  }

  //Building the Widget
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 630,
        child: ListView.builder(
            itemCount: listCategories.length,
            itemBuilder: (context, position) {
              CategoryPackage.Category getCategory = listCategories[position];
              var categoryName = getCategory.categoryName;
              var categoryDescription = getCategory.categoryDescription;

              return Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                TextButton(
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
                    padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: 114,
                            child: Text(
                              getCategory.categoryName,
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
                              getCategory.categoryDescription,
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

//The dynamic Manoeuvres List widget
class ManoeuvresList extends StatefulWidget {
  ManoeuvresList({Key? key}) : super(key: key);

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
  //The list of Students to be shown on the Widget
  late List<Manoeuvre> listManoeuvres;

  ManoeuvresListState() {
    debugPrint("BAN BAN NEW 4");
    listManoeuvres = [];
  }

  //Async version of the getManoeuvres method
  // ignore: missing_return
  Future<List<Map<String, dynamic>>?> getManoeuvres() async {
    listManoeuvres = [];
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllRowsManoeuvres();
    setState(() {
      listMap?.forEach((map) => addToList(map));
    });
    setState(() {
      mergeSortList(listManoeuvres);
    });
  }

  //Method that adds Manoeuvres to the List, in case they are compliant with the search criteria
  addToList(Map<String, dynamic> map) {
    // if (Manoeuvres.fromMap(map).manoeuvreName.toLowerCase().contains(searchQuery.trim().toLowerCase()) || CategoryPackage.Category.fromMap(map).categoryDescription.toString().toLowerCase().contains(searchQuery.trim().toLowerCase())) {
    listManoeuvres.add(Manoeuvre.fromMap(map));
    //}
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
    return Container(
        width: MediaQuery.of(context).size.width - 630,
        child: ListView.builder(
            itemCount: listManoeuvres.length,
            itemBuilder: (context, position) {
              Manoeuvre getManoeuvre = listManoeuvres[position];
              var manoeuvreCategory = getManoeuvre.manoeuvreCategory;
              var manoeuvreName = getManoeuvre.manoeuvreName;

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
                              getManoeuvre.manoeuvreCategory,
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
                              getManoeuvre.manoeuvreName,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                            )),
                      ],
                    ),
                  )),
                )
                ,Container(
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

//DateTime Methods

//this method returns the last(previous) sunday from the desired date
DateTime lastSunday(DateTime dateTime) {
  DateTime roundedDateTime = roundDateTime(dateTime);
  if (roundedDateTime.weekday == DateTime.sunday) {
    return roundedDateTime;
  } else {
    return lastSunday(roundedDateTime.subtract(const Duration(days: 1)));
  }
}

//this method will return the date rounded to 00:00:00.000000Z. Useful when checking days
DateTime roundDateTime(DateTime dateTime) {
  return dateTime.subtract(Duration(hours: dateTime.hour, minutes: dateTime.minute, seconds: dateTime.second, milliseconds: dateTime.millisecond, microseconds: dateTime.microsecond));
}

//this method returns a simple character indicating a date's day of the week.
String weekdayString(DateTime dateTime) {
  DateTime roundedDateTime = roundDateTime(dateTime);
  //to enable compatibility with other languages, the check must be done here, perhaps with an additional switch
  String result = "D";
  switch (roundedDateTime.weekday) {
    case DateTime.sunday:
      result = "D";
      break;
    case DateTime.monday:
      result = "S";
      break;
    case DateTime.tuesday:
      result = "T";
      break;
    case DateTime.wednesday:
      result = "Q";
      break;
    case DateTime.thursday:
      result = "Q";
      break;
    case DateTime.friday:
      result = "S";
      break;
    case DateTime.saturday:
      result = "S";
      break;
    default:
      result = "D";
      break;
  }
  return result;
}

//TODO: WHEN DELETING A STUDENT, DELETE ALL THEIR LESSONS AND EXAMS. THIS WILL CLEAN THE DATABASE, PREVENTING IT FROM BECOMING BLOATED WITH OLD LESSONS.

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

  //Are the List's Elements Categories or Manoeuvres?
  if (T == CategoryPackage.Category) {
    //Categories
    // While there are elements in the left or right runs...
    for (int k = iBegin; k < iEnd; k++) {
      // If left run head exists and is <= existing right run head.
      if (i < iMiddle && (j >= iEnd || (listA[i]! as CategoryPackage.Category).categoryName.compareTo((listA[j]! as CategoryPackage.Category).categoryName) <= 0)) {
        listB[k] = listA[i];
        i = i + 1;
      } else {
        listB[k] = listA[j];
        j = j + 1;
      }
    }
  } else {
    //Manoeuvres
    // While there are elements in the left or right runs...
    for (int k = iBegin; k < iEnd; k++) {
      // If left run head exists and is <= existing right run head.
      if (i < iMiddle && (j >= iEnd || (listA[i]! as Manoeuvre).manoeuvreCategory.compareTo((listA[j]! as Manoeuvre).manoeuvreCategory) <= 0)) {
        listB[k] = listA[i];
        i = i + 1;
      } else {
        listB[k] = listA[j];
        j = j + 1;
      }
    }
  }
}

void CopyList<T>(List<T> listA, int iBegin, int iEnd, List<T> listB) {
  for (int k = iBegin; k < iEnd; k++) {
    listB[k] = listA[k];
  }
}
