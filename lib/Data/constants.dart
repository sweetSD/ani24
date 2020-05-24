import 'package:ani24/Widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String get baseurl => 'http://ani24do.com';

roundBoxDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [BoxShadow(color: Color(0xffcccccc), blurRadius: 1.0, spreadRadius: 1.0, offset: Offset(0, 1))]
  );
}