import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../constants.dart';
import 'components/header.dart';
import 'package:admin/responsive.dart'; // Pastikan sudah diimport

// WelcomeScreen seperti yang sudah dibuat
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Stream<String> getTime() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield DateFormat('HH:mm:ss').format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Selamat Datang di Aplikasi Tracking",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          StreamBuilder<String>(
            stream: getTime(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data!,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                );
              } else {
                return Text(
                  "Loading...",
                  style: TextStyle(fontSize: 24),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

// DashboardScreen yang dimodifikasi
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      WelcomeScreen(), // Memanggil WelcomeScreen di sini
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      // if (Responsive.isMobile(context)) StorageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
              ],
            )
          ],
        ),
      ),
    );
  }
}
