import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mac_maps_and_permissions/quakes/quake_map.dart';
import 'package:mac_maps_and_permissions/quakes/quake_settings_menu.dart';
import 'package:mac_maps_and_permissions/settings.dart';
import 'package:mac_maps_and_permissions/utils/dbadmin_class.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Mac Map & Permissions'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  // final String  mapAPI = "AIzaSyB74AyQiBalZjfcnCbFbjDmQL4skNWjf7I";
  // final String quakeSourceURL = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson";
  // final String quakeSourceTitle = "USGS Magnitude 2.5+ Earthquakes, Past Day";


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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Refreshed: ' + DateFormat("EEE HH:mm").format(DateTime.now())),
            Text(
              'You have pushed the + button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            RaisedButton(color: Colors.blue,
              child: Text("Earthquakes"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QuakeMapTop()));
                //    Navigator.of(context).pop(); 
                }
            ),

            RaisedButton(color: Colors.lightGreenAccent,
              child: Text("Settings"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QuakeSettingsStatefulMenu()));
                //    Navigator.of(context).pop(); 
                }
            ),
            RaisedButton(color: Colors.orangeAccent,
              child: Text("Test DbAdmin"),
              onPressed: () {
                testDbAdmin();
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => QuakeSettingsStatefulMenu()));
                //    Navigator.of(context).pop(); 
                }
            ),

// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Moved to QuakeSettingsStatefulMenu
// //      Ok, here's a dirty way to color the buttons green when this option set
// //          each button appears twice
// //      xxxx: a clean method would set the actual color as a function
// //            eg  color: greenIfMapTypIsThisOption("normal")
//             if (displayMapType == displayNormal) RaisedButton(
//                   child: Text("Map type - normal"),
//                   color: Colors.lightGreen,
//                   onPressed: () {setState(() {changeMapType("normal");}); }
//                   ),
//             if (displayMapType != displayNormal) RaisedButton(
//                   child: Text("Map type - normal"),
//                   color: Colors.grey,
//                 onPressed: () {setState(() {changeMapType("normal");}); }
//             ),
//             if (displayMapType == displaySatellite) RaisedButton(
//                   child: Text("Map type - satellite"),
//                   color: Colors.lightGreen,
//                   onPressed: () {setState(() {changeMapType("satellite");}); }
//                   ),
//             if (displayMapType != displaySatellite) RaisedButton(
//                   child: Text("Map type - satellite"),
//                   color: Colors.grey,
//                 onPressed: () {setState(() {changeMapType("satellite");}); }
//             ),
//             if (displayMapType == displayHybrid) RaisedButton(
//                   child: Text("Map type - hybrid"),
//                   color: Colors.lightGreen,
//                   onPressed: () {setState(() {changeMapType("hybrid");}); }
//                   ),
//             if (displayMapType != displayHybrid) RaisedButton(
//                   child: Text("Map type - hybrid"),
//                   color: Colors.grey,
//                 onPressed: () {setState(() {changeMapType("hybrid");}); }
//             ),
//             if (displayMapType == displayTerrain) RaisedButton(
//                   child: Text("Map type - terrain"),
//                   color: Colors.lightGreen,
//                   onPressed: () {setState(() {changeMapType("terrain");}); }
//                   ),
//             if (displayMapType != displayTerrain) RaisedButton(
//                   child: Text("Map type - terrain"),
//                   color: Colors.grey,
//                 onPressed: () {setState(() {changeMapType("terrain");}); }
//             ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
