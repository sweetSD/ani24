import 'package:ani24/Screens/main.dart';
import 'package:ani24/Widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ani24',
      theme: ThemeData(
        iconTheme: IconThemeData(color: ani24_text_black),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: ani24_text_black
      ),
      home: MainPage(),
    );
  }
}
