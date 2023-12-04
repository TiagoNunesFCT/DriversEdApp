import 'package:flutter/material.dart';

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
  int _counter = 0;
  String searchQuery = "";



  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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
          children: [
            Column(
              children: [
                Container(
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children:[Container( padding:EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0) ,child:IconButton.filled(
                    icon: const Icon(Icons.settings_rounded),
                    color: Theme.of(context).colorScheme.background,
                    tooltip: 'Definições',
                    onPressed: () {
                      setState(() {});
                    },

                    padding: EdgeInsets.all(12.0),
                  )),                Container(width: 400, height: 50,
                      child: TextField(


                        controller: studentName,

                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),

                          hintStyle: TextStyle(fontStyle: FontStyle.italic, overflow: TextOverflow.fade,),
                          prefixIcon: Container(margin: EdgeInsets.fromLTRB(0.0, 0.0, 1.0, 0.0), child:IconButton.filled(

                            icon: const Icon(Icons.search_rounded),
                            color: Theme.of(context).colorScheme.background,
                            tooltip: 'Pesquisar',
                            onPressed: () {
                              setState(() { searchQuery = studentName.text; print(searchQuery);});
                            },
                          )),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            color: Theme.of(context).colorScheme.primary,
                            tooltip: 'Limpar Pesquisa',
                            onPressed: () {
                              setState(() {searchQuery = "";});
                            },
                          ),

                          hintText: 'Pesquisar Aluno...',
                          border: OutlineInputBorder( borderRadius: BorderRadius.circular(90.0),


                        ),
                      )))]),
                ),

              ],
            ),
            Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              //
              // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
              // action in the IDE, or press "p" in the console), to see the
              // wireframe for each widget.
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
