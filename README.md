# mac_maps_and_permissions


Saved version 1.0
=================
Managed to get maps working on iPhone !
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