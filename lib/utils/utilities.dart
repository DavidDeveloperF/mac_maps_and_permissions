import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';

import 'package:mac_maps_and_permissions/main_variables.dart';

/// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/// ~~~~~~~~~~~~~~     C O R E    U T I L I T I E S      ~~~~~~~~~~~~~~~~~~~~~
/// # myDebugPrint   - Formats a debugPrint message (print, log or both)        db
/// #
/// # shortDate      - uses appDateFmtShort to format a DateTime as string
/// # fullDate       - uses appDateFmt      to format a DateTime as string
/// # getDateKey     - turns DateTime to long integer most recent=lowest number
/// # translateDateKey takes myDateKey (String) and returns a dateTime
///
/// # getVersionNumber - get build, version and package data                async
/// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// myDebugPrint re-organised - new class and 'print', log and both are methods


String shortDate(DateTime _time) {
  DateTime t = _time ?? DateTime.now();
  return DateFormat(appDateFmtShort).format(t);
}
String fullDate(DateTime _time) {
  DateTime t = _time ?? DateTime.now();
  return DateFormat(appDateFmt).format(t);
}

// ############################################################################# getDateKey
// #    getDateKey - turns DateTime to long integer most recent=lowest number
// #               - usually saved as a String as the item's key
// #############################################################################
String getDateKey(DateTime inputDate) {
  int myDateKey;

  if (inputDate != null) {
    myDateKey = longFutureDate - inputDate.millisecondsSinceEpoch;
  } else {
    myDateKey = longFutureDate - DateTime.now().millisecondsSinceEpoch;
  }
  return myDateKey.toString();
} // end of getDateKey

// ############################################################################# translateDateKey
// # translateDateKey
// #
// # translateDateKey takes myDateKey (String) and returns a dateTime
// #
// # 0.30c key is a String !, so take parameter as string and convert it here.
// #       if for any reason I have an int key, I can cast it .toString()
// #############################################################################
DateTime translateDateKey(String myDateKey) {
  DateTime keyDateTime;

  if (myDateKey != null) {
    keyDateTime =
        DateTime.fromMillisecondsSinceEpoch(longFutureDate - int.parse(myDateKey));
    return keyDateTime;
  } else {
    return DateTime.now();
  }
} // end of translateDateKey


// ############################################################################# getVersionNumber
// #  getVersionNumber - get build, version and package data
// #############################################################################
void getVersionNumber() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  print(packageInfo.toString());
  appName = packageInfo.appName     ?? packageInfo.packageName;     // known bug in package_info for iOS
  appVersion = packageInfo.version  ?? "?? no result ?? (version)";
  appBuildNumber = packageInfo.buildNumber  ?? "?? no result ?? (buildNumber)";
  appPackageName = packageInfo.packageName  ?? "?? no result ?? (packageName)";
  String _answer = " App Name: " + appName +
                   " Version: "  + appVersion +
                   " Build: "    + appBuildNumber +
                   " packageName: " + appPackageName ;
  print(_answer);
}

