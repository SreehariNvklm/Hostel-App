// ignore_for_file: file_names, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_local_variable, unused_import

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:attendance_app/wardenHome.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = "";
  bool isLogin = true;
  double _screenWidth = 0;
  double _screenHeight = 0;
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
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
                        Icons.person,
                        color: Colors.white,
                        size: _screenWidth / 6,
                      ),
                    ),
                  ),
            titleText("Login"),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: _screenWidth / 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textBox("Enter your Email", false, Icons.alternate_email,
                      false, false, 1, _loginController),
                ],
              ),
            ),
            SizedBox(
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
                  textBox("Enter your password", true, Icons.password, false,
                      false, 1, _passwordController),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                String email = _loginController.text.trim();
                String password = _passwordController.text.trim();
                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: fieldText("Enter a valid email id")));
                } else if (password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: fieldText("Enter a valid password")));
                } else {
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password)
                      .then((value) => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WardenHomePage(),
                            ),
                          ))
                      .catchError(
                    (e) {
                      if (e.toString() ==
                          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: fieldText(
                                "No user available. Check whether email id is correct or not!")));
                      } else if (e.toString() ==
                          "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: fieldText("Wrong password. Retry again")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: fieldText(
                                "Oops! An error occurred. Try Again Later.")));
                      }

                      // print(e.toString());
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: fieldText(e.toString()),
                      //   ),
                      // );
                    },
                  );
                }
              },
              // onTap: () async {
              //   String id = _loginController.text.trim();
              //   String passsword = _passwordController.text.trim();

              //   if (id.isEmpty) {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(
              //         content: fieldText("Enter a valid Id"),
              //       ),
              //     );
              //   } else if (passsword.isEmpty) {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(
              //         content: fieldText("Enter a valid password"),
              //       ),
              //     );
              //   } else {
              //     QuerySnapshot snap = await FirebaseFirestore.instance
              //         .collection("Warden")
              //         .where('id', isEqualTo: id)
              //         .get();

              //     try {
              //       if (passsword == snap.docs[0]['password']) {
              //         Navigator.pushReplacement(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => WardenHomePage(),
              //           ),
              //         );
              //       } else {
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           SnackBar(
              //             content: fieldText("Wrong Password!"),
              //           ),
              //         );
              //       }
              //     } catch (e) {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(
              //           content: fieldText(e.toString()),
              //         ),
              //       );
              //     }
              //   }
              // },
              child: Container(
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
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
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
            ),
            SizedBox(
              height: _screenHeight / 20,
            ),
          ],
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

  Widget fieldText(String title) {
    return Container(
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: _screenWidth / 30,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget textBox(String hint, bool obscure, IconData ic, bool autoCorr,
      bool enableSugg, int maxLine, TextEditingController control) {
    return Container(
      width: _screenWidth / 1.25,
      decoration: BoxDecoration(
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
          Container(
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
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: _screenHeight / 30,
                ),
                border: InputBorder.none,
                hintText: hint,
              ),
              maxLines: 1,
              controller: control,
            ),
          ),
        ],
      ),
    );
  }
}
