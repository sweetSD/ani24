import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color ani24_text_blue = Color(0xff1f60ee);
const Color ani24_text_black = Color(0xff787980);
const Color ani24_text_red = Color(0xfffb4949);
const Color ani24_text_grey = Color(0xff5f6368);

enum TextType {
  Light,
  Regular,
  Medium,
  SemiBold,
  Bold,
  ExtraBold,
}

getFontWeight(TextType type) {
  switch(type) {
    case TextType.Light:
      return FontWeight.w300;
    case TextType.Regular:
      return FontWeight.w400;
    case TextType.Medium:
      return FontWeight.w500;
    case TextType.SemiBold:
      return FontWeight.w600;
    case TextType.Bold:
      return FontWeight.w700;
    case TextType.ExtraBold:
      return FontWeight.w800;
  }
}

class CustomText extends StatelessWidget {

  final String data;
  final double size;
  final TextStyle style;
  final TextType type;
  final TextAlign align;
  final TextDirection direction;
  final TextOverflow overflow;
  final double scaleFactor;
  final int maxLines;

  CustomText(
    this.data, 
  {
    this.type = TextType.Regular,
    this.size = 14,
    this.style = const TextStyle(color: ani24_text_black), 
    this.align, 
    this.direction, 
    this.overflow, 
    this.scaleFactor, 
    this.maxLines
  });

  @override
  Widget build(BuildContext context) {
    return Text(data,
      style: style.copyWith(fontSize: size, fontWeight: getFontWeight(type)),
      textAlign: align,
      textDirection: direction,
      overflow: overflow,
      textScaleFactor: scaleFactor,
      maxLines: maxLines,
    );
  }
}