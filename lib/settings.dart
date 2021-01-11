import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final String  appVersion = "0.01a";
final String  appVersionNotes = "releaseNoteList[0].appVersionNotes";
// ###############################  Main Page - bottom row buttons
final String appBarButText00 = "Settings";
final Icon appBarButIcon = Icon(Icons.settings);
// ###############################  Main Page - bottom row buttons
final String  mainBotButText00 = "Board";
final String  mainBotButText01 = "Quakes";
final String  mainBotButText02 = "Richmond Park";
final Icon  mainBotButIcon00 = Icon(Icons.library_books);
final Icon  mainBotButIcon01 = Icon(Icons.perm_media);
final Icon  mainBotButIcon02 = Icon(Icons.map);
// ###############################  Quake Page - bottom row buttons
final String  bottomMapButtonText00 = "Get Quakes";
final String  bottomMapButtonText01 = "List";
final String  bottomMapButtonText02 = "Go Back";

final String firestoreTopPath = "board";

//   ############### themes & colors
final Color themeBackgroundColor = Colors.greenAccent;
final Color themeBackgroundColor2 = Colors.green;


final String  mapAPI = "AIzaSyB74AyQiBalZjfcnCbFbjDmQL4skNWjf7I";
// Richmond Park (roughly Pen Ponds)
final LatLng centerMap = const LatLng(51.442, -0.2761);     // set map center point
final LatLng homeLocation = const LatLng(51.4650, -0.2760);  // set map center point
final LatLng quakeLocation = const LatLng(36.6762, 139.6560);  // set map center point

final String quakeSourceURL = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson";
final String quakeSourceTitle = "USGS Magnitude 2.5+ Earthquakes, Past Day";


double displayZoom = 13.5;                                  // very zoomed in
//MapType displayMapType = MapType.hybrid;                    // various options
//MapType displayMapType = MapType.satellite;                 // should be available in settings
//MapType displayMapType = MapType.terrain;                   // this is good
MapType displayMapType = MapType.normal;                    // alternatively