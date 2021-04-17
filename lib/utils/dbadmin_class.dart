import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mac_maps_and_permissions/main_variables.dart';
import 'package:mac_maps_and_permissions/utils/utilities.dart';

// #############################################################################
// ################  D B _ A D M I N ###########################################
// #############################################################################
/// common database attributes which might be useful for tracking record history
/// also used for debug printing or saving
/// METHODS:
//  initialise            set up 'static' field (user, device, appVersion)
//
//  dbPrint	              debug print message to console
//  dbLog	                debug log message to debug log List/database
//
//  debug	                log and/or print (based on app settings)
//
//  create	              dbAdmin record - create/new (calling code uses it)
//  update	        TODO  dbAdmin record - update     (calling code uses it)
//  createAsString	      return dbAdmin record as a JSON string
//  updateAsString	TODO  return dbAdmin record as a JSON string
//                        [to save in a Firebase rtdb string field]
//  toString              returns JSON format (used by the above)
// #############################################################################
// #############################################################################
class DbAdmin {
  String     key;                             // Parent key (or createDateTimeInt as String)
  int        version;                         // starting at 0
  String     lastAction;                      // Create, Amend, Delete, Archive, etc
  String     createComment;                   // could be simple "Created" or explain more detail
  String     calledFrom;                      // for debugging
  String     createDateTimeText;              // dateTime as String (Create)
  int        createDateTimeInt;               // actual date (int sec from epoch)
  double     createLat;                       // Location description   <optional>
  double     createLng;                       // Location description   <optional>
// These variables do not change
  String     createDeviceId;                  // device  id
  String     createDeviceDescription;         // model/OS/ etc
  String     createUserId;                    // user                            [Firebase id]
  String     createAppName;                   // use package name (problem with iOS)
  String     createAppVersion;                // what version of the app
// more dynamic variables
  String     updateComment;                   // Expect more detail for this
  String     updateDateTimeText;              // dateTime as String (Create)
  int        updateDateTimeInt;               // actual date (int sec from epoch)
  double     updateLat;                       // Location description   <optional>
  double     updateLng;                       // Location description   <optional>
// These variables do not change
  String     updateDeviceId;                  // device  id
  String     updateDeviceDescription;         // model/OS/ etc
  String     updateUserId;                    // user                            [Firebase id]
  String     updateAppName;                   // use package name (problem with iOS)
  String     updateAppVersion;                // what version of the app
  String     spareString;                     // might be useful

  // DEPENDENCIES
  //  - app Version, package, etc             run getVersionNumber first
  //  - user details                          need to be logged in ?
  //  - device id                             run ??
  void initialise(){
    version                 = 0;
    createDeviceId          = currentDeviceId;
    createDeviceDescription = currentDeviceDetails;   //todo - should rename these to match
    createUserId            = currentUser;
    createAppName           = appName;
    createAppVersion        = appVersion;
    updateDeviceId          = currentDeviceId;
    updateDeviceDescription = currentDeviceDetails;   //todo - should rename these to match
    updateUserId            = currentUser;
    updateAppName           = appName;
    updateAppVersion        = appVersion;
    updateComment           = ".";
    spareString             = ".";
  }

  // ##########################################################################
  // # createAsString(String createText, String whereFrom, String sourceKey, ) {
  // #
  // # runs the create mthod, then uses toString to send back a string
  // ###########################################################################
  String createAsString(String createText, String whereFrom, String sourceKey, ) {
    create(createText, whereFrom, sourceKey);
    return toString();
  } // end of createAsString
  void create(String createText, String whereFrom, String sourceKey, ) {
    key                 = sourceKey ?? defaultDbAdmin.key;            // override null
    lastAction          = "Create";
    createDateTimeText  = shortDate(DateTime.now());
    createDateTimeInt   = DateTime.now().millisecondsSinceEpoch;
    calledFrom          = whereFrom;
    createComment       = createText;
    createLat           = currentLat;
    createLng           = currentLng;
  }

