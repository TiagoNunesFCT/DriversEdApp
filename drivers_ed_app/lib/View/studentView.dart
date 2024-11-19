import 'dart:collection';
import 'dart:ffi';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:drivers_ed_app/Model/lesson.dart';
import 'package:drivers_ed_app/Model/manoeuvre.dart';
import 'package:drivers_ed_app/View/settingsView.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marquee/marquee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../Controller/databaseController.dart';
import '../Controller/importHandler.dart';
import '../Model/category.dart' as CategoryPackage;
import '../Model/exam.dart';
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SettingsPage()),
                              ).then((_) {
                                updateState();
                              });
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
                                          updateStateCallback();
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
                                onPressed: () => importCSVFile(),
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
                                onPressed: () => exportCSVFile(),
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
                                onLongPress: () {
                                  showPurgeDatabaseDialog();
                                },
                                onPressed: () {
                                  ShowToast(false);
                                },
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
      builder: (BuildContext context) => WeekDialog(DateTime.now(), context),
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

  void showPurgeDatabaseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => FullDeleteConfirmationDialog(purgeDatabase),
    );
  }

  //this method purges the entire database, except for settings.
  purgeDatabase() {
    setState(() {
      DatabaseController.instance.deleteAllExams();
      DatabaseController.instance.deleteAllLessons();
      DatabaseController.instance.deleteAllStudents();
      DatabaseController.instance.deleteAllManoeuvres();
      DatabaseController.instance.deleteAllCategories();
      updateStateCallback();
      debugPrint("Database Purged.");
    });
  }

  //Export all students as a .csv file
  exportCSVFile() async {
    debugPrint("Export Students");


    late List<Student> listStudents;

    listStudents = [];
    addToList(Map<String, dynamic> map) {
      if (Student.fromMap(map).studentName.toLowerCase().contains(searchQuery.trim().toLowerCase()) || Student.fromMap(map).studentRegistrationNumber.toString().toLowerCase().contains(searchQuery.trim().toLowerCase())) {
        listStudents.add(Student.fromMap(map));
        listStudents.sort((a, b) => a.studentRegistrationNumber.compareTo(b.studentRegistrationNumber));
      }
    }


    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllRowsStudents();
    setState(() {
      listMap?.forEach((map) => addToList(map));
    });


    //The "Matrix" of strings, each one corresponding to an individual cell of the .csv file
    List<List<String>> data = [];
    //The first line, which contains the separator
    List<String> sepLine = [];
    sepLine.add("sep=");
    sepLine.add("");
    data.add(sepLine);
    //The Header Lines
    //'Name','RegistrationNumber','RegistrationDate','Category','Lessons','Exams'
    List<String> headerData = [];

    /*
    headerData.add('Name');
    headerData.add('RegistrationNumber');
    headerData.add('RegistrationDate');
    headerData.add('Category');
    headerData.add('Lessons');
    headerData.add('Exams');
    */
    headerData.add('Nome');
    headerData.add('Número de Inscrição');
    headerData.add('Data de Inscrição');
    headerData.add('Categoria');
    headerData.add('Lições');
    headerData.add('Exames');
    data.add(headerData);
    //The Remaining Lines
    for (Student s in listStudents) {
      List<String> studentData = [];
      studentData.add(s.studentName);
      studentData.add(s.studentRegistrationNumber.toString());
      studentData.add(s.studentRegistrationDate.toString());
      studentData.add(s.studentCategory);
      //Now, it will be difficult to compress a Student's Lessons and Exams in Two Different Strings. Nonetheless, by using custom separators, we might be able to parse them out when importing.
      studentData.add(await stringifyStudentsLessons(s));
      studentData.add(await stringifyStudentsExams(s));

      data.add(studentData);
    }

    //Convert it to .csv
    String csvData = ListToCsvConverter().convert(data);
    //Get the platform-correct directory
    final String? directory = Platform.isIOS ? (await getApplicationDocumentsDirectory()).path : (await getExternalStorageDirectory())?.path;
    //configure the path and file name
    final path = "$directory/student-list-${DateTime.now()}.csv";
    debugPrint("CSV Export path: $path");
    //Create the file
    final File file = File(path);
    //And write to it
    await file.writeAsString(csvData);
    //Show success toast
    Fluttertoast.showToast(msg: "Students Exported", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    //Note: for old functionality comment the two lines below:
    //Show share intent
    await Share.shareXFiles([XFile(path)], text: "Student Export: ");
  }

  //Import .csv File with Students(s)
  importCSVFile() async {
    debugPrint("Import Students");
    //wait for user to pick the file using the platform's default file picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      //allowedExtensions: ['csv'],
      type: FileType.any,
    );
    if(result != null){
    //The fetched file
    String path = result!.files!.first!.path!;
    //Call the import handler to handle the import
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return ImportHandler(path: path);
        },
      ),
    );
    setState(() {});
  }
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
              Student studentToBeAdded = Student(studentName: studentName.text.trim(), studentRegistrationNumber: int.parse(studentNumber.text.trim()), studentRegistrationDate: widget.currentDate.millisecondsSinceEpoch.toDouble(), studentCategory: widget.currentCategory);
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
              CategoryPackage.Category categoryToBeAdded = CategoryPackage.Category(categoryName: categoryName.text.trim(), categoryDescription: categoryDescription.text.trim());
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

