// ignore_for_file: file_names, non_constant_identifier_names, avoid_unnecessary_containers, unused_import, unused_field

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:geolocator/geolocator.dart';

class QRCodeScanner extends StatefulWidget {
  final String text;
  const QRCodeScanner({Key? key, required this.text}) : super(key: key);

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState(this.text);
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final String text;
  _QRCodeScannerState(this.text);
  double _screenWidth = 0;
  double _screenHeight = 0;

  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: _screenWidth,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(child: buildQRView(context)),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(barcode != null
                          ? 'Result : ${barcode!.code}'
                          : 'Scan attendance code'),
                    ),
                  ),
                  Expanded(
                      child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if (barcode!.code == date.toString()) {
                          FirebaseFirestore.instance
                              .collection('dates')
                              .doc(date.toString())
                              .snapshots()
                              .elementAt(0)
                              .then((value) {
                            if (value.get('time').toString().length == 4) {
                              if (int.parse(value.get('time')) >=
                                  int.parse(TimeOfDay.now().hour.toString() +
                                      TimeOfDay.now().minute.toString())) {
                                print(int.parse(
                                    TimeOfDay.now().hour.toString() +
                                        TimeOfDay.now().minute.toString()));
                                _getCurrentLocation().then(
                                  (value) {
                                    String lat = '${value.latitude}';
                                    String long = '${value.longitude}';

                                    FirebaseFirestore.instance
                                        .collection('warden')
                                        .get()
                                        .then(
                                      (value) async {
                                        final String fireLat = value.docs[0]
                                            .get('latitude')
                                            .toString();
                                        final String fireLong = value.docs[0]
                                            .get('longitude')
                                            .toString();
                                        print(Geolocator.distanceBetween(
                                                double.parse(lat),
                                                double.parse(long),
                                                double.parse(fireLat),
                                                double.parse(fireLong))
                                            .abs()
                                            .toInt());

                                        if (Geolocator.distanceBetween(
                                                    double.parse(lat),
                                                    double.parse(long),
                                                    double.parse(fireLat),
                                                    double.parse(fireLong))
                                                .abs()
                                                .toInt() <=
                                            52400) {
                                          FirebaseFirestore.instance
                                              .collection('dates')
                                              .doc(date.toString())
                                              .update({
                                            TimeOfDay.now().toString(): text
                                          }).then((value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Attendance marked succefully'),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              elevation: 6.0,
                                              backgroundColor: Colors.black,
                                            ));
                                            Navigator.pop(context);
                                          }).catchError((e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'An error occured. Try Again Later!'),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              elevation: 6.0,
                                              backgroundColor: Colors.black,
                                            ));
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text('Location does not match'),
                                            behavior: SnackBarBehavior.floating,
                                            elevation: 6.0,
                                            backgroundColor: Colors.black,
                                          ));
                                        }
                                      },
                                    );
                                  },
                                );
                              }
                            } else if (value.get('time').toString().length ==
                                3) {
                              String t = value.get('time').toString() + '0';
                              print(t);
                              if (int.parse(t) >=
                                  int.parse(TimeOfDay.now().hour.toString() +
                                      TimeOfDay.now().minute.toString())) {
                                print(int.parse(
                                    TimeOfDay.now().hour.toString() +
                                        TimeOfDay.now().minute.toString()));
                                _getCurrentLocation().then(
                                  (value) {
                                    String lat = '${value.latitude}';
                                    String long = '${value.longitude}';

                                    FirebaseFirestore.instance
                                        .collection('warden')
                                        .get()
                                        .then(
                                      (value) async {
                                        final String fireLat = value.docs[0]
                                            .get('latitude')
                                            .toString();
                                        final String fireLong = value.docs[0]
                                            .get('longitude')
                                            .toString();
                                        print(Geolocator.distanceBetween(
                                                double.parse(lat),
                                                double.parse(long),
                                                double.parse(fireLat),
                                                double.parse(fireLong))
                                            .abs()
                                            .toInt());

                                        if (Geolocator.distanceBetween(
                                                    double.parse(lat),
                                                    double.parse(long),
                                                    double.parse(fireLat),
                                                    double.parse(fireLong))
                                                .abs()
                                                .toInt() <=
                                            52400) {
                                          FirebaseFirestore.instance
                                              .collection('dates')
                                              .doc(date.toString())
                                              .update({
                                            TimeOfDay.now().toString(): text
                                          }).then((value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Attendance marked succefully'),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              elevation: 6.0,
                                              backgroundColor: Colors.black,
                                            ));
                                            Navigator.pop(context);
                                          }).catchError((e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'An error occured. Try Again Later!'),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              elevation: 6.0,
                                              backgroundColor: Colors.black,
                                            ));
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text('Location does not match'),
                                            behavior: SnackBarBehavior.floating,
                                            elevation: 6.0,
                                            backgroundColor: Colors.black,
                                          ));
                                        }
                                      },
                                    );
                                  },
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    'Attendance for this time might have expired or invalid'),
                                behavior: SnackBarBehavior.floating,
                                elevation: 6.0,
                                backgroundColor: Colors.black,
                              ));
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                'Attendance for this date might have expired or invalid'),
                            behavior: SnackBarBehavior.floating,
                            elevation: 6.0,
                            backgroundColor: Colors.black,
                          ));
                        }
                      },
                      child: Container(
                        width: _screenWidth * .6,
                        height: _screenHeight / 15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add,
                              color: Colors.green,
                            ),
                            fieldText("Mark attendance", Colors.green),
                          ],
                        ),
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQRView(BuildContext context) => SizedBox(
        height: _screenHeight * .7,
        width: _screenWidth * .7,
        child: QRView(
          key: qrKey,
          onQRViewCreated: onQRViewCreated,
          overlay: QrScannerOverlayShape(
            cutOutSize: _screenWidth * 0.5,
            borderColor: Colors.white,
            borderWidth: 10,
            borderRadius: 20.0,
            borderLength: 20.0,
          ),
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.scannedDataStream.listen((barcode) {
        setState(() {
          this.barcode = barcode;
        });
      });
    });
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
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
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