  // ########################################################################### debug
  // # debug(String messageComment, String calledFrom, String sourceKey )
  // #
  // #  print if printDebugMessage    = true;
  // #  log   if logDebugMessage      = true;
  // ###########################################################################
  void debug(String messageComment, String calledFrom, String sourceKey ) {
    if(printDebugMessage) {
      dbPrint(messageComment, calledFrom, sourceKey);
    }
    /// note: this is not an 'else' condition - might want both print and log
    if(logDebugMessage) {
      dbLog(messageComment, calledFrom, sourceKey);
    }
  }
  // ########################################################################### dbPrint
  // # dbPrint(String messageComment, String calledFrom, String sourceKey )
  // # if print turned on, formats the message string and output to console
  // ###########################################################################
  void dbPrint(String messageComment, String calledFrom, String sourceKey ) {
    if(printDebugMessage) {
      debugPrint(formatDebugMessage(messageComment, calledFrom, sourceKey));
    }
  }

  // ###########################################################################
  // # dbLog(String messageComment, String calledFrom, String sourceKey )
  // #
  // # either logs to the Firebase db or adds to dbAdminList
  // ###########################################################################
  void dbLog(String messageComment, String calledFrom, String sourceKey ) {

    // uses standard debug message layout
    String _msg = formatDebugMessage(messageComment, calledFrom, sourceKey);

    if (isFirebaseDBUsed){
      // todo: include a Firebase database version of this

    } else {
      dbAdminList.add(
        DbAdmin(key: key,version: version,lastAction: lastAction,
        createComment: _msg,
        calledFrom: calledFrom, createDateTimeText: createDateTimeText,
        createDateTimeInt: createDateTimeInt,
        createLat: createLat, createLng: createLng,
        createAppName: createAppName, createAppVersion: createAppVersion,
        createDeviceId: createDeviceId, createDeviceDescription: createDeviceDescription,
        createUserId: createUserId,
        /// NOTE: debug Log doesn't use 'update' values
        )
      );
    } // end of 'else' (no Firebase db)
  } // end of dbLog

  // ###########################################################################
  // # formatDebugMessage
  // # common message layout with > separators (both print and log use this)
  // # #########################################################################
  String formatDebugMessage(String sourceComment, String whereFrom, String sourceKey ) {
    key = sourceKey ?? "NOKEY";                            // override null
    lastAction          = "Debug";
    calledFrom          = whereFrom;
    createDateTimeInt   = DateTime.now().millisecondsSinceEpoch;
    createDateTimeText  = fullDate(DateTime.now());
    // by using single > as separator, Excel can parse the message text into columns
    String _msgString= "@>" +shortDate(null) + " >"+
                            createAppName    + " >" +
                            createAppVersion + " >" +
                            whereFrom        + " >" +
                            key              + " >" +
                            sourceComment;
    createComment = _msgString;
    return _msgString;
  }

