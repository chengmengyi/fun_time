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
  bool? showShadows;

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
    this.showShadows=true,
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
      shadows: showShadows==true?[
      Shadow(
          color: "#000000".toColor(),
          blurRadius: 2.w,
          offset: Offset(0,0.5.w)
      )
      ]:null,
    ),
  );
}