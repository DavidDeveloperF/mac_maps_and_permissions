import 'dart:async';
import 'package:flutter/material.dart';
import "package:google_maps_flutter/google_maps_flutter.dart";
import 'package:intl/intl.dart';

//import 'package:mac_maps_and_permissions/main.dart';
import 'earthquake_data_model.dart';
import 'list_quakes.dart';
import 'quake_network.dart';
import 'package:mac_maps_and_permissions/settings.dart';


//  ################################################################ Stateless top menu & MateriaApp
class QuakeMapTop extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ///////////////////////////////////////////////////////////////////////////
    //  Changed the MaterialApp return to a Scaffold
    //  this DOES allow the back buttons to work
    //  so seems I should only use the MaterialApp once at the top of the tree.....
    return Scaffold(
      appBar: AppBar(
        title: Text("Earthquakes last 2 days",),
        actions: [
          IconButton(
            icon: Icon(Icons.access_alarms),
            onPressed: () {
              Navigator.pop(context);               // doesn't work........
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => SettingsTopMenu()));
            },  // onPressed
          )
        ], //actions

      ),//      title: 'Map Demo',
//      theme: ThemeData(
//        primarySwatch: Colors.green,
//        visualDensity: VisualDensity.adaptivePlatformDensity,
//      ),
      body: QuakeMapMenu(),
    );
  }
}

//  ################################################################ Stateful top
class QuakeMapMenu extends StatefulWidget {
  @override
  _QuakeMapMenuState createState() => _QuakeMapMenuState();
}

//  ################################################################ State
class _QuakeMapMenuState extends State<QuakeMapMenu> {
  // the future quake comes back with data when the external source sends it to use
  //        defined here,   used with the .then
  Future<EarthquakeData> _quakeData;
  // the Completer is another 'future' but we initiate it
  //      https://api.flutter.dev/flutter/dart-async/Completer-class.html
  // also defined here amd similarly used with a 'future
  Completer<GoogleMapController> _controller = Completer();
  //    Markers are the 'flags' displayed on the map
  // this is a List of them
  List<Marker> markerList = <Marker>[];          // Empty list of map markers
  double currentZoom = 2.5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _quakeData = QuakeNetwork().getAllQuakes();
    _quakeData.then((values) => {
      debugPrint('Place: ${values.features[0].properties.title}')     // never seem to get here
      // debugPrint('Place: ${values.features[0].geometry.coordinates[0]}')
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      Don't put an app bar here if the parent has one.......
//      appBar: AppBar(
//          title: Text("Earthquakes prior 2 days ($appVersion)",),
//          actions: [
//            IconButton(
//            icon: Icon(Icons.add_shopping_cart),
//              onPressed: () {
//              Navigator.pop(context);               // doesn't work........
////                MaterialPageRoute(builder: (context) => MyListViewDetails()));
//      },
      // onPressed
//    )
//    ], //actions
//
//    ),
        body: Stack(
            children: <Widget>[
              // ######################################################## actual screen built is separate [Below]
              _buildGMap(context),
              // ######################################################## zoom buttons are fiddly to implement
              // ######################################################## Google map actually has it's own + - zoom anyway
              _zoomIn(),
              _zoomOut(),
            ]
        ),
//      floatingActionButton: FloatingActionButton.extended(
//          onPressed: () {
//            findQuakes();
//            displaySnackbar(context);
//          },
//        label: Text('Earthquakes')
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.yellowAccent,      // these are very poor color combinations
          selectedItemColor: Colors.redAccent,      // also fontsize, icontheme, labelstyle
          unselectedItemColor: Colors.black, // also fontsize, icontheme, labelstyle
          iconSize: 12.5,
          // bottom nav must have at least 2 items
          items: [
            BottomNavigationBarItem( icon: Icon(Icons.control_point_duplicate),
                // title: Text(bottomMapButtonText00)),
                label: bottomMapButtonText00),
            BottomNavigationBarItem( icon: Icon(Icons.landscape),
                // title: Text(bottomMapButtonText00)),
                label: bottomMapButtonText01),
            BottomNavigationBarItem( icon: Icon(Icons.arrow_back),
                // title: Text(bottomMapButtonText00)),
                label: bottomMapButtonText02),
          ],
          // notice the bottom navigator only calls one function (passing index for the option)
          onTap: (int index) {
            // debugPrint('Tapped item: $index');
            botomMapNavFunction(index);
          },
        )

    );
  }

  // ########################### Zoom out buttons/icons ########################
  Widget _zoomOut() {
    return Padding(
      // ######################################################## this padding seems to affect the map
      padding: const EdgeInsets.only(bottom: 88.0),
      child: Align(
          alignment: Alignment.bottomLeft,
          child: IconButton(
            // splashColor: Colors.amber,
            color: Colors.redAccent,
            onPressed: ()  {
              currentZoom++;              // decrease zoom
              _mapZoom(currentZoom);
            },
            icon: Icon(Icons.search),
          )
      ),
    );
  }
  //  ################## Zoom in button/icon ########################
  Widget _zoomIn() {
    return Padding(
      // ######################################################## this padding seems to affect the map
      padding: const EdgeInsets.only(bottom: 68.0),
      child: Align(
          alignment: Alignment.bottomLeft,
          child: IconButton(
            // splashColor: Colors.amber,
            color: Colors.redAccent,
            onPressed: ()  {
              currentZoom--;              // increase zoom
              _mapZoom(currentZoom);
            },
            icon: Icon(Icons.control_point),
          )
      ),
    );
  }

  //  ############################################ Actually build the map display ########################
  Widget _buildGMap(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 2.0, ),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GoogleMap(
            mapType: displayMapType,
            // ######################################### display quake data
            markers: Set<Marker>.of(markerList),   //  Markers = quakes
            initialCameraPosition: CameraPosition(
              zoom: 2.5,                            // hard code the zoom level
              target: quakeLocation,                // TODO: ought to be current location or view
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          )
      ),
    );
  }

  //  ############################################ refresh map when zoom changes
  Future<void> _mapZoom(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: quakeLocation, zoom: zoomVal)
        ));
  }

  // get new Quake data (took off the floating button - it overlapped map controls)
  void findQuakes() {
    setState(() {
      markerList.clear();        // Make sure list if empty before we load anything
      _handleResponse();          // load new data into list
    });
  }

  // ########################################################## update quake markers
  void _handleResponse() {
//    String _formatttedDateTime = "";
    setState(() {
      _quakeData.then((quakes) => {
        quakes.features.forEach((quake) {            // forEach - loops through data
          debugPrint('_handleResponse: **' +
              " Magnitude: " + quake.properties.mag.toStringAsFixed(1) +
              ' Quake properties time: ' +
              getFormattedDate(DateTime.fromMillisecondsSinceEpoch(quake.properties.time)) +
              "  " + quake.properties.place);
          markerList.add(Marker(
              markerId: MarkerId(quake.id),
              //                      note API give Long then Lat within co-ordinates
              position: LatLng(quake.geometry.coordinates[1], quake.geometry.coordinates[0]),
              infoWindow: InfoWindow(title: quake.properties.mag.toString(),
                  snippet:  getFormattedDate(DateTime.fromMillisecondsSinceEpoch(quake.properties.time))
                      + " || "+ quake.properties.place),
//            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
              icon: BitmapDescriptor.defaultMarkerWithHue(getQuakeIconHue(quake.properties.mag))
            ) // end marker
          );  // end .add
          // MyQuakeDetail _qk = MyQuakeDetail(
          //   mag:
          // );
         myQuakeDetailList.add(MyQuakeDetail(
                mag: quake.properties.mag,
                place: quake.properties.place,
                time: quake.properties.time,
                updated: quake.properties.updated,
                detail: quake.properties.detail,
                url: quake.properties.url,
                tz: quake.properties.tz,
                )          );
            }   // end of code
          )    // end of ForEach loop
        // so here we have loaded all quakes into the markerList
      });     // end of .then
   // try to SORT the my list
   // todo this sort doesn't seem to be working with a.mag
      myQuakeDetailList.sort((a, b) => a.time.compareTo(b.time)); // LIST SORT (on the above combined sort field) 
      debugPrint(">>> myQuakeDetailList.length = " + myQuakeDetailList.length.toString() );
    });
  }

