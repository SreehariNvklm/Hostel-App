// ignore_for_file: file_names, non_constant_identifier_names, avoid_unnecessary_containers, unused_local_variable

import 'package:attendance_app/about.dart';
import 'package:attendance_app/qr_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Container(
              width: _screenWidth,
              height: _screenHeight / 5,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
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
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: titleText("Welcome", Colors.white),
                    ),
                    flex: 5,
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: const Icon(
                        Icons.output_rounded,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance
                            .signOut()
                            .then((value) => Navigator.of(context).pop());
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: _screenHeight * .85,
                width: _screenWidth * .8,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      spreadRadius: 0,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(4.0),
                      child: titleText("Profile", Colors.white),
                    ),
                    const Icon(
                      Icons.person_outline_outlined,
                      weight: 10,
                      color: Colors.white,
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            spreadRadius: 0,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: SizedBox(
                            height: _screenHeight * .5,
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: documentReference,
                              builder: (
                                BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot,
                              ) {
                                if (snapshot.hasError) {
                                  return fieldText("Error", Colors.red);
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return fieldText("Loading", Colors.green);
                                }
                                final data = snapshot.requireData;
                                return ListView.builder(
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: _screenHeight / 15,
                                            ),
                                            Expanded(
                                                child: fieldText(
                                                    'Name: ', Colors.green)),
                                            Expanded(
                                              child: fieldText(
                                                data.get('name'),
                                                Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: _screenHeight / 15,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: fieldText(
                                                    'Email: ', Colors.green)),
                                            Expanded(
                                              child: fieldText(
                                                text,
                                                Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: _screenHeight / 15,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: fieldText(
                                                    'Phone: ', Colors.green)),
                                            Expanded(
                                              child: fieldText(
                                                data.get('phone'),
                                                Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: _screenHeight / 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            data.get('payment')
                                                ? titleText(
                                                    "No payment is due",
                                                    Colors.green,
                                                  )
                                                : titleText(
                                                    "Payment due",
                                                    Colors.red,
                                                  ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                  itemCount: 1,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ])),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            items: [
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                label: "Profile",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                    child: const Icon(
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
              BottomNavigationBarItem(
                icon: GestureDetector(
                    child: const Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const aboutAppPage(),
                        ),
                      );
                    }),
                label: "Rules",
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
