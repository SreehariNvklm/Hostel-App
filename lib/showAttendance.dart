// ignore_for_file: camel_case_types, unused_import, file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class showAttendanceForWarden extends StatefulWidget {
  const showAttendanceForWarden({Key? key}) : super(key: key);

  @override
  State<showAttendanceForWarden> createState() =>
      _showAttendanceForWardenState();
}

class _showAttendanceForWardenState extends State<showAttendanceForWarden> {
  double _screenWidth = 0;
  double _screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    final Stream<DocumentSnapshot> dates = FirebaseFirestore.instance
        .collection('dates')
        .doc(date.toString())
        .snapshots();
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: _screenWidth,
              height: _screenHeight / 5,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Icon(
                  Icons.turn_left,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: titleText("Attendance", Colors.green),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: SizedBox(
                height: _screenHeight / 2,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: dates,
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return fieldText("Error", Colors.red);
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }
                    final data = snapshot.requireData;
                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            fieldText(
                                data
                                    .data()
                                    .toString()
                                    .replaceAll(RegExp('{'), ' ')
                                    .replaceAll(RegExp('}'), ' ')
                                    .replaceAll(RegExp('time'), 'Time Limit')
                                    .replaceAll(
                                        RegExp('TimeOfDay'), 'Time Of Day')
                                    .replaceAll(RegExp(','), '\n'),
                                Colors.green)
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget titleText(String title, Color colour) {
    return Container(
      margin: EdgeInsets.only(
        top: _screenHeight / 15,
        bottom: _screenHeight / 15,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: colour,
          fontSize: _screenWidth / 25,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget fieldText(String title, Color colour) {
    return Container(
      child: Text(
        title,
        style: TextStyle(
          color: colour,
          fontSize: _screenWidth / 30,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
