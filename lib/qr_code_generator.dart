// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, avoid_unnecessary_containers, unused_import

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QRGenerator extends StatefulWidget {
  const QRGenerator({Key? key}) : super(key: key);

  @override
  State<QRGenerator> createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  double _screenWidth = 0;
  double _screenHeight = 0;
  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return Scaffold(
      backgroundColor: Colors.green,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: _screenWidth,
                    height: _screenHeight / 5,
                    child: QrImage(
                      data: date.toString(),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.circle),
                    ),
                  ),
                ),
                SizedBox(
                  height: _screenHeight / 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: fieldText(
                    "Take a screenshot and send to the students",
                    Colors.white,
                  ),
                ),
                SizedBox(
                  height: _screenHeight / 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child: Icon(
                      Icons.keyboard_return,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
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
