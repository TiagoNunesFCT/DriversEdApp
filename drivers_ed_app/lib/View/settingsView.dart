import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

import '../Controller/databaseController.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}




class _SettingsPageState extends State<SettingsPage> {


  void initState() {
    super.initState();
    setState(() {});
  }

  void updateState() {

    setState(() {
    });
  }

//This method creates a backup of the entire database
  share() async {
    debugPrint("Create Backup");
    //Get the export directory
    final String directory = (await getApplicationDocumentsDirectory()).path;
    //The default database name and path
    final path = '$directory/students.db';
    //Configure the path and file name of the exported database
    final path2 = '$directory/backup_drivelog_' + DateTime.now().toString() + '.db';
    //fetch existing database as a file
    File db = File(path);
    //copy database to export path
    await db.copySync(path2);

    final String? directoryDownloads = (await getDownloadsDirectory())?.path;
    final path3 = '$directoryDownloads/backup_drivelog_' + DateTime.now().toString() + '.db';
    //copy database to app downloads path
    await db.copySync(path3);

    //display a share intent with the database file attached
    await Share.shareXFiles([XFile(path2)], text: "Database Backup: ");
    //diplay a toast afterwards indicating that the backup has been created
    Fluttertoast.showToast(msg: "Backup Created",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
    debugPrint("Backup Created in : $path2");
    debugPrint("Backup Created in : $path3");
  }

//import an existing database
  importDatabase() async {
    debugPrint("Restore Backup");
    //wait for user to pick the file using the platform's default file picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      //allowedExtensions: ['db'],
      type: FileType.any,
    );

    if(result != null){
    //The fetched file
    File db = File(result!.files!.first!.path!);

    //The default database's path and file name
    final String directory = (await getApplicationDocumentsDirectory()).path;
    final path = '$directory/students.db';
    //Deleting Previous Database From Storage
    await DatabaseController.instance.closeDatabase();
    await deleteDatabase(path);

    //Loading New Database From File
    await db.copySync(path);
    await DatabaseController.instance.openNewDatabase();

    //setting state so settings change immediately
    setState(() {});
  }
    //display a toast informing the user that the import was successful
    Fluttertoast.showToast(msg: "Backup Restored Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget build(BuildContext context) {
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
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .surface,

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        toolbarHeight: 0,
      ),
      body: Container(
          color: Theme
              .of(context)
              .colorScheme
              .background,
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

                    Container(
                        height: 300,
                        width: 250,
                        child: Column(
                          children: [



                            FilledButton.tonal(
                                onPressed: () => importDatabase(),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Icon(Icons.download_rounded),
                                  Container(
                                      width: 170,
                                      child: Text(
                                        "Importar Base de Dados",
                                        textAlign: TextAlign.center,
                                      ))
                                ])),
                            FilledButton.tonal(
                                onPressed: () => share(),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Icon(Icons.upload_rounded),
                                  Container(
                                      width: 170,
                                      child: Text(
                                        "Exportar Base de Dados",
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
                  width: (MediaQuery
                      .of(context)
                      .size
                      .width - 458),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                  child: (Container(
                    child: Column(children: [
                      Container(
                          height: 50,
                          decoration: BoxDecoration(color: Theme
                              .of(context)
                              .colorScheme
                              .secondaryContainer, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
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

                    ]),
                  )),
                ),
              ],
            ),
          )),
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
      debugPrint("Database Purged.");
    });
  }
  void ShowToast(bool isSettings) {
    if (isSettings) {
      Fluttertoast.showToast(msg: "Funcionalidade não implementada", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    } else {
      Fluttertoast.showToast(msg: "Mantenha premido para Apagar...", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    }
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