// tried moving this to the Get Quakes button
  //  WORKED TODAY  !  10Jun230 - no idea what changed
  void displaySnackbar(BuildContext context) {

    final snackbar = SnackBar(content: Text(quakeSourceTitle),
      duration: Duration(seconds: 4),);
    debugPrint("SNACKBAR >>> myQuakeDetailList.length = " + myQuakeDetailList.length.toString() );

    Scaffold.of(context).showSnackBar(snackbar);
  }

// ###########################################################   BOTTOM BUTTONS
//  I HAVE THREE BUTTONS AT THE BOTTOM - not all used
  botomMapNavFunction (int index) {
    switch (index) {
      case 0:                       // Remember, the index starts at ZERO
        debugPrint('0) Tapped item: $index');
        findQuakes();
        displaySnackbar(context);
        break;
      case 1:
        debugPrint('1) Tapped item: $index');     // QuakeMapTop
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => QuakeList()));
        break;
      case 2:
        debugPrint('2) Tapped item: $index');
        Navigator.pop(context);                    // TODO: not working
        break;
      case 3:
        debugPrint('3) Tapped item: $index');
        break;
      case 4:
        debugPrint('4) Tapped item: $index');
        break;
      case 5:           // not sure if you can have this many items
        debugPrint('5) Tapped item: $index');
        break;
      default:        // ???  REALLY - don't expect to get here
        debugPrint('WHAT? Unexpected Tapped item: $index');
        break;
    }
  }
}



// ###################################### Quake icon colors ############################
// Want to have bright red colour for big quakes, down to green for tiny ones
double getQuakeIconHue(double mag) {
  if (mag > 5.99) {
    return BitmapDescriptor.hueRed;}
  else if (mag > 5.0) {
    return BitmapDescriptor.hueBlue;}
  else if (mag > 4.0) {
    return BitmapDescriptor.hueCyan;}
  else {
    return BitmapDescriptor.hueGreen;
  }
}

String getFormattedDate(DateTime dateTime) {
  return new DateFormat("EEE HH:mm").format(dateTime);
}