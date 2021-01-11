import 'dart:convert';
import 'package:flutter/material.dart';
import '../settings.dart';
import 'earthquake_data_model.dart';
import 'package:http/http.dart';

class QuakeNetwork {
  //                    Future because we don't know exactly when we'll get the data feed
  Future<EarthquakeData> getAllQuakes() async {
    var apiURL = quakeSourceURL;                    // hard coded, but not here

    //                  response is whatever we get back from the URL
    final response = await get(Uri.encodeFull(apiURL));

    if (response.statusCode == 200){                // 200 = success
      // debugPrint('data = ${response.body}');
      return EarthquakeData.fromJson(json.decode(response.body));
    } else{
      debugPrint('Error. Status code = ${response.statusCode}');
      return EarthquakeData.fromJson(json.decode(response.body));
    }
  }
}