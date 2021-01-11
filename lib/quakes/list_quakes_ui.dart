import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'earthquake_data_model.dart';
//import 'package:fluttermap/settings_reference.dart';


class QuakeListCard extends StatelessWidget{
//  final QuerySnapshot snapshot;
  final int index;
  final EarthquakeData quakeData;
  const QuakeListCard({Key key, this.quakeData, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    DateTime timeToDate = new DateTime(2019,  12, 31, 23, 59, 59);


    return Container(
      padding: EdgeInsets.all(2.5),

      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Card(
                elevation: 5,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(quakeData.features[index].properties.place),
                      subtitle: Text(quakeData.features[index].properties.place),
                      leading: CircleAvatar(
                        radius: 20,
                        child: Text(quakeData.features[index].properties.mag.toStringAsFixed(1)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
//          Text(snapshot.documents[index].data['title']),
          ]
      ),
    );
  }


}