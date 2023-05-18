// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_print, unused_local_variable

import 'package:attendance_app/qr_scanner.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class StudentHomePage extends StatefulWidget {
  final String text;
  const StudentHomePage({Key? key, required this.text}) : super(key: key);

  @override
  State<StudentHomePage> createState() => _StudentHomePageState(this.text);
}

class _StudentHomePageState extends State<StudentHomePage> {
  final String text;
  _StudentHomePageState(this.text);
  double _screenWidth = 0;
  double _screenHeight = 0;
  final Stream<QuerySnapshot> students =
      FirebaseFirestore.instance.collection('students').snapshots();

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    final Stream<DocumentSnapshot> documentReference =
        FirebaseFirestore.instance.collection('students').doc(text).snapshots();

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
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 0,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: titleText("Welcome", Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: titleText("Profile", Colors.green),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: SizedBox(
                height: _screenHeight / 2,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: documentReference,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot,
                  ) {
                    if (snapshot.hasError) {
                      return fieldText("Error", Colors.red);
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }
                    final data = snapshot.requireData;
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Center(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  fieldText(
                                    data.get('name'),
                                    Colors.green,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _screenHeight / 15,
                              ),
                              Row(
                                children: [
                                  fieldText(
                                    text,
                                    Colors.green,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _screenHeight / 15,
                              ),
                              Row(
                                children: [
                                  fieldText(
                                    data.get('phone'),
                                    Colors.green,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _screenHeight / 15,
                              ),
                              Row(
                                children: [
                                  data.get('payment')
                                      ? fieldText(
                                          "No payment is due",
                                          Colors.green,
                                        )
                                      : fieldText(
                                          "Payment due",
                                          Colors.red,
                                        ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     fieldText(
                              //       data.docs
                              //           .indexOf(text as QueryDocumentSnapshot)
                              //           .toString(),
                              //       Colors.black,
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        );
                      },
                      itemCount: 1,
                    );
                  },
                ),
              ),
            ),
          ])),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                label: "Profile",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                    child: Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRCodeScanner(
                            text: text,
                          ),
                        ),
                      );
                    }),
                label: "Scan QR Code",
              ),
            ],
            backgroundColor: Colors.green,
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
