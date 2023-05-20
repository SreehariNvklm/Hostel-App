// ignore_for_file: file_names,   avoid_unnecessary_containers, invalid_return_type_for_catch_error

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({Key? key}) : super(key: key);

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  double _screenWidth = 0;
  double _screenHeight = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = KeyboardVisibilityController().isVisible;
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            isKeyboardVisible
                ? SizedBox(
                    height: _screenHeight / 15,
                  )
                : Container(
                    width: _screenWidth,
                    height: _screenHeight / 3,
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(40),
                          //bottomLeft: Radius.circular(40),
                        )),
                    child: Center(
                      child: Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: _screenWidth / 6,
                      ),
                    ),
                  ),
            titleText("Add A Student"),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: _screenWidth / 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textBox("Enter student's name", false, Icons.person, false,
                      true, 2, _nameController),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: _screenWidth / 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textBox("Enter Email", false, Icons.home, false, true, 3,
                      _emailController),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: _screenWidth / 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textBox("Assign a password", true, Icons.password, false,
                      false, 1, _passwordController),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: _screenWidth / 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textBox("Enter phone number", false, Icons.phone, false,
                      false, 1, _phoneController)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: _screenHeight / 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: _screenWidth / 1.25,
                    child: Center(
                      child: GestureDetector(
                        child: const Text(
                          "Add Student",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        onTap: () {
                          String name = _nameController.text.trim();
                          String password = _passwordController.text.trim();
                          String email = _emailController.text.trim();
                          String phone = _phoneController.text.trim();
                          if (name.isNotEmpty &&
                              email.isNotEmpty &&
                              password.isNotEmpty &&
                              phone.isNotEmpty) {
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            )
                                .then(
                              (value) {
                                FirebaseFirestore.instance
                                    .collection('students')
                                    .doc(email)
                                    .set({
                                      'name': name,
                                      'email': email,
                                      'phone': phone,
                                      'payment': true,
                                    })
                                    .then((value) {
                                      _nameController.text = '';
                                      _emailController.text = '';
                                      _passwordController.text = '';
                                      _phoneController.text = '';
                                    })
                                    .whenComplete(() =>
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: fieldText(
                                                "User added successfully!",
                                                Colors.white),
                                            behavior: SnackBarBehavior.floating,
                                            elevation: 6.0,
                                            backgroundColor: Colors.green,
                                          ),
                                        ))
                                    .catchError(
                                      (e) => ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: fieldText(
                                              e.toString(), Colors.white),
                                          behavior: SnackBarBehavior.floating,
                                          elevation: 6.0,
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                    );
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: fieldText(
                                    "Enter proper details completely",
                                    Colors.white),
                                behavior: SnackBarBehavior.floating,
                                elevation: 6.0,
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green,
              ),
            ),
            SizedBox(
              height: _screenHeight / 20,
            ),
            SizedBox(
              height: _screenHeight / 20,
            ),
          ],
        ),
      ),
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
              BottomNavigationBarItem(
                icon: GestureDetector(
                  child: const Icon(
                    Icons.list,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
                label: " ",
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_add_alt,
                  color: Colors.blue,
                ),
                label: "Add a student",
              ),
            ],
            backgroundColor: Colors.green,
          ),
        ),
      ),
    );
  }

  Widget titleText(String title) {
    return Container(
      margin: EdgeInsets.only(
        top: _screenHeight / 15,
        bottom: _screenHeight / 20,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: _screenWidth / 18,
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
          fontSize: _screenWidth / 26,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget textBox(String hint, bool obscure, IconData ic, bool autoCorr,
      bool enableSugg, int maxLine, TextEditingController control) {
    return Container(
      width: _screenWidth / 1.25,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 2),
            )
          ]),
      child: Row(
        children: [
          SizedBox(
            width: _screenWidth / 15,
            child: Icon(
              ic,
              color: Colors.green[300],
            ),
          ),
          Expanded(
            child: TextFormField(
              autocorrect: autoCorr,
              enableSuggestions: enableSugg,
              obscureText: obscure,
              controller: control,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: _screenHeight / 30,
                ),
                border: InputBorder.none,
                hintText: hint,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
