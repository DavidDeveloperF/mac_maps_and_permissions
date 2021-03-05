# mac_maps_and_permissions

version: 1.0.0+3
================
* Warning from Github that I 'published' an API key
    Managed to get maps working on iPhone !
        DONE: need  **/AppDelegate.swift in the .gitignore file (don't want to put API key into Github)
* tried to improve the sort and added buttons to choose map type, but seem to have broken the map
    I need to review the changes & try to figure out what I've done wrong.
    This error is probably the cause:

    ======== Exception caught by gesture ===============================================================
    The following RangeError was thrown while handling a gesture:
    RangeError (index): Invalid value: Valid value range is empty: 0
    When the exception was thrown, this was the stack:
    #0      List.[] (dart:core-patch/growable_array.dart:177:60)
    #1      _QuakeMapMenuState._handleResponse.<anonymous closure> (package:mac_maps_and_permissions/quakes/quake_map.dart:269:138)
    #2      State.setState (package:flutter/src/widgets/framework.dart:1244:30)
    #3      _QuakeMapMenuState._handleResponse (package:mac_maps_and_permissions/quakes/quake_map.dart:225:5)
    #4      _QuakeMapMenuState.findQuakes.<anonymous closure> (package:mac_maps_and_permissions/quakes/quake_map.dart:218:7)

    Not clear what is causing this, but I suspect the API has not loaded the data to trying to loop
    through an empty data set. Might need to use an async or future. When I press a second time, it
    does seem to work (now after undoing a few recent edits.)  Not sure, but might have always had
    this problem...

version: 1.0.0+2
================
* updated map centre to new variable centred on Vanuatu
* added in a detail screen for quake list
* added in swipegesture to move through on the details screen
* tried to allow link to url in 'details'
    ====================================================================================================
    [VERBOSE-2:profiler_metrics_ios.mm(184)] Error retrieving thread information: (ipc/send) invalid destination port
    flutter: url: https://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/hv72323947.geojson  launchUrl
    [VERBOSE-2:ui_dart_state.cc(177)] Unhandled Exception: MissingPluginException(No implementation found for method canLaunch on channel plugins.flutter.io/url_launcher)
    #0      MethodChannel._invokeMethod (package:flutter/src/services/platform_channel.dart:157:7)
    <asynchronous suspension>
    #1      MethodChannel.invokeMethod (package:flutter/src/services/platform_channel.dart:332:12)
    #2      MethodChannelUrlLauncher.canLaunch (package:url_launcher_platform_interface/method_channel_url_launcher.dart:22:21)
    #3      canLaunch (package:url_launcher/url_launcher.dart:124:45)
    #4      launchURL (package:mac_maps_and_permissions/quakes/list_quakes.dart:216:13)

    Stackoverflow suggests use a direct call to launch() without the await
        didn't work....
        However, this did
        "Try restarting the app. Not a hot restart or hot reload; a full restart"

* try to fix the +/- zoom icons
    Done - seems I had the wrong icons - they were both in place & working (but wrong symbols)
    Fixed with +1 and -1 as the icons

* Fixed the 'sort' on myQuakeDetailsList
    seems I had the sort in the wrong place in teh nested loops .forEach, etc
    also discovered how to sort descending
         myQuakeDetailList.sort((b, a) => a.mag.compareTo(b.mag));   // LIST SORT - DESCENDING

DONE: didn't work on Android....  (needed maps API key somewhere else ???)
    it DOES need the key - in android manifest
    android/app/src/main/AndroidManifest.xml

Saved version 1.0
=================
Managed to get maps working on iPhone !
    TODO: need  **/AppDelegate.swift in the .gitignore file (don't want to put API key into Github)

1) have to get a API key and save it in AppDelegate.swift
    import UIKit
    import Flutter
    import GoogleMaps

    @UIApplicationMain
    @objc class AppDelegate: FlutterAppDelegate {
      override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) -> Bool {
        GMSServices.provideAPIKey("AIzaSyCNMPs2aQ10nFHTbb5RxAH0rgEaRIpioI4")
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }
    }

2) also need to add the following to info.plist *according to the training course)
        	<key>io.flutter.embedded_views_preview</key>
        	<true/>
   I managed to miss off the final '>' on the <true/> which causes the app to fail to compile

