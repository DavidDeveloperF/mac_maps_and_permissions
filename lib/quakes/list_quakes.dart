import 'dart:async';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'earthquake_data_model.dart';
//import 'list_quakes_ui.dart';
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
  List<Features> _featuresList = <Features>[];      // initiatise to empty


@override
  void initState() {
    super.initState();
  _quakesData = QuakeNetwork().getAllQuakes();
    setState(() {
      _quakesData.then((quakes) =>       {
        quakes.features.forEach((quake) =>          {
//    If this works, then each quake will be added to the List  _featuresList
          debugPrint(
              '(1) _quakesData setState. _featuresList length= ${_featuresList
                  .length}')
        }) // end forEach
      }); // end of .then
    });   // end of setstate
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
          itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.lightBlueAccent,
            child: Row(
                children: [
                  CircleAvatar(radius: 18, child: Text('$index'),),
                  Text('text card $index features list length= '),
                  Text(_featuresList.length.toString()),
//                Text(_featuresList[0].properties.mag.toStringAsFixed(1)),
                ]
            ),
          );
        }   // end of item builder
        )
        )
      );
    }

    void _getAndLoadQuakeResponse() {
      _featuresList.clear();                            // just in case, empty the List
      debugPrint('(2) _getAndLoadQuakeResponse Clear: ${_featuresList.length.toString()}');
      setState(() {
        _quakesData = QuakeNetwork().getAllQuakes();
        _loadQuakeResponse();
        debugPrint('(3)_getAndLoadQuakeResponse featureList ? ${_featuresList.length.toString()}');
      });
    }

    // ########################################################## load Quake Features
    // ########################################## equivalent to update quake markers
    void _loadQuakeResponse() {
      debugPrint('(4)_loadQuakeResponse featuresList length: ${_featuresList.length.toString()}');

      setState(() {
        _quakesData.then((quakes) => {
          quakes.features.forEach((quake) => {            // forEach - loops through data
            _featuresList.add(
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


}
