import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Controller/databaseController.dart';
import '../Model/category.dart' as CategoryPackage;
import '../Model/student.dart';

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

  StudentsList studentsList = StudentsList();

  void initState() {
    super.initState();
    setState(() {});
  }


  void updateState() {
    debugPrint("BAN BAN 1");

    setState(() {_StudentsListKey.currentState!.updateState();});

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
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.background,

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        toolbarHeight: 0,
      ),
      body: Center(
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
                      child: IconButton.filled(
                        icon: const Icon(Icons.settings_rounded),
                        color: Theme.of(context).colorScheme.background,
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
                            contentPadding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                            hintStyle: const TextStyle(
                              fontStyle: FontStyle.italic,
                              overflow: TextOverflow.fade,
                            ),
                            prefixIcon: Container(
                                margin: const EdgeInsets.fromLTRB(0.0, 0.0, 1.0, 0.0),
                                child: IconButton.filled(
                                  icon: const Icon(Icons.search_rounded),
                                  color: Theme.of(context).colorScheme.background,
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
                              color: Theme.of(context).colorScheme.primary,
                              tooltip: 'Limpar Pesquisa',
                              onPressed: () {
                                setState(() {
                                  searchQuery = "";
                                });
                              },
                            ),
                            hintText: 'Pesquisar Aluno...',
                            border: OutlineInputBorder(
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
                        FilledButton.tonal(
                            onPressed: () {showAddCategoryDialog();},
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Icon(Icons.minor_crash_rounded),
                              Container(
                                  width: 170,
                                  child: Text(
                                    "Nova Categoria",
                                    textAlign: TextAlign.center,
                                  ))
                            ])),
                        FilledButton.tonal(
                            onPressed: () {},
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Icon(Icons.add_road_rounded),
                              Container(
                                  width: 170,
                                  child: Text(
                                    "Nova Manobra",
                                    textAlign: TextAlign.center,
                                  ))
                            ])),
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
                decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(20)),
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
                  Container(height: (MediaQuery.of(context).size.height - 86), child: StudentsList(key: _StudentsListKey,))
                ]),
              )),
            ),
          ],
        ),
      ),
    );
  }

  //SetState Callback
  void updateStateCallback(){
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
}







class AddStudentDialog extends StatefulWidget {
  DateTime currentDate = DateTime.now();
  late String currentDateString = currentDate.toIso8601String().split('T').first;
  late String currentCategory = "A";

  void Function() updateStateCallback;

  AddStudentDialog(this.updateStateCallback,  {super.key}){

  }

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
                  labelText: "Número de Inscrição",
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  contentPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(90.0)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(90.0)),
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
                  labelText: "Nome Completo",
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  contentPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(90.0)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(90.0)),
                ),
              )),
          Row(children: [
            Container(padding: EdgeInsets.all(5.0), child: Text("Data de Inscrição")),
            Container( margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0), child:OutlinedButton(
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
              callback: (String s) => changeCategory(s), currentValue: widget.currentCategory,
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
                          labelText: "Nome da Categoria",
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          contentPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(90.0)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(90.0)),
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
                          labelText: "Descrição (ex: Ligeiros)",
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          contentPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(90.0)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(90.0)),
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
                    onPressed: () {                CategoryPackage.Category categoryToBeAdded = CategoryPackage.Category(categoryName: categoryName.text, categoryDescription: categoryDescription.text);
                    DatabaseController.instance.insertCategory(categoryToBeAdded.toMapWithoutId());
                    Navigator.of(context).pop();
                    setState(() {
                    });},
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

  _PopupMenuExampleState(this.currentValue){

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
        icon: Container(margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),width:41, height:40, decoration: BoxDecoration(

            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(90),

          ),alignment: Alignment.center, child:Text(currentValue)),
        initialValue: "A",
        onSelected: (value) {

          currentValue= value;
          debugPrint("BOINGUS $value selected...");
          setState(() {});},
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

//The dynamic Waypoints List widget
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
  void updateState(){
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
          var studentNumber = getStudent.studentRegistrationNumber.toStringAsFixed(2);
          var studentName = getStudent.studentName;
          return TextButton(
            onLongPress: () {
              setState(() {});
            },
            onPressed: () {},
            child: Container(
                color: const Color(0xFF242933),
                padding: EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.blueGrey.shade700,
                      ),
                      borderRadius: BorderRadius.circular(3),
                      gradient: LinearGradient(
                        begin: new Alignment(0.0, -3),
                        end: Alignment.bottomCenter,
                        colors: const [
                          Color(0xFF242933),
                          Color(0xFF242933),
                        ],
                      ),
                      color: Colors.blue),
                  height: 80,
                  padding: EdgeInsets.all(15),
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                              width: 240,
                              child: Text(getStudent.studentName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 18,
                                    color: const Color(0xFFD8DEE9),
                                    fontWeight: FontWeight.w300,
                                  )))),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(right: 45),
                          child: IconButton(
                              icon: Icon(Icons.info_outline_rounded),
                              color: Colors.blueGrey.shade700,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => StudentPage() /*waypointDetails(getWaypoint, listWaypoints)*/));
                              }),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            icon: Stack(children: [
                              Icon(Icons.map_outlined),
                              Icon(
                                Icons.location_on_outlined,
                                size: 19,
                                color: const Color(0xFF242933),
                              ),
                              SizedBox(height: 19, width: 19, child: Icon(Icons.location_on_outlined, size: 16))
                            ]),
                            color: Colors.blueGrey.shade700,
                            onPressed: () {}),
                      ),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text("Número: $studentNumber | Nome: $studentName",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 18,
                                color: const Color(0xFFD8DEE9),
                                fontWeight: FontWeight.w300,
                              ))),
                    ],
                  ),
                )),
          );
        });
  }
}
