//
//  Network and version values
//
//import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:location/location.dart';                    // date formats
// my code

// core data               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
String currentUser   = "dummy userId";            // user id
String currentName   = "dummy user name";         // user's display name
String currentDeviceId = "dummy deviceId";        // device id
String currentDeviceDetails = "device ???";       // device id
String currentRegion = "n/a";                     // if applicable

// location data (optional) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const appKnowsLocation    = false;
//-3.066396071097825, 37.355198102518735          // Mt Kilimanjaro
double currentLat    =  -3.0674;                  // lat
double currentLng    =  37.35519;                 // long
String currentLocationText = "Mt Kilimanjaro";
//Location currentLocation = new Location();


// date formats for logging and display            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
final String  appDateFmt      = "EEE dd-MMM-yy HH:mm";
final String  appDateFmtShort = "EEE HH:mm";
const int longFutureDate = 9000111222333;   // used to create descending date keys


// internet speeds           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
double currentDownloadSpeed = 3.14159;
double currentUploadSpeed   = 3.14159;
String downloadProgress = '0';
String uploadProgress = '0';
String currentSpeedUnits = " Mbps";

// Firebase ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bool isFirebaseDBUsed = false;         // don't try to use db if not implemented


// build and package data  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//                         todo: update appName for iOS (see Known issue on pub.dev)
const String kappNameiOS = "Hard code the appName here, since package_info can't get it on iOS";
String appName        = "Network Connection Tracker";
String appVersion     = "??";
String appPackageName = "package name";
String appBuildNumber = "package build number";

// my debug logging         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
String whereAmI       = "debug location not set";
const bool printDebugMessage    = true;
const bool logDebugMessage      = false;
String liveOrTest = "";                     // append to AppBar title "" or "Test"
