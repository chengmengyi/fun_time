import 'package:flutter/material.dart';
import 'package:fun_base/util/util.dart';
import 'package:lottie/lottie.dart';

class FingerWidget extends StatelessWidget{
  double? width;
  double? height;
  FingerWidget({this.width,this.height});

  @override
  Widget build(BuildContext context) => Lottie.asset("ft_resource/lottie/finger.json",width: width??44.w,height: height??44.h);

}