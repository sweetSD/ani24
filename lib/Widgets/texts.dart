import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color ani24_text_blue = Color(0xff1f60ee);
const Color ani24_text_black = Color(0xff787980);
const Color ani24_text_red = Color(0xfffb4949);
const Color ani24_text_grey = Color(0xff5f6368);

class CustomText extends StatelessWidget {

  final String data;
  final TextStyle style;
  final TextAlign align;
  final TextDirection direction;
  final TextOverflow overflow;
  final double scaleFactor;
  final int maxLines;

  CustomText(
    this.data, 
  {
    this.style = const TextStyle(color: ani24_text_black), 
    this.align, 
    this.direction, 
    this.overflow, 
    this.scaleFactor, 
    this.maxLines
  });

  @override
  Widget build(BuildContext context) {
    return Text(data

    );
  }
}