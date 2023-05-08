// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_print, unused_local_variable

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:attendance_app/addStudent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
              child: Center(
                child: titleText("Welcome", Colors.white),
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red[700],
                                        ))
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      })),
            ),
          ],
        ),
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
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                label: "Profile",
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