class EditCategoryDialog extends StatefulWidget {
  void Function() updateStateCallback;
  CategoryPackage.Category category;

  EditCategoryDialog(this.updateStateCallback, this.category, {super.key});

  @override
  EditCategoryDialogState createState() => EditCategoryDialogState();
}

class EditCategoryDialogState extends State<EditCategoryDialog> {
  late CategoryPackage.Category stateCategory;

  late TextEditingController categoryName;
  late TextEditingController categoryDescription;

  @override
  void initState() {
    super.initState();
    stateCategory = widget.category;
    categoryName = TextEditingController(text: stateCategory.categoryName);
    categoryDescription = TextEditingController(text: stateCategory.categoryDescription);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const Text(
        "Editar Categoria",
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
              CategoryPackage.Category categoryToBeAdded = CategoryPackage.Category(categoryId: stateCategory.categoryId, categoryName: categoryName.text, categoryDescription: categoryDescription.text);
              DatabaseController.instance.updateCategory(categoryToBeAdded.toMap());
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
}

class CategoryDetailsDialog extends StatelessWidget {
  CategoryPackage.Category category;

  CategoryDetailsDialog(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const Text(
        "Detalhes",
      ),
      content: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: Theme.of(context).colorScheme.onInverseSurface,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  height: 50,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      "Nome da Categoria: ",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                    Text(
                      category.categoryName,
                      style: TextStyle(fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.inverseSurface),
                      textAlign: TextAlign.right,
                    )
                  ])),
              SizedBox(height: 5),
              SizedBox(height: 5),
              Container(
                  height: 50,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      "Descrição: ",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                    Text(
                      category.categoryDescription,
                      style: TextStyle(fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.inverseSurface),
                      textAlign: TextAlign.right,
                    )
                  ])),
            ],
          )),
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
              Container(width: 100, child: Text("Nome", textAlign: TextAlign.center)),
              Text(
                "|",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
              ),
              Container(width: 400, child: Text("Descrição", textAlign: TextAlign.center)),
              Text(
                "|",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
              ),
              Container(width: 70, child: Text("Ações", textAlign: TextAlign.center)),
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
  BuildContext context;

  WeekDialog(this.date, this.context, {super.key});

  @override
  _WeekDialogState createState() => _WeekDialogState();

  void showNextWeekDialog() {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) => WeekDialog(this.date.add(Duration(days: 7)), context),
    );
  }

  void showPreviousWeekDialog() {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) => WeekDialog(this.date.subtract(Duration(days: 7)), context),
    );
  }
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
            width: 1100,
            child: WeekDisplay(date: widget.date),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 1100,
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
          Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            IconButton.filledTonal(
                onPressed: () {
                  widget.showPreviousWeekDialog();
                },
                icon: Icon(Icons.keyboard_arrow_left_rounded)),
            IconButton.filledTonal(
                onPressed: () {
                  widget.showNextWeekDialog();
                },
                icon: Icon(Icons.keyboard_arrow_right_rounded))
          ]),
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
    getLessonsAndExams();
  }

  Map<LessonOrExam, Student> lessons = {};
  List<DateTime> dates = [];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: dates
          .map((item) => Container(
              margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
              padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
              decoration: BoxDecoration(
                color: (roundDateTime(item).toString() == roundDateTime(DateTime.now()).toString()) ? Theme.of(context).colorScheme.tertiaryContainer : Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (roundDateTime(item).toString() == roundDateTime(DateTime.now()).toString()) ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondaryContainer,
                  width: 1,
                ),
              ),
              child: TextButton(
                  style: ButtonStyle(
                      padding: MaterialStatePropertyAll(
                    EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  )),
                  onPressed: () {
                    showDayDialog(item, lessons);
                  },
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Container(
                        width: 130,
                        child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          Text(
                            weekdayString(item, false),
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
                                .where((item3) => roundDateTime(item).toString() == roundDateTime(DateTime.fromMillisecondsSinceEpoch(item3.date.toInt())).toString())
                                .map((item2) => Container(
                                    height: 20,
                                    child: Marquee(
                                      //temporarily using the manoeuvres field to store whether if these "lessons" are actual lessons or exams. These values will never be read outside of this dialog, and even if they were, the lesson hasn't started yet, and as such it does not have a manoeuvres field
                                      text: (item2.isLesson) ? "${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(item2.date.toInt()))} | Aula | ${lessons[item2]!.studentName} | " : "${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(item2.date.toInt()))} | Exame | ${lessons[item2]!.studentName} | ",
                                      style: (item2.isLesson) ? TextStyle(fontWeight: FontWeight.w400) : TextStyle(fontWeight: FontWeight.w900),
                                    )))
                                .toList()))
                  ]))))
          .toList(),
    );
  }

  void getDates(DateTime date) {
    for (int i = 0; i < 7; i++) {
      dates.add(date.add(Duration(days: i)));
    }
  }

  //Async version of the getLessonsAndExams method
  // ignore: missing_return
  Future<List<Map<String, dynamic>>?> getLessonsAndExams() async {
    lessons = {};
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllLessonsBetween(dates[0], dates[dates.length - 1]);
    setState(() {
      listMap?.forEach((map) => addToListLesson(map));
    });
    List<Map<String, dynamic>>? listMapExam = await DatabaseController.instance.queryAllExamsBetween(dates[0], dates[dates.length - 1]);
    setState(() {
      listMapExam?.forEach((map) => addToListExam(map));
    });
  }

  //Method that adds Lessons to the List, in case they are compliant with the search criteria
  addToListLesson(Map<String, dynamic> map) {
    //if (DateTime.fromMillisecondsSinceEpoch(Lesson.fromMap(map).lessonDate.toInt()).isAfter(other) || Student.fromMap(map).studentRegistrationNumber.toString().toLowerCase().contains(searchQuery.trim().toLowerCase())) {
    int number = Lesson.fromMap(map).lessonStudentId;

    getStudentsWithNumber(number, Lesson.fromMap(map));

    //}
  }

  //Method that adds Exams to the List, in case they are compliant with the search criteria
  addToListExam(Map<String, dynamic> map) {
    //if (DateTime.fromMillisecondsSinceEpoch(Lesson.fromMap(map).lessonDate.toInt()).isAfter(other) || Student.fromMap(map).studentRegistrationNumber.toString().toLowerCase().contains(searchQuery.trim().toLowerCase())) {
    int number = Exam.fromMap(map).examStudentId;

    getStudentsWithNumberExam(number, Exam.fromMap(map));

    //}
  }

  //Async version of the getStudents method, that only returns students with a certain registration Number
  Future<List<Map<String, dynamic>>?> getStudentsWithNumber(int number, Lesson lesson) async {
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllStudentsWithId(number);
    setState(() {
      listMap?.forEach((map) => addToListStudent(map, LessonOrExam.fromLesson(lesson)));
    });
  }

  //Async version of the getStudents method, that only returns students with a certain registration Number (Exam version)
  Future<List<Map<String, dynamic>>?> getStudentsWithNumberExam(int number, Exam exam) async {
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllStudentsWithId(number);
    setState(() {
      listMap?.forEach((map) => addToListStudent(map, LessonOrExam.fromExam(exam)));
    });
  }

  //Method that adds Students to the List, in case they are compliant with the search criteria, ordered by dateTime
  addToListStudent(Map<String, dynamic> map, LessonOrExam lesson) {
    lessons.addEntries([MapEntry(lesson, Student.fromMap(map))]);

    var sorted = lessons.entries.toList()..sort((a, b) => a.value.studentRegistrationNumber.compareTo(b.value.studentRegistrationNumber));
    lessons = {for (var entry in sorted) entry.key: entry.value};
  }

  void showDayDialog(DateTime dayDate, Map<LessonOrExam, Student> lessons) {
    showDialog(
      context: context,
      builder: (BuildContext context) => DayDialog(dayDate, lessons),
    );
  }
}

