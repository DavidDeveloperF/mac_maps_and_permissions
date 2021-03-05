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
final LatLng vanuatuCentre = const LatLng(15.37, 166.95);   // set map center point 1.0.0+2
final LatLng homeLocation = const LatLng(51.4650, -0.2760); // set map center point
LatLng quakeLocation = LatLng(51.442, -0.2761);             // set map center point
double quakeDefaultZoom = 3.5;                              // Very zoomed out to start
double quakeZoomedIn    = 10.5;                             // zoom In when user selects a specific quake
double currentZoom = quakeDefaultZoom;                      // starts zoomed out

final String quakeSourceURL = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson";
final String quakeSourceTitle = "USGS Magnitude 2.5+ Earthquakes, Past Day";

String quakeSortSequence = "B";             // a - alphabetical
                                            // b - magnitude (largest to smallest)
                                            // d - date (newest to oldest)
                                            // l - location (lat+lng)


// DONE:  move these 'variables' into a file of  static variables               ~~~~~~
const String  quakeSettingsTitle          ="quakeSettings Stateful Menu";
const String  quakeSettingsBodyText00     ="quakeSettings Stateful Menu - body text 1";
const String  quakeSettingsBodyText01     ="basic text in centre of column";
const String  quakeSettingsBotNavText00   ="But 0";
const String  quakeSettingsBotNavText01   ="But 1";
const String  quakeSettingsBotNavText02   ="But 2";
const String  quakeSettingsBotNavText03   ="But 3";
const Icon    quakeSettingsBotNavIcon00   = Icon(Icons.ac_unit);
const Icon    quakeSettingsBotNavIcon01   = Icon(Icons.backpack);
const Icon    quakeSettingsBotNavIcon02   = Icon(Icons.check_circle);
const Icon    quakeSettingsBotNavIcon03   = Icon(Icons.delete);
const String  quakeSettingsFloatText      ="Float";
const Icon    quakeSettingsFloatIcon      = Icon(Icons.edit);
const Icon    quakeSettingsAppBarIcon00   = Icon(Icons.queue_music);
const Color   quakeSettingsScaffoldBackground  = Colors.yellowAccent;
// let's assume ALL the appBars share the same colours
const Color   appBarIconColor     = Colors.black;
const Color   appBarBackground    = Colors.green;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

bool sortPrintDebug = true;
double displayZoom = 13.5;                                  // very zoomed in
MapType displayMapType = MapType.normal;                    // should be available in settings
MapType displaySatellite = MapType.satellite;               // should be available in settings
MapType displayHybrid  = MapType.hybrid;                    // various options
MapType displayTerrain = MapType.terrain;                   // this is good
MapType displayNormal  = MapType.normal;                    // alternatively
void changeMapType(String mapTypeString) {
  switch (mapTypeString) {
    case "normal":
      displayMapType = displayNormal;
      break;
    case "hybrid":
      displayMapType = displayHybrid;
      break;
    case "satellite":
      displayMapType = displaySatellite;
      break;
    case "terrain":
      displayMapType = displayTerrain;
      break;
    default:
      displayMapType = displayNormal;
      break;
  } // end of switch

} // end of changemaptype
