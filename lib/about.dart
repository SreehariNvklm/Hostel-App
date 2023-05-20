// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class aboutAppPage extends StatefulWidget {
  const aboutAppPage({Key? key}) : super(key: key);

  @override
  State<aboutAppPage> createState() => _aboutAppPageState();
}

double _screenHeight = 0;
double _screenWidth = 0;

class _aboutAppPageState extends State<aboutAppPage> {
  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        height: _screenHeight,
        width: _screenWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: _screenWidth,
                height: _screenHeight / 6,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                  ],
                ),
                alignment: Alignment.centerLeft,
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  elevation: 2.0,
                  fillColor: Colors.white,
                  child: const Icon(
                    Icons.arrow_back,
                    size: 25.0,
                    color: Colors.green,
                  ),
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: titleText('Rules', Colors.green),
              ),
              SizedBox(
                height: _screenHeight / 35,
              ),
              Container(
                alignment: Alignment.center,
                height: _screenHeight * .7,
                width: _screenWidth * .8,
                margin: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: _screenHeight / 60,
                        ),
                        fieldText("Hello all. ", Colors.white),
                        SizedBox(
                          height: _screenHeight / 60,
                        ),
                        fieldText(
                            "There are certain rules as a student you have to perform.",
                            Colors.white),
                        SizedBox(
                          height: _screenHeight / 60,
                        ),
                        fieldText(
                            "All of you have to scan the QR Code received from warden on the date before the time prescribed.",
                            Colors.white),
                        SizedBox(
                          height: _screenHeight / 60,
                        ),
                        fieldText(
                            "You need to turn on the Location and allow the location access permission.",
                            Colors.white),
                        SizedBox(
                          height: _screenHeight / 60,
                        ),
                        fieldText(
                            "Your attendance will be marked on clicking the 'Mark Attendance'.",
                            Colors.white),
                        SizedBox(
                          height: _screenHeight / 60,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
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
      margin: EdgeInsets.only(
        bottom: _screenHeight / 25,
      ),
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
