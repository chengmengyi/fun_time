import 'package:flutter/material.dart';
import 'package:fun_base/util/util.dart';

class TextWidget extends StatelessWidget{
  String data;
  String color;
  double size;
  FontWeight? fontWeight;
  String? fontFamily;
  FontStyle? fontStyle;
  TextOverflow? overflow;
  double? colorOpacity;
  TextAlign? textAlign;

  TextWidget({
    required this.data,
    required this.color,
    required this.size,
    this.fontWeight,
    this.fontFamily,
    this.fontStyle,
    this.overflow,
    this.colorOpacity,
    this.textAlign,
});

  @override
  Widget build(BuildContext context) => Text(
    data,
    textAlign: textAlign,
    style: TextStyle(
      color: null==colorOpacity?color.toColor():color.toColor().withOpacity(colorOpacity!),
      fontSize: size,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      overflow: overflow,
    ),
  );
}