// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_print, unused_local_variable, unused_import

import 'package:attendance_app/qr_code_generator.dart';
import 'package:attendance_app/showAttendance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:flutter/material.dart';
import 'package:attendance_app/addStudent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class WardenHomePage extends StatefulWidget {
  const WardenHomePage({Key? key}) : super(key: key);

  @override
  State<WardenHomePage> createState() => _WardenHomePageState();
}

class _WardenHomePageState extends State<WardenHomePage> {
  double _screenWidth = 0;
  double _screenHeight = 0;
  final Stream<QuerySnapshot> students =
      FirebaseFirestore.instance.collection('students').snapshots();
  final TimeOfDay _time = TimeOfDay.now();

  void _selectTime() async {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    ).then((value) =>
        FirebaseFirestore.instance.collection('dates').doc(date.toString()).set(
            {'time': value!.hour.toString() + value.minute.toString()}).then(
          (value) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return QRGenerator();
              },
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
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
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: titleText("Welcome", Colors.white),
                    ),
                    flex: 5,
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Icon(
                        Icons.date_range,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                showAttendanceForWarden()));
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Icon(
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
            Container(
              margin: EdgeInsets.all(8.0),
              child: titleText("Students", Colors.green),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: SizedBox(
                height: _screenHeight / 2,
                child: StreamBuilder<QuerySnapshot>(
                  stream: students,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                    if (snapshot.hasError) {
                      return fieldText("Error", Colors.red);
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }
                    final data = snapshot.requireData;

                    return ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.green,
                                  size: _screenWidth / 6,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    child: fieldText(
                                      data.docs[index]['name'],
                                      Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: fieldText(
                                    data.docs[index]['email'],
                                    Colors.black,
                                  ),
                                ),

                                IconButton(
                                  icon: Icon(
                                    Icons.monetization_on,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('students')
                                        .doc(data.docs[index]['email'])
                                        .update({'payment': false}).then(
                                      (value) => ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: fieldText(
                                              "Payment info updated to pending status!",
                                              Colors.white),
                                          behavior: SnackBarBehavior.floating,
                                          elevation: 6.0,
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.monetization_on,
                                    color: Colors.green,
                                  ),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('students')
                                        .doc(data.docs[index]['email'])
                                        .update({'payment': true}).then(
                                      (value) => ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: fieldText(
                                              "Payment info updated to payment done status!",
                                              Colors.white),
                                          behavior: SnackBarBehavior.floating,
                                          elevation: 6.0,
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                    );
                                  },
                                )
                                // IconButton(
                                //   onPressed: () async {
                                //     await FirebaseFirestore.instance.collection('students')
                                //         .doc(data.docs[index]['email'])
                                //         .delete()
                                //         .then((value) => ScaffoldMessenger.of(
                                //                 context)
                                //             .showSnackBar(SnackBar(
                                //                 content: fieldText(
                                //                     "User deleted succesfully",
                                //                     Colors.white))))
                                //         .catchError((e) =>
                                //             ScaffoldMessenger.of(context)
                                //                 .showSnackBar(SnackBar(
                                //                     content: fieldText(
                                //                         e, Colors.white))));
                                //   },
                                // icon: Icon(
                                //   Icons.delete,
                                //   color: Colors.red[700],
                                // ),
                                // ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: fieldText('Create Attendance', Colors.white),
        onPressed: () {
          _selectTime();
        },
      ),
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
                  Icons.list,
                  color: Colors.white,
                ),
                label: "Dashboard",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  child: Icon(
                    Icons.person_add_alt,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return AddStudentScreen();
                      },
                    ),
                  ),
                ),
                label: "Add student",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  onTap: () {
                    _getCurrentLocation().then(
                      (value) {
                        String lat = '${value.latitude}';
                        String long = '${value.longitude}';
                        //print('$lat , $long');
                        CollectionReference collectionRef =
                            FirebaseFirestore.instance.collection('warden');
                        return collectionRef
                            .add({
                              'latitude': lat,
                              'longitude': long,
                            })
                            .then(
                              (value) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: fieldText(
                                      "Location added successfully!",
                                      Colors.white),
                                  behavior: SnackBarBehavior.floating,
                                  elevation: 6.0,
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            )
                            .catchError(
                              (e) => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      fieldText(e.toString(), Colors.white),
                                  behavior: SnackBarBehavior.floating,
                                  elevation: 6.0,
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            );
                      },
                    );
                  },
                ),
                label: "Add Hostel Location",
              ),
            ],
            backgroundColor: Colors.green,
          ),
        ),
      ),
    );
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permission not granted');
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission denied forever. Cannot request for the access.');
    }
    return await Geolocator.getCurrentPosition();
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
