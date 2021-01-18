import 'package:flutter/cupertino.dart';

class EarthquakeData {
  String type;
  Metadata metadata;
  List<Features> features;
  List<double> bbox;

  EarthquakeData({this.type, this.metadata, this.features, this.bbox});

  EarthquakeData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    if (json['features'] != null) {
      features = new List<Features>();
      json['features'].forEach((v) {
        features.add(new Features.fromJson(v));
      });
    }
    bbox = json['bbox'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.metadata != null) {
      data['metadata'] = this.metadata.toJson();
    }
    if (this.features != null) {
      data['features'] = this.features.map((v) => v.toJson()).toList();
    }
    data['bbox'] = this.bbox;
    return data;
  }
}

class Metadata {
  int generated;
  String url;
  String title;
  int status;
  String api;
  int count;

  Metadata(
      {this.generated,
        this.url,
        this.title,
        this.status,
        this.api,
        this.count});

  Metadata.fromJson(Map<String, dynamic> json) {
    generated = json['generated'];
    url = json['url'];
    title = json['title'];
    status = json['status'];
    api = json['api'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['generated'] = this.generated;
    data['url'] = this.url;
    data['title'] = this.title;
    data['status'] = this.status;
    data['api'] = this.api;
    data['count'] = this.count;
    return data;
  }
}

class Features {
  String type;
  Properties properties;
  Geometry geometry;
  String id;

  Features({this.type, this.properties, this.geometry, this.id});

  Features.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.properties != null) {
      data['properties'] = this.properties.toJson();
    }
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}

class Properties {
  double mag;
  String place;
  int time;
  int updated;
  String tz;
  String url;
  String detail;
  int felt;
  double cdi;
  double mmi;
  String alert;
  String status;
  int tsunami;
  int sig;
  String net;
  String code;
  String ids;
  String sources;
  String types;
  int nst;
  double dmin;
  double rms;
  double gap;
  String magType;
  String type;
  String title;

  Properties(
      {this.mag,
        this.place,
        this.time,
        this.updated,
        this.tz,
        this.url,
        this.detail,
        this.felt,
        this.cdi,
        this.mmi,
        this.alert,
        this.status,
        this.tsunami,
        this.sig,
        this.net,
        this.code,
        this.ids,
        this.sources,
        this.types,
        this.nst,
        this.dmin,
        this.rms,
        this.gap,
        this.magType,
        this.type,
        this.title});

  Properties.fromJson(Map<String, dynamic> json) {
    mag = checkDouble(json['mag']);
    place = json['place'];
    // time = json['time'];
    time = checkInt(json['time']);          // checkInt WAS ignoring integers...
    updated = checkInt(json['updated']);    // checkInt WAS ignoring integers...
    // updated = json['updated'];
    tz = json['tz'];
    url = json['url'];
    detail = json['detail'];
    felt = checkInt(json['felt']);
    cdi = checkDouble(json['cdi']);
    mmi = checkDouble(json['mmi']);
    alert = json['alert'];
    status = json['status'];
    tsunami = json['tsunami'];
    sig = checkInt(json['sig']);
    net = json['net'];
    code = json['code'];
    ids = json['ids'];
    sources = json['sources'];
    types = json['types'];
    nst = checkInt(json['nst']);
    dmin = checkDouble(json['dmin']);
    rms = checkDouble(json['rms']);
    gap = checkDouble(json['gap']);
    magType = json['magType'];
    type = json['type'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mag'] = this.mag;
    data['place'] = this.place;
    data['time'] = this.time;
    data['updated'] = this.updated;
    data['tz'] = this.tz;
    data['url'] = this.url;
    data['detail'] = this.detail;
    data['felt'] = this.felt;
    data['cdi'] = this.cdi;
    data['mmi'] = this.mmi;
    data['alert'] = this.alert;
    data['status'] = this.status;
    data['tsunami'] = this.tsunami;
    data['sig'] = this.sig;
    data['net'] = this.net;
    data['code'] = this.code;
    data['ids'] = this.ids;
    data['sources'] = this.sources;
    data['types'] = this.types;
    data['nst'] = this.nst;
    data['dmin'] = this.dmin;
    data['rms'] = this.rms;
    data['gap'] = this.gap;
    data['magType'] = this.magType;
    data['type'] = this.type;
    data['title'] = this.title;
    return data;
  }
}

class Geometry {
  String type;
  List<double> coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();       // 3rd item usually looks like Int
    // but this seems to work OK on its own
    // my attempt below causes errors
    // coordinates = checkDouble(json['coordinates']) as List<double>;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

// It seems to cause errors when expected 'double' come in without decimals.
// This routine makes sure they are converted to decimals (just in case)
double checkDouble(dynamic value) {
  try {
    if (value == null) {
      return 0.0;
    } else {
      if (value is String) {
        return double.parse(value);
      } else {
        return value + 0.0;         // adding 0.0 converts to double
      }
    }
  }catch (error) {
    debugPrint('Error double - got: $value');
    return 0.0;
  }
}
// It seems to cause errors when expected 'int ' come with null value
// This routine makes sure they are converted to int (just in case)
int checkInt(dynamic value) {
  try {
    if (value == null) {
      return 0;
    } else {
      if (value is int) {
        return value;
      } else if (value is String) {
        return int.parse(value);
      } else {
        return 0;
      }
    }
  }catch (error) {
    debugPrint('Error int - got: $value');
    return 0;
  }
}

class MyQuakeDetail{
  double mag;         // magnitude
  String place;       // location / place
  int time;           // time
  int updated;        // udpated
  String tz;          // not sure what tz is
  String url;         // weblink
  String detail;      // string of details

MyQuakeDetail({this.mag, this.place, this.time, this.updated, this.tz, this.url, this.detail});
}

List <MyQuakeDetail> myQuakeDetailList = [];