  // custom toString returns the dbAdmin as a String in JSON format (can be saved to rtdb)
  String toString(){
  /// early versions of the code...
  //  String _result = "{";
  //{ 'key':  'NOKEY 'version':  '0' ,  'lastAction':  'New 'createComment':  '@>Sat 10:23> Network Connection Tracker> ??> testDbAdmin> NOKEY> dbLog Test message (2) 'calledFrom':  'testDbAdmin 'createDateTimeText':  'Sat 17-Apr-21 10:23 'createDateTimeInt':  '1618651430940' ,  'createLat':  '18.3' ,  'createLng':  '18.3' ,  'createDeviceId':  'dummy deviceId 'createDeviceDescription':  'device ??? 'createUserId':  'dummy userId 'createAppName':  'Network Connection Tracker 'createAppVersion':  '?? 'updateComment':  '. 'updateDateTimeText':  '1212121212' ,  'updateDateTimeInt':  '123456789.0' ,  'updateLat':  '5.1' ,  'updateLng':  '98.5' ,  'updateDeviceId':  'dummy deviceId 'updateDeviceDescription':  'device ??? 'updateUserId':  'dummy userId 'updateAppName':  'Network Connection Tracker 'updateAppVersion':  '?? 'spareString':  '.}
  //                                    |  NEED BRACKETS          | to ensure the ', isn't only used for null value
  //  _result = _result + " 'key':  '" + key ?? defaultDbAdmin.key + "' , ";
  //  _result = _result + " 'key':  '" + (key ?? defaultDbAdmin.key) + "' , ";
  //                                    |   DO NOT NEED THESE QUOTES FOR NUMBERS               |
  //  _result = _result + " 'version':  '" + (version ?? defaultDbAdmin.version).toString() + "' , ";
  //  _result = _result + " 'version':  " + (version ?? defaultDbAdmin.version).toString() + " , ";
  /// 'corrected versions of the code from the Excel spreadsheet (column V)

  // turns out that although this LOOKS ok, the " and ' need to be swapped over
  // JSON expects " " around the field names
  // JSON also does NOT accept a trailing ,
  //   String _result = "{";
  //   _result = _result + " 'key':  '" +                     (key ?? defaultDbAdmin.key) + "' ,";
  //   _result = _result + " 'version':  " +                  (version ?? defaultDbAdmin.version).toString() + ", ";
  //   _result = _result + " 'lastAction':  '" +              (lastAction ?? defaultDbAdmin.lastAction) + "' ,";
  //   _result = _result + " 'createComment':  '" +           (createComment ?? defaultDbAdmin.createComment) + "' ,";
  //   _result = _result + " 'calledFrom':  '" +              (calledFrom ?? defaultDbAdmin.calledFrom) + "' ,";
  //   _result = _result + " 'createDateTimeText':  '" +      (createDateTimeText ?? defaultDbAdmin.createDateTimeText) + "' ,";
  //   _result = _result + " 'createDateTimeInt':  " +        (createDateTimeInt ?? defaultDbAdmin.createDateTimeInt).toString() + ", ";
  //   _result = _result + " 'createLat':  " +                (createLat ?? defaultDbAdmin.createLat).toString() + ", ";
  //   _result = _result + " 'createLng':  " +                (createLng ?? defaultDbAdmin.createLng).toString() + ", ";
  //   _result = _result + " 'createDeviceId':  '" +          (createDeviceId ?? defaultDbAdmin.createDeviceId) + "' ,";
  //   _result = _result + " 'createDeviceDescription':  '" + (createDeviceDescription ?? defaultDbAdmin.createDeviceDescription) + "' ,";
  //   _result = _result + " 'createUserId':  '" +            (createUserId ?? defaultDbAdmin.createUserId) + "' ,";
  //   _result = _result + " 'createAppName':  '" +           (createAppName ?? defaultDbAdmin.createAppName) + "' ,";
  //   _result = _result + " 'createAppVersion':  '" +        (createAppVersion ?? defaultDbAdmin.createAppVersion) + "' ,";
  //   _result = _result + " 'updateComment':  '" +           (updateComment ?? defaultDbAdmin.updateComment) + "' ,";
  //   _result = _result + " 'updateDateTimeText':  '" +      (updateDateTimeText ?? defaultDbAdmin.updateDateTimeText) + "' ,";
  //   _result = _result + " 'updateDateTimeInt':  " +        (updateDateTimeInt ?? defaultDbAdmin.updateDateTimeInt).toString() + ", ";
  //   _result = _result + " 'updateLat':  " +                (updateLat ?? defaultDbAdmin.updateLat).toString() + ", ";
  //   _result = _result + " 'updateLng':  " +                (updateLng ?? defaultDbAdmin.updateLng).toString() + ", ";
  //   _result = _result + " 'updateDeviceId':  '" +          (updateDeviceId ?? defaultDbAdmin.updateDeviceId) + "' ,";
  //   _result = _result + " 'updateDeviceDescription':  '" + (updateDeviceDescription ?? defaultDbAdmin.updateDeviceDescription) + "' ,";
  //   _result = _result + " 'updateUserId':  '" +            (updateUserId ?? defaultDbAdmin.updateUserId) + "' ,";
  //   _result = _result + " 'updateAppName':  '" +           (updateAppName ?? defaultDbAdmin.updateAppName) + "' ,";
  //   _result = _result + " 'updateAppVersion':  '" +        (updateAppVersion ?? defaultDbAdmin.updateAppVersion) + "' ,";
  //   _result = _result + " 'spareString':  '" +             (spareString ?? defaultDbAdmin.spareString) + "' ,";
  //
  //   _result = _result + "}";

    /// alternative version with ' and " swapped & trailing comma removed manually
    String _result = "{";
    _result = _result + ' "key":  "' +                     (key ?? defaultDbAdmin.key) + '" ,';
    _result = _result + ' "version":  ' +                  (version ?? defaultDbAdmin.version).toString() + ', ';
    _result = _result + ' "lastAction":  "' +              (lastAction ?? defaultDbAdmin.lastAction) + '" ,';
    _result = _result + ' "createComment":  "' +           (createComment ?? defaultDbAdmin.createComment) + '" ,';
    _result = _result + ' "calledFrom":  "' +              (calledFrom ?? defaultDbAdmin.calledFrom) + '" ,';
    _result = _result + ' "createDateTimeText":  "' +      (createDateTimeText ?? defaultDbAdmin.createDateTimeText) + '" ,';
    _result = _result + ' "createDateTimeInt":  ' +        (createDateTimeInt ?? defaultDbAdmin.createDateTimeInt).toString() + ', ';
    _result = _result + ' "createLat":  ' +                (createLat ?? defaultDbAdmin.createLat).toString() + ', ';
    _result = _result + ' "createLng":  ' +                (createLng ?? defaultDbAdmin.createLng).toString() + ', ';
    _result = _result + ' "createDeviceId":  "' +          (createDeviceId ?? defaultDbAdmin.createDeviceId) + '" ,';
    _result = _result + ' "createDeviceDescription":  "' + (createDeviceDescription ?? defaultDbAdmin.createDeviceDescription) + '" ,';
    _result = _result + ' "createUserId":  "' +            (createUserId ?? defaultDbAdmin.createUserId) + '" ,';
    _result = _result + ' "createAppName":  "' +           (createAppName ?? defaultDbAdmin.createAppName) + '" ,';
    _result = _result + ' "createAppVersion":  "' +        (createAppVersion ?? defaultDbAdmin.createAppVersion) + '" ,';
    _result = _result + ' "updateComment":  "' +           (updateComment ?? defaultDbAdmin.updateComment) + '" ,';
    _result = _result + ' "updateDateTimeText":  "' +      (updateDateTimeText ?? defaultDbAdmin.updateDateTimeText) + '" ,';
    _result = _result + ' "updateDateTimeInt":  ' +        (updateDateTimeInt ?? defaultDbAdmin.updateDateTimeInt).toString() + ', ';
    _result = _result + ' "updateLat":  ' +                (updateLat ?? defaultDbAdmin.updateLat).toString() + ', ';
    _result = _result + ' "updateLng":  ' +                (updateLng ?? defaultDbAdmin.updateLng).toString() + ', ';
    _result = _result + ' "updateDeviceId":  "' +          (updateDeviceId ?? defaultDbAdmin.updateDeviceId) + '" ,';
    _result = _result + ' "updateDeviceDescription":  "' + (updateDeviceDescription ?? defaultDbAdmin.updateDeviceDescription) + '" ,';
    _result = _result + ' "updateUserId":  "' +            (updateUserId ?? defaultDbAdmin.updateUserId) + '" ,';
    _result = _result + ' "updateAppName":  "' +           (updateAppName ?? defaultDbAdmin.updateAppName) + '" ,';
    _result = _result + ' "updateAppVersion":  "' +        (updateAppVersion ?? defaultDbAdmin.updateAppVersion) + '" ,';
    _result = _result + ' "spareString":  "' +             (spareString ?? defaultDbAdmin.spareString) + '" ';
// TODO - remove trailing comma [not technically valid in JSON, so will cause decode errors]
    _result = _result + "}";

   /// This is what the JSON string output should look like
    //   { "key":  "sourceKey 290" , "version":  0,  "lastAction":  "Create" , "createComment":  "Debug test createText" , "calledFrom":  "whereFrom= testDbAdmin row 290" , "createDateTimeText":  "Sat 20:26" , "createDateTimeInt":  1618687608775,  "createLat":  -3.0674,  "createLng":  37.35519,  "createDeviceId":  "dummy deviceId" , "createDeviceDescription":  "device ???" , "createUserId":  "dummy userId" , "createAppName":  "Network Connection Tracker" , "createAppVersion":  "??" , "updateComment":  "." , "updateDateTimeText":  "Thu 21-June 18:30" , "updateDateTimeInt":  123456789,  "updateLat":  3.14,  "updateLng":  159.01,  "updateDeviceId":  "dummy deviceId" , "updateDeviceDescription":  "device ???" , "updateUserId":  "dummy userId" , "updateAppName":  "Network Connection Tracker" , "updateAppVersion":  "??" , "spareString":  "." }
   /// And here's how it translates back into a Map (using anotherJSONTest below)
    // I/flutter ( 3216): Key= key Value= sourceKey 290
    // I/flutter ( 3216): Key= version Value= 0
    // I/flutter ( 3216): Key= lastAction Value= Create
    // I/flutter ( 3216): Key= createComment Value= Debug test createText
    // I/flutter ( 3216): Key= calledFrom Value= whereFrom= testDbAdmin row 290
    // I/flutter ( 3216): Key= createDateTimeText Value= Sat 20:26
    // I/flutter ( 3216): Key= createDateTimeInt Value= 1618687608775
    // I/flutter ( 3216): Key= createLat Value= -3.0674
    // I/flutter ( 3216): Key= createLng Value= 37.35519
    // I/flutter ( 3216): Key= createDeviceId Value= dummy deviceId
    // I/flutter ( 3216): Key= createDeviceDescription Value= device ???
    // I/flutter ( 3216): Key= createUserId Value= dummy userId
    // I/flutter ( 3216): Key= createAppName Value= Network Connection Tracker
    // I/flutter ( 3216): Key= createAppVersion Value= ??
    // I/flutter ( 3216): Key= updateComment Value= .
    // I/flutter ( 3216): Key= updateDateTimeText Value= Thu 21-June 18:30
    // I/flutter ( 3216): Key= updateDateTimeInt Value= 123456789
    // I/flutter ( 3216): Key= updateLat Value= 3.14
    // I/flutter ( 3216): Key= updateLng Value= 159.01
    // I/flutter ( 3216): Key= updateDeviceId Value= dummy deviceId
    // I/flutter ( 3216): Key= updateDeviceDescription Value= device ???
    // I/flutter ( 3216): Key= updateUserId Value= dummy userId
    // I/flutter ( 3216): Key= updateAppName Value= Network Connection Tracker
    // I/flutter ( 3216): Key= updateAppVersion Value= ??
    // I/flutter ( 3216): Key= spareString Value= .

    /// version below... I manually swapped " and ' characters & manually deleted the trailing comma after spareString
    // String _result = '{';
    //
    // _result = _result + ' "key":  "' +                     (key ?? defaultDbAdmin.key) + '" ,';
    // _result = _result + ' "version":  ' +                  (version ?? defaultDbAdmin.version).toString() + ', ';
    // _result = _result + ' "lastAction":  "' +              (lastAction ?? defaultDbAdmin.lastAction) + '" ,';
    // _result = _result + ' "createComment":  "' +           (createComment ?? defaultDbAdmin.createComment) + '" ,';
    // _result = _result + ' "calledFrom":  "' +              (calledFrom ?? defaultDbAdmin.calledFrom) + '" ,';
    // _result = _result + ' "createDateTimeText":  "' +      (createDateTimeText ?? defaultDbAdmin.createDateTimeText) + '" ,';
    // _result = _result + ' "createDateTimeInt":  ' +        (createDateTimeInt ?? defaultDbAdmin.createDateTimeInt).toString() + ', ';
    // _result = _result + ' "createLat":  ' +                (createLat ?? defaultDbAdmin.createLat).toString() + ', ';
    // _result = _result + ' "createLng":  ' +                (createLng ?? defaultDbAdmin.createLng).toString() + ', ';
    // _result = _result + ' "createDeviceId":  "' +          (createDeviceId ?? defaultDbAdmin.createDeviceId) + '" ,';
    // _result = _result + ' "createDeviceDescription":  "' + (createDeviceDescription ?? defaultDbAdmin.createDeviceDescription) + '" ,';
    // _result = _result + ' "createUserId":  "' +            (createUserId ?? defaultDbAdmin.createUserId) + '" ,';
    // _result = _result + ' "createAppName":  "' +           (createAppName ?? defaultDbAdmin.createAppName) + '" ,';
    // _result = _result + ' "createAppVersion":  "' +        (createAppVersion ?? defaultDbAdmin.createAppVersion) + '" ,';
    // _result = _result + ' "updateComment":  "' +           (updateComment ?? defaultDbAdmin.updateComment) + '" ,';
    // _result = _result + ' "updateDateTimeText":  "' +      (updateDateTimeText ?? defaultDbAdmin.updateDateTimeText) + '" ,';
    // _result = _result + ' "updateDateTimeInt":  ' +        (updateDateTimeInt ?? defaultDbAdmin.updateDateTimeInt).toString() + ', ';
    // _result = _result + ' "updateLat":  ' +                (updateLat ?? defaultDbAdmin.updateLat).toString() + ', ';
    // _result = _result + ' "updateLng":  ' +                (updateLng ?? defaultDbAdmin.updateLng).toString() + ', ';
    // _result = _result + ' "updateDeviceId":  "' +          (updateDeviceId ?? defaultDbAdmin.updateDeviceId) + '" ,';
    // _result = _result + ' "updateDeviceDescription":  "' + (updateDeviceDescription ?? defaultDbAdmin.updateDeviceDescription) + '" ,';
    // _result = _result + ' "updateUserId":  "' +            (updateUserId ?? defaultDbAdmin.updateUserId) + '" ,';
    // _result = _result + ' "updateAppName":  "' +           (updateAppName ?? defaultDbAdmin.updateAppName) + '" ,';
    // _result = _result + ' "updateAppVersion":  "' +        (updateAppVersion ?? defaultDbAdmin.updateAppVersion) + '" ,';
    // _result = _result + ' "spareString":  "' +             (spareString ?? defaultDbAdmin.spareString) + '" ';
    //
    // _result = _result + '}';

    return _result;
  }

