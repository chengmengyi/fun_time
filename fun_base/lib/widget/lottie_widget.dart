import 'package:flutter/material.dart';
import 'package:fun_base/util/util.dart';
import 'package:lottie/lottie.dart';

class LottieWidget extends StatelessWidget{
  String name;
  String ext;
  double? width;
  double? height;
  bool? repeat;
  LottieWidget({
    required this.name,
    required this.ext,
    this.width,
    this.height,
    this.repeat,
});
  @override
  Widget build(BuildContext context) => Lottie.asset("ft_resource/lottie/$name.$ext",width: width,height: height,fit: BoxFit.fitWidth,repeat: repeat??true);

}