class DayDialog extends StatefulWidget {
  DateTime date;
  Map<LessonOrExam, Student> lessons;

  DayDialog(this.date, this.lessons, {super.key});

  @override
  _DayDialogState createState() => _DayDialogState();
}

class _DayDialogState extends State<DayDialog> {
  _DayDialogState();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        "${DateFormat('yyyy-MM-dd').format(widget.date)} | ${weekdayString(widget.date, true)}",
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
              width: 400,
              height: 200,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
                  padding: EdgeInsets.all(5),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.lessons.keys
                              .where((item3) => roundDateTime(widget.date).toString() == roundDateTime(DateTime.fromMillisecondsSinceEpoch(item3.date.toInt())).toString())
                              .map((item2) => Container(
                                      child: Text(
                                    //temporarily using the manoeuvres field to store whether if these "lessons" are actual lessons or exams. These values will never be read outside of this dialog, and even if they were, the lesson hasn't started yet, and as such it does not have a manoeuvres field
                                    formatLessonDetails(item2, widget.lessons[item2]!.studentName),
                                    style: (item2.isLesson) ? TextStyle(fontWeight: FontWeight.w400) : TextStyle(fontWeight: FontWeight.w900),
                                  )))
                              .toList())))),
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

  String formatLessonDetails(LessonOrExam lesson, String studentName) {
    String output = "";
    String trueOrFalseDone = (lesson.done > 0) ? "Sim" : "Não";

    if (lesson.isLesson) {
      if (lesson.done < 1) {
        output = "${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(lesson.date.toInt()))}\nAula\n${studentName}\nCategoria: ${lesson.category}\nRealizada? $trueOrFalseDone\n";
      } else {
        output = "${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(lesson.date.toInt()))}\nAula\n${studentName}\nCategoria: ${lesson.category}\nRealizada? $trueOrFalseDone\nDuração da Aula: ${lesson.hours} h\nDistância Total: ${lesson.distance} km\nManobras:\n${GetManoeuvres(lesson)}\n";
      }
    } else {
      String trueOrFalsePassed = (lesson.passed! > 0) ? "Sim" : "Não";
      output = "${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(lesson.date.toInt()))}\nExame\n${studentName}\nCategoria: ${lesson.category}\nRealizado? $trueOrFalseDone\nAprovado? $trueOrFalsePassed\n";
    }

    return output;
  }

  String GetManoeuvres(LessonOrExam lesson) {
    String returnString = "";
    for (String lessonName in lesson.manoeuvres!.split(';')) {
      if (lessonName.isNotEmpty) {
        returnString += lessonName + "\n";
      }
    }

    //this can be done better, perhaps with a counter keeping track of the current index, but here's how I remove the last linebreak:
    if (returnString.isNotEmpty && returnString.length >= 1) {
      returnString = returnString.substring(0, returnString.length - 1);
    }
    if (returnString.isEmpty) {
      returnString = "Nenhuma Manobra Definida";
    }
    return returnString;
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
        "Nova Manobra",
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
              Manoeuvre manoeuvreToBeAdded = Manoeuvre(manoeuvreName: manoeuvreName.text.trim(), manoeuvreCategory: widget.currentCategory);
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

class EditManoeuvreDialog extends StatefulWidget {
  void Function() updateStateCallback;
  Manoeuvre manoeuvre;
  late String manoeuvreCategory;

  EditManoeuvreDialog(this.updateStateCallback, this.manoeuvre, {super.key}) {
    manoeuvreCategory = manoeuvre.manoeuvreCategory;
  }

  @override
  EditManoeuvreDialogState createState() => EditManoeuvreDialogState(manoeuvre);
}

class EditManoeuvreDialogState extends State<EditManoeuvreDialog> {
  late Manoeuvre stateManoeuvre;

  TextEditingController manoeuvreName = TextEditingController(text: "");

  EditManoeuvreDialogState(this.stateManoeuvre) {
    manoeuvreName = TextEditingController(text: stateManoeuvre.manoeuvreName);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const Text(
        "Editar Manobra",
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
              currentValue: widget.manoeuvreCategory,
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
              Manoeuvre manoeuvreToBeAdded = Manoeuvre(manoeuvreId: stateManoeuvre.manoeuvreId, manoeuvreName: manoeuvreName.text, manoeuvreCategory: widget.manoeuvreCategory);
              DatabaseController.instance.updateManoeuvre(manoeuvreToBeAdded.toMap());
              Navigator.of(context).pop();
              setState(() {
                debugPrint("CLICKED ON CONFIRM BUTTON");
                widget.updateStateCallback();
              });
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
    widget.manoeuvreCategory = newCategory;
    if (kDebugMode) {
      debugPrint("CHANGED CATEGORY TO... " + newCategory);
    }
  }
}

class ManoeuvreDetailsDialog extends StatelessWidget {
  Manoeuvre manoeuvre;

  ManoeuvreDetailsDialog(this.manoeuvre, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: AlertDialog(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const Text(
        "Detalhes",
      ),
      content: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: Theme.of(context).colorScheme.onInverseSurface,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  height: 50,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      "Categoria: ",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                    Text(
                      manoeuvre.manoeuvreCategory,
                      style: TextStyle(fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.inverseSurface),
                      textAlign: TextAlign.right,
                    )
                  ])),
              SizedBox(height: 5),
              SizedBox(height: 5),
              Container(
                  height: 50,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      "Nome da Manobra: ",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                    Text(
                      manoeuvre.manoeuvreName,
                      style: TextStyle(fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.inverseSurface),
                      textAlign: TextAlign.right,
                    )
                  ])),
            ],
          )),
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
              Container(width: 100, child: Text("Categoria", textAlign: TextAlign.center)),
              Text(
                "|",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
              ),
              Container(width: 400, child: Text("Nome", textAlign: TextAlign.center)),
              Text(
                "|",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height: -0.1),
              ),
              Container(width: 70, child: Text("Ações", textAlign: TextAlign.center)),
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

