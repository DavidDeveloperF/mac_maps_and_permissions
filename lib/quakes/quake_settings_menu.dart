import 'package:flutter/material.dart';
import '../settings.dart';
import 'package:mac_maps_and_permissions/settings.dart';


// ############################################################################# quakeSettings Stateful Menu
class QuakeSettingsStatefulMenu extends StatefulWidget {
  @override
  _QuakeSettingsStatefulMenuState createState() => _QuakeSettingsStatefulMenuState();
}

// ############################################################################# _quakeSettings Stateful Menu State
class _QuakeSettingsStatefulMenuState extends State<QuakeSettingsStatefulMenu> {
  String whereAmI = quakeSettingsTitle + " #state";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ####################################################################### appBar
      appBar: AppBar(
        actions: [
          IconButton(icon: quakeSettingsAppBarIcon00,
              color: appBarIconColor,
              onPressed: () {
                dummyFunction("calledFrom AppBar");         // dummy code
              }),
        ],
        title: Text(quakeSettingsTitle),
        backgroundColor: appBarBackground,
      ),
      // ####################################################################### body
      backgroundColor: quakeSettingsScaffoldBackground,
      body:
      Container(
        color: Colors.deepOrange[600],
        //TODO want to do something here to size the container to match the screen
        child:
        SingleChildScrollView(                                                // added the scroll view to make it fit
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(children: <Widget>[
                Text(quakeSettingsBodyText00),
                Text(quakeSettingsBodyText01),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Column(
                    children: [
                      Text("Map Types"),
                      if (displayMapType == displayNormal) RaisedButton(
                          child: Text("Normal"),
                          color: Colors.lightGreen,
                          onPressed: () {setState(() {changeMapType("normal");}); }
                      ),
                      if (displayMapType != displayNormal) RaisedButton(
                          child: Text("Normal"),
                          color: Colors.grey,
                          onPressed: () {setState(() {changeMapType("normal");}); }
                      ),
                      if (displayMapType == displaySatellite) RaisedButton(
                          child: Text("Satellite"),
                          color: Colors.lightGreen,
                          onPressed: () {setState(() {changeMapType("satellite");}); }
                      ),
                      if (displayMapType != displaySatellite) RaisedButton(
                          child: Text("Satellite"),
                          color: Colors.grey,
                          onPressed: () {setState(() {changeMapType("satellite");}); }
                      ),
                      if (displayMapType == displayHybrid) RaisedButton(
                          child: Text("Hybrid"),
                          color: Colors.lightGreen,
                          onPressed: () {setState(() {changeMapType("hybrid");}); }
                      ),
                      if (displayMapType != displayHybrid) RaisedButton(
                          child: Text("Hybrid"),
                          color: Colors.grey,
                          onPressed: () {setState(() {changeMapType("hybrid");}); }
                      ),
                      if (displayMapType == displayTerrain) RaisedButton(
                          child: Text("Terrain"),
                          color: Colors.lightGreen,
                          onPressed: () {setState(() {changeMapType("terrain");}); }
                      ),
                      if (displayMapType != displayTerrain) RaisedButton(
                          child: Text("Terrain"),
                          color: Colors.grey,
                          onPressed: () {setState(() {changeMapType("terrain");}); }
                      ),                    ],
                  ),
                  Text("___"),
                  Column(
                    children: [
                      Text("Sort Sequence"),
                      if (quakeSortSequence == "A") RaisedButton(
                          child: Text("by Place"),
                          color: Colors.lightGreen,
                          onPressed: () {setState(() {quakeSortSequence="A";}); }
                      ),
                      if (quakeSortSequence != "A") RaisedButton(
                          child: Text("by Place"),
                          color: Colors.grey,
                          onPressed: () {setState(() {quakeSortSequence="A";sortPrintDebug=true;}); }
                      ),
                      if (quakeSortSequence == "B") RaisedButton(
                          child: Text("by Magnitude"),
                          color: Colors.lightGreen,
                          onPressed: () {setState(() {quakeSortSequence="B";}); }
                      ),
                      if (quakeSortSequence != "B") RaisedButton(
                          child: Text("by Magnitude"),
                          color: Colors.grey,
                          onPressed: () {setState(() {quakeSortSequence="B";sortPrintDebug=true;}); }
                      ),
                      if (quakeSortSequence == "D") RaisedButton(
                          child: Text("by Date"),
                          color: Colors.lightGreen,
                          onPressed: () {setState(() {quakeSortSequence="D";}); }
                      ),
                      if (quakeSortSequence != "D") RaisedButton(
                          child: Text("by Date"),
                          color: Colors.grey,
                          onPressed: () {setState(() {quakeSortSequence="D";sortPrintDebug=true;}); }
                      ),
                      if (quakeSortSequence == "L") RaisedButton(
                          child: Text("by lat/lng"),
                          color: Colors.lightGreen,
                          onPressed: () {setState(() {quakeSortSequence="L";}); }
                      ),
                      if (quakeSortSequence != "L") RaisedButton(
                          child: Text("by lat/lng"),
                          color: Colors.grey,
                          onPressed: () {setState(() {quakeSortSequence="L";sortPrintDebug=true;}); }
                      ),

                    ],
                  ),

                ],),

              ]),
            ),
          ),
        ),
      ),
      // ####################################################################### Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
          iconSize: 12.5,
          // bottom nav must have at least 2 items
          items: [
            BottomNavigationBarItem(icon: quakeSettingsBotNavIcon00, label: quakeSettingsBotNavText00 ),
            BottomNavigationBarItem(icon: quakeSettingsBotNavIcon01, label: quakeSettingsBotNavText01 ),
            BottomNavigationBarItem(icon: quakeSettingsBotNavIcon02, label: quakeSettingsBotNavText02 ),
            // doesn't display at all on Android with the 4th button/item
            // BottomNavigationBarItem(icon: quakeSettingsBotNavIcon03, label: quakeSettingsBotNavText03 ),
          ],
          // notice the bottom navigator only calls one function (passing index for the option)
          onTap: (int index) {
//        debugPrint('$_localAppCode Tapped item: $index');
            quakeSettingsBotNavBarFunction(index);
          }),
      // ####################################################################### Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => dummyFunction(quakeSettingsFloatText),                    // <<<<<<<< this will be a test
        tooltip:     quakeSettingsFloatText,
        child:       quakeSettingsFloatIcon,
      ),

    );
  }