  // Not sure I want to be able to access all these attributes
  // class should set everything except the original key and comments
  DbAdmin ({
    this.key,
    this.version,
    this.lastAction,
    this.createComment,
    this.calledFrom,
    this.createDateTimeText,
    this.createDateTimeInt,
    this.createLat,
    this.createLng,
    this.createDeviceId,
    this.createDeviceDescription,
    this.createUserId,
    this.createAppName,
    this.createAppVersion,
    this.updateComment,
    this.updateDateTimeText,
    this.updateDateTimeInt,
    this.updateLat,
    this.updateLng,
    this.updateDeviceId,
    this.updateDeviceDescription,
    this.updateUserId,
    this.updateAppName,
    this.updateAppVersion,
    this.spareString,
  });

  void fromJSON(Map<String, dynamic>json) {
    key           = json['key'];
    version       = int.parse(json['version'] ?? defaultDbAdmin.version);
    createLat     = double.parse(json['createLat'] ?? defaultDbAdmin.createLat);
    createLng     = double.parse(json['createLng'] ?? defaultDbAdmin.createLng);
    createComment = json['createComment'];
    print("########### DEBUG #### "
        " Key       " + key +
        " version   " + version.toString() +
        " createLat " + createLat.toStringAsFixed(4) +
        " create Comment " + createComment);
  }

}  // end of DbAdmin class ######             end of DbAdmin class ######             end of DbAdmin class ######