//The dialog that shows up asking if the user is really sure that they want to delete a category/manoeuvre
class DeleteConfirmationDialog extends StatelessWidget {
  void Function<T>(T) updateStateCallback;

  //is it a category (0 - false) or a manoeuvre (1 - true)?
  bool isManoeuvre = false;

  //can either be a category or a manoeuvre. However, it is only here so it can be passed back to the callback function, since by default it doesn't know which exact category or manoeuvre we want to delete, as this process is done dynamically upon list building
  dynamic objectToDelete;

  DeleteConfirmationDialog(this.updateStateCallback, this.isManoeuvre, this.objectToDelete, {super.key});

  @override
  Widget build(BuildContext context) {
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
                      "Tem a certeza que pretende eliminar a ${(isManoeuvre) ? "Manobra" : "Categoria"} selecionada?",
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

//The dialog that shows up asking if the user is really sure that they want to delete THE ENTIRE DATABASE
class FullDeleteConfirmationDialog extends StatelessWidget {
  void Function() updateStateCallback;

  FullDeleteConfirmationDialog(this.updateStateCallback, {super.key});

  @override
  Widget build(BuildContext context) {
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
                      "Tem a certeza que pretende eliminar todos os dados da Aplicação?",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20, height: 1.5, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                    Text(
                      "Esta ação é irreversível!",
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
              updateStateCallback();
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
      listStudents.sort((a, b) => a.studentRegistrationNumber.compareTo(b.studentRegistrationNumber));
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
  //The list of Categories to be shown on the Widget
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
                  onPressed: () {
                    showCategoryDetailsDialog(getCategory);
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
                      onPressed: () {
                        showEditCategoryDialog(updateStateCallback, getCategory!);
                      },
                      icon: Icon(Icons.mode_edit_outline_rounded),
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                    child: IconButton.filledTonal(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        showDeleteCategoryDialog(getCategory!);
                      },
                      icon: Icon(Icons.delete_forever_rounded),
                    ))
              ]);
            }));
  }

  //Type had to be obfuscated since dart was not letting me insert this into the DeleteConfirmationDialog function call
  void deleteCategory<T>(T getCategory) {
    //delete category getCategory
    //update state
    DatabaseController.instance.deleteCategory((getCategory as CategoryPackage.Category).categoryId!);
    updateStateCallback();
  }

  void showDeleteCategoryDialog(CategoryPackage.Category category) {
    showDialog(
      context: context,
      builder: (BuildContext context) => DeleteConfirmationDialog(deleteCategory, false, category),
    );
  }

  void showEditCategoryDialog(void Function() updateStateCallbackFunction, CategoryPackage.Category category) {
    showDialog(
      context: context,
      builder: (BuildContext context) => EditCategoryDialog(updateStateCallbackFunction, category),
    );
  }

  //SetState Callback
  void updateStateCallback() {
    updateState();
  }

  void showCategoryDetailsDialog(CategoryPackage.Category category) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CategoryDetailsDialog(category),
    );
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
  //The list of Manoeuvres to be shown on the Widget
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
                    showManoeuvreDetailsDialog(getManoeuvre);
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
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: IconButton.filledTonal(
                      style: ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        showEditManoeuvreDialog(updateStateCallback, getManoeuvre!);
                      },
                      icon: Icon(Icons.mode_edit_outline_rounded),
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                    child: IconButton.filledTonal(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        //delete manoeuvre getManoeuvre
                        //update state
                        showDeleteManoeuvreDialog(getManoeuvre);
                      },
                      icon: Icon(Icons.delete_forever_rounded),
                    ))
              ]);
            }));
  }

  void showEditManoeuvreDialog(void Function() updateStateCallbackFunction, Manoeuvre manoeuvre) {
    showDialog(
      context: context,
      builder: (BuildContext context) => EditManoeuvreDialog(updateStateCallbackFunction, manoeuvre),
    );
  }

  //Type had to be obfuscated since dart was not letting me insert this into the DeleteConfirmationDialog function call
  void deleteManoeuvre<T>(T getManoeuvre) {
    //delete manoeuvre getManoeuvre
    //update state
    DatabaseController.instance.deleteManoeuvre((getManoeuvre as Manoeuvre).manoeuvreId!);
    updateStateCallback();
  }

  void showDeleteManoeuvreDialog(Manoeuvre manoeuvre) {
    showDialog(
      context: context,
      builder: (BuildContext context) => DeleteConfirmationDialog(deleteManoeuvre, true, manoeuvre),
    );
  }

  //SetState Callback
  void updateStateCallback() {
    updateState();
  }

  void showManoeuvreDetailsDialog(Manoeuvre manoeuvre) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ManoeuvreDetailsDialog(manoeuvre),
    );
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
String weekdayString(DateTime dateTime, bool long) {
  DateTime roundedDateTime = roundDateTime(dateTime);

  if (long) {
    //to enable compatibility with other languages, the check must be done here, perhaps with an additional switch, or use constants on the language pack
    String result = "Domingo";
    switch (roundedDateTime.weekday) {
      case DateTime.sunday:
        result = "Domingo";
        break;
      case DateTime.monday:
        result = "Segunda";
        break;
      case DateTime.tuesday:
        result = "Terça";
        break;
      case DateTime.wednesday:
        result = "Quarta";
        break;
      case DateTime.thursday:
        result = "Quinta";
        break;
      case DateTime.friday:
        result = "Sexta";
        break;
      case DateTime.saturday:
        result = "Sábado";
        break;
      default:
        result = "Domingo";
        break;
    }

    return result;
  } else {
//to enable compatibility with other languages, the check must be done here, perhaps with an additional switch, or use constants on the language pack
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
}

//TODO: WHEN DELETING A STUDENT, DELETE ALL THEIR LESSONS AND EXAMS. THIS WILL CLEAN THE DATABASE, PREVENTING IT FROM BECOMING BLOATED WITH OLD LESSONS.
//TODO: Possibly make it so that when a manoeuvre is renamed, the app goes through all existing lessons and changes the name of the manoeuvre, if they have it, to the new name. Do the same for categories.
//oldTODO: What happens when a category is deleted? Delete students? Or keep them, like I do for delete manoeuvres? //Update: No. I'm gonna keep them as they are, there's no sense in deleting them just because their category has been deleted.

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

void ShowToast(bool isSettings) {
  if (isSettings) {
    Fluttertoast.showToast(msg: "Funcionalidade não implementada", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
  } else {
    Fluttertoast.showToast(msg: "Mantenha premido para Apagar...", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
  }
}

class LessonOrExam {
  //A copy of the attributes present in both the lesson and exam classes. This hybrid class will be used exclusively within this file, for read-only purposes, and thus won't be saved on the database and, therefore, won't need none of that serialization nonsense.
  late int? id;
  late int studentId;
  late double date;
  late double? hours, distance;
  late int done;
  late int? passed; //technically booleans, but since sqlite does not support booleans, they'll be integers that oscillate between 0 and 1, to be parsed locally when needed. To prevent unnecessary conversions, we'll keep the same type as the database values.
  late String? manoeuvres;
  late String category;
  late bool isLesson;

  LessonOrExam({this.id, required this.studentId, required this.date, required this.done, required this.category, required this.isLesson});

  LessonOrExam.fromLesson(Lesson lesson) {
    id = lesson.lessonId;
    studentId = lesson.lessonStudentId;
    date = lesson.lessonDate;
    hours = lesson.lessonHours;
    distance = lesson.lessonDistance;
    done = lesson.lessonDone;
    manoeuvres = lesson.lessonManoeuvres;
    category = lesson.lessonCategory;
    isLesson = true;
  }

  LessonOrExam.fromExam(Exam exam) {
    id = exam.examId;
    studentId = exam.examStudentId;
    date = exam.examDate;
    passed = exam.examPassed;
    done = exam.examDone;
    category = exam.examCategory;
    isLesson = false;
  }
}


//Methods to convert a Student's Lessons and Exams into a single String
Future<String> stringifyStudentsLessons(Student student) async {
  String output = "";
   List<Lesson> listLessons = [];

  //Method that adds Lessons to the List, in case they are compliant with the search criteria
  addToListLesson(Map<String, dynamic> map) {
    debugPrint("LESSON FOUND IN DATABASE! Student ID is: " + Lesson.fromMap(map).lessonStudentId.toString());
    listLessons.add(Lesson.fromMap(map));
    debugPrint("List sorted, current order is:");
    listLessons.forEach((element) {
      debugPrint("Element: ${element.lessonDate}");
    });
  }

  //Async version of the getLessons method.
  // This is a copy of the one in the LessonsList widget.
  // ignore: missing_return
  Future<List<Map<String, dynamic>>?> getLessons() async {
    listLessons = [];
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllLessonsFromStudent(student.studentRegistrationNumber);

      listMap?.forEach((map) => addToListLesson(map));

  }

  await getLessons();
  for(Lesson l in listLessons){
    debugPrint("LESSON FOUND IN DATABASE (LOCATION 2)");
    output += "%LESSONSTART%${l.lessonDate}%${l.lessonHours}%${l.lessonDistance}%${l.lessonDone}%${l.lessonManoeuvres}%${l.lessonCategory}";
  }

return output;
}

Future<String> stringifyStudentsExams(Student student) async {
  String output = "";
  List<Exam> listExams = [];

  //Method that adds Exams to the List, in case they are compliant with the search criteria
  addToListExam(Map<String, dynamic> map) {
    debugPrint("EXAM FOUND IN DATABASE! Student ID is: " + Exam.fromMap(map).examStudentId.toString());
    listExams.add(Exam.fromMap(map));
    debugPrint("List sorted, current order is:");
    listExams.forEach((element) {
      debugPrint("Element: ${element.examDate}");
    });
  }

  //Async version of the getExams method.
  // This is a copy of the one in the ExamsList widget.
  // ignore: missing_return
  Future<List<Map<String, dynamic>>?> getExams() async {
    listExams = [];
    List<Map<String, dynamic>>? listMap = await DatabaseController.instance.queryAllExamsFromStudent(student.studentRegistrationNumber);

    listMap?.forEach((map) => addToListExam(map));

  }

  await getExams();
  for(Exam e in listExams){
    debugPrint("EXAM FOUND IN DATABASE (LOCATION 2)");
    output += "%EXAMSTART%${e.examDate}%${e.examDone}%${e.examPassed}%${e.examCategory}";
  }

  return output;
}
