import 'dart:async';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'earthquake_data_model.dart';
//import 'list_quakes_ui.dart';
import 'quake_map.dart';
import 'quake_network.dart';
//import 'package:mac_maps_and_permissions/settings.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

class QuakeList extends StatefulWidget {
  @override
  _QuakeListState createState() => _QuakeListState();
}

class _QuakeListState extends State<QuakeList> {
  Future<EarthquakeData> _quakesData;
//  var firestoreDb = Firestore.instance.collection(firestoreTopPath).snapshots();
  List<Features> featuresList = <Features>[];      // initiatise to empty


@override
  void initState() {
    super.initState();
//   _quakesData = QuakeNetwork().getAllQuakes();
//     setState(() {
//       _quakesData.then((quakes) =>       {
//         quakes.features.forEach((quake) =>          {
// //    If this works, then each quake will be added to the List  featuresList
// //           featuresList.add(Features(
// //             a
// //           ))
//           debugPrint(
//               '(1) _quakesData setState. featuresList length= ${featuresList
//                   .length}')
//         }) // end forEach
//       }); // end of .then
//     });   // end of setstate
//     debugPrint(
//         '(2) _quakesData end of initState. featuresList length= ${featuresList
//             .length}');
  } // end of initstate


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quake list #appVersion#"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              // Navigator.pop(context);             // WORKING !
              // debugPrint ('(1a _QuakeListState - button pressed');
              _getAndLoadQuakeResponse();             // NOT WORKING !
            },
            // onPressed
          )
        ], //actions
      ),
      body: Container(
      //  child: Text("test text"),
        // todo: need a list builder to load a the correct list to card
      child: ListView.builder(
          itemCount: myQuakeDetailList.length,
        itemBuilder: (BuildContext context, int _index) {
// // No data ????
//           if(myQuakeDetailList.length ==0) {
//             return Text("No quake data loaded...");
//           }
// Else we do have data
            return Card(
            color: Colors.lightBlueAccent,
            child: 
            ListTile(
            onTap: () {
              workingQuakeDetailIndex = _index;
              workingQuakeDetail = myQuakeDetailList[_index];
              // workingQuakeDetailChanged = false; // do we need to save it....?
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuakeDetails()));
            },
            title:

            Row(
                  children: [
                    CircleAvatar(radius: 18, backgroundColor: getQuakeMagColor(myQuakeDetailList[_index].mag),
                child: Text(myQuakeDetailList[_index].mag.toStringAsFixed(1)),),
//          Problems with overflow - this 'dirty' fix is to substring the text I want and limit the length
//          todo: ought to limit the size with a width based on the screen width, but can't be bothered today
                    Text((getFormattedDate(DateTime.fromMillisecondsSinceEpoch(myQuakeDetailList[_index].time)) +
                          " | " +
                          myQuakeDetailList[_index].place +
                          "                                                    ").substring(0,42)
                        ),
                  ]
              ),
            ),
          );
        }   // end of item builder
        )
        )
      );
    }

    void _getAndLoadQuakeResponse() {
      featuresList.clear();                            // just in case, empty the List
      debugPrint('(2) _getAndLoadQuakeResponse Clear: ${featuresList.length.toString()}');
      setState(() {
        _quakesData = QuakeNetwork().getAllQuakes();
        _loadQuakeResponse();
        debugPrint('(3)_getAndLoadQuakeResponse featureList ? ${featuresList.length.toString()}');
      });
    }

    // ########################################################## load Quake Features
    // ########################################## equivalent to update quake markers
    void _loadQuakeResponse() {
      debugPrint('(4)_loadQuakeResponse featuresList length: ${featuresList.length.toString()}');

      setState(() {
        _quakesData.then((quakes) => {
          quakes.features.forEach((quake) => {            // forEach - loops through data
            featuresList.add(
              Features(type: quake.type,
                  properties: quake.properties,
                  id: quake.id,
                  geometry: quake.geometry),
            )
          })    // end of ForEach loop
          // so here we have loaded all quakes into the markerList
        });     // end of .then
      });
    }

} // end of _QuakeListState

class QuakeDetails extends StatefulWidget {
  @override
  _QuakeDetailsState createState() => _QuakeDetailsState();
  
}

class _QuakeDetailsState extends State<QuakeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quake details..")),
      body: 
      SwipeGestureRecognizer(
        onSwipeLeft: ()  {swipeLeftOrClickNext();},
        onSwipeRight: () {swipeRightOrClickPrevious();},
    child:
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
            children: <Widget>[
              Text("Item: ${workingQuakeDetailIndex+1} of ${myQuakeDetailList.length}"),
              Text(" "),                 // sloppy coding as a spacer
              Row(children: <Widget>[
                  Text("Time:        "),
                Text(getFormattedDate(DateTime.fromMillisecondsSinceEpoch(workingQuakeDetail.time))),
                ], ),
              Row(children: <Widget>[
                  Text("place:       "),
                  Text(workingQuakeDetail.place),
                ], ),
              Row(children: <Widget>[
                  Text("location:    "),
                  Text(workingQuakeDetail.lat.toStringAsFixed(4)),
                  Text(" / "),
                  Text(workingQuakeDetail.lng.toStringAsFixed(4)),
                ], ),
              Row(children: <Widget>[
                  Text("Magnitude:   "),
                  Text(workingQuakeDetail.mag.toStringAsFixed(2)),
                ], ),
//            Text(workingQuakeDetail.tz + " Details: " ),    .tz appears to be null
              Text("Details: " ),
              FlatButton(
                  onPressed:() {
                    launchURL(workingQuakeDetail.detail);
                  },
                  child: Text(workingQuakeDetail.detail))
              ,
            ],
          ),
    ),
      ),
    );
  }

// pull out common code from navigator function to allow swipe to use it too
  // swipe right is 'back' or 'previous', so decrease index
void swipeRightOrClickPrevious() {
  if (workingQuakeDetailIndex >= 1) {
    setState(() {
      debugPrint("swipe right - index: ${workingQuakeDetailIndex+1} of ${myQuakeDetailList.length}");
      workingQuakeDetailIndex = workingQuakeDetailIndex - 1;
      workingQuakeDetail = myQuakeDetailList[workingQuakeDetailIndex];
    });
  }
}

  // swipe left is 'forward' or 'next', so increase index
void swipeLeftOrClickNext() {
  if (workingQuakeDetailIndex + 1 < myQuakeDetailList.length) {
    setState(() {
      debugPrint("swipe left - index: ${workingQuakeDetailIndex+1} of ${myQuakeDetailList.length}");
      workingQuakeDetailIndex = workingQuakeDetailIndex + 1;
      workingQuakeDetail = myQuakeDetailList[workingQuakeDetailIndex];
    });
  }
}

}

void launchURL(String url) async {
  debugPrint("url: $url  launchUrl")  ;

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

