import 'package:drivers_ed_app/Controller/databaseController.dart';
import 'package:flutter/material.dart';

import '../Model/student.dart';

String searchQuery = "";

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





  @override
  Widget build(BuildContext context) {
    TextEditingController studentName = new TextEditingController(text: searchQuery);
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
            Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                        child: IconButton.filled(
                          icon: const Icon(Icons.settings_rounded),
                          color: Theme.of(context).colorScheme.background,
                          tooltip: 'Definições',
                          onPressed: () {
                            setState(() {});
                          },
                          padding: EdgeInsets.all(12.0),
                        )),
                    Container(
                        width: 400,
                        height: 50,
                        child: TextField(
                            controller: studentName,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                overflow: TextOverflow.fade,
                              ),
                              prefixIcon: Container(
                                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 1.0, 0.0),
                                  child: IconButton.filled(
                                    icon: const Icon(Icons.search_rounded),
                                    color: Theme.of(context).colorScheme.background,
                                    tooltip: 'Pesquisar',
                                    onPressed: () {
                                      setState(() {
                                        searchQuery = studentName.text;
                                        print(searchQuery);
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
                ),
                Container(
                    height: 300, width: 250,
                    child: Column(
                      children: [
                        FilledButton.tonal(onPressed: () {}, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.person_add), Container(width:170, child:Text("Novo Aluno", textAlign: TextAlign.center,))])),
                        FilledButton.tonal(onPressed: () {}, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.minor_crash_rounded), Container(width:170, child:Text("Nova Categoria", textAlign: TextAlign.center,))])),
                        FilledButton.tonal(onPressed: () {}, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.add_road_rounded), Container(width:170, child:Text("Nova Manobra", textAlign: TextAlign.center,))])),
                        FilledButton.tonal(onPressed: () {}, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.download_rounded), Container(width:170, child:Text("Importar Alunos", textAlign: TextAlign.center,))])),
                        FilledButton.tonal(onPressed: () {}, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.upload_rounded), Container(width:170, child:Text("Exportar Alunos", textAlign: TextAlign.center,))])),
                        FilledButton.tonal(onPressed: () {}, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.delete_forever_rounded), Container(width:170, child:Text("Apagar Tudo", textAlign: TextAlign.center,))])),
                      ],
                    )),                    SizedBox(width: 50, height: 50)
              ],
            ),
            Container(width:(MediaQuery.of(context).size.width -458), padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0), child:(Container(child:Column(children:[Container(height:50, child:Container(child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children:[Container(width: 80,child:Text("Aluno Nº",textAlign: TextAlign.center)), Text("|", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height:-0.1 ),), Container(width:300,child:Text("Nome Completo",textAlign: TextAlign.center)), Text("|", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height:-0.1 ),),Container(width:150, child:Text("Data de Inscrição",textAlign: TextAlign.center)), Text("|", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100, height:-0.1 ),), Container(width:70, child:Text("Categoria",textAlign: TextAlign.center))])), decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer,
                 borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)))),Container(height:(MediaQuery.of(context).size.height -86), child:StudentsList())]),decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(20)),
            )),),
          ],
        ),
      ),
    );
  }
}

//The dynamic Waypoints List widget
class StudentsList extends StatefulWidget {




  StudentsList(){

  }




  @override
  State<StatefulWidget> createState() {
    return StudentsListState();
  }

  State<StatefulWidget> updateState() {
    return StudentsListState();
  }
}

//State
class StudentsListState extends State<StudentsList> {
  //The list of Students to be shown on the Widget
  List<Student> listStudents = [];



  StudentsListState(){

  }

  //Async version of the getStudents method
  // ignore: missing_return
  Future<List<Map<String, dynamic>>?> getStudents() async {
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
    getStudents();
    super.initState();
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
          return TextButton(onLongPress: (){
          setState(() {});},
            onPressed: () {  },
          child:Container(
              color: const Color(0xFF242933),
              padding: EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color:Colors.blueGrey.shade700,
                    ),
                    borderRadius: BorderRadius.circular(3),
                    gradient: LinearGradient(
                      begin: new Alignment(0.0, -3),
                      end: Alignment.bottomCenter,
                      colors:
                          const [
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
                        child:
                        /*IconButton( //old functionality
                          icon: Icon(Icons.edit),
                          color: Colors.blueGrey.shade700,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        AddEditWaypoint(true, getWaypoint)));
                          })*/
                        IconButton(
                            icon: Icon(Icons.info_outline_rounded),
                            color: Colors.blueGrey.shade700,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => StudentPage()/*waypointDetails(getWaypoint, listWaypoints)*/));
                            }),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child:
                      /*IconButton( //old functionality
                        icon: Icon(Icons.delete),
                        color: Colors.blueGrey.shade700,
                        onPressed: () {
                          DatabaseHelper.instance.delete(getWaypoint.waypId);
                          setState(() => {
                                listWaypoints.removeWhere(
                                    (item) => item.waypId == getWaypoint.waypId)
                              });
                        })*/
                      IconButton(
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