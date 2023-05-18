// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:attendance_app/loginScreen.dart';
import 'package:attendance_app/addStudent.dart';
import 'package:attendance_app/wardenHome.dart';
import 'firebase_options.dart';
import 'package:attendance_app/studentHome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await MongoDatabase.connect();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KeyboardVisibilityProvider(
        child: LoginScreen(),
      ),
    ),
  );
}