List<DbAdmin> dbAdminList = [];                // array to store DbAdmin values
DbAdmin  workingDbAdmin;                       // a working or current DbAdmin set
int      workingDbAdminIndex;                  // integer index of current place in the array
bool     workingDbAdminChanged;                // bool to flag whether working___ has been changed


// ############################################################################# default values
DbAdmin defaultDbAdmin = DbAdmin  (
  key:                   "123456789000",
  version:               0,
  lastAction:           "New",
  createComment:        "createComment",
  calledFrom:           "called from function",
  createDateTimeText:   "Thu 21-June 18:30",
  createDateTimeInt:    123456789,
  createLat:            3.14,
  createLng:            159.01,
  createDeviceId:       "create device id",
  createDeviceDescription:   "create device desc",
  createUserId:         "create user id",
  createAppName:        "create app name",
  createAppVersion:     "create app version",
  updateComment:        "udpate comment",
  updateDateTimeText:   "Thu 21-June 18:30",
  updateDateTimeInt:    123456789,
  updateLat:            3.14,
  updateLng:            159.01,
  updateDeviceId:       "update device id",
  updateDeviceDescription:   "update device desc",
  updateUserId:         "update user id",
  updateAppName:        "update app name",
  updateAppVersion:     "update app version",
  spareString:          "spare string",

);


void testDbAdmin(){
  String _tempString;
  DbAdmin dbAdmin = new DbAdmin();

  dbAdmin.initialise();

  _tempString = "dbPrint Test message (1)";

  dbAdmin.dbPrint(_tempString,"testDbAdmin line 284", null);

  _tempString = "dbPrint Test message (2)";

  dbAdmin.dbLog(_tempString,"testDbAdmin line 286", null);

  _tempString = dbAdmin.toString();

  print("## DEBUG TEST ##> " + _tempString);

  _tempString = dbAdmin.createAsString("Debug test createText", "whereFrom= testDbAdmin row 290", "sourceKey 290");

  print("## DEBUG TEST ##> " + _tempString);

  dbAdminList.add(dbAdmin);

  anotherJSONTest(_tempString);

  //dbAdmin.fromJSON("[" + _tempString + "]");

  print("dbAdminList length =" + dbAdminList.length.toString());
}

void anotherJSONTest(String inputString) {
  Map decoded = jsonDecode(inputString);
  decoded.forEach((key1, value1) {
    print("Key= "+ key1 + " Value= "+ value1.toString());
  });
}