// ############################################################################  quakeSettingsBotNavBarFunction
// # quakeSettingsBotNavBarFunction
// # NOTE: this is INSIDE the stateful code (so it can share the context, etc)
// #############################################################################
  void quakeSettingsBotNavBarFunction(int _index) {
    whereAmI = "quakeSettingsBotNavBarFunction";

    switch (_index) {
      case 0:                           // Remember, the index starts at ZERO
        dummyFunction(whereAmI);
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => DummyMenu()));
        break;
      case 1:
        dummyFunction(whereAmI);
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => DummyMenu()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DummyMenu()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DummyMenu()));
        break;
      default: // ???  REALLY - don't expect to get here
        myDebugPrint('** $whereAmI ..WHAT?? Unexpected Tapped item: $_index', whereAmI, false );
        break;
    }
  }
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ dummy code
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void dummyFunction(String calledFrom) {
  String whereAmI = "dummyFunction";
  myDebugPrint("dummyFunction called from $calledFrom", whereAmI, false);
}

class DummyMenu extends StatefulWidget {
  @override
  _DummyMenuState createState() => _DummyMenuState();
}

class _DummyMenuState extends State<DummyMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dummy Menu"),),
      body: Container(
        child:
        Text("_DummyMenuState"),
      ),
    );
  }
}


void myDebugPrint(String _msg, String _calledFrom, _isCritical) {
  if (_isCritical) {
    debugPrint("** $quakeSettingsTitle / $_calledFrom / $_msg");}
}