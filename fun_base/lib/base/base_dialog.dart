import 'package:flutter/material.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:get/get.dart';

abstract class BaseDialog<T extends BaseController> extends StatelessWidget{
  late T ftController;
  bool _firstInit=true;

  BaseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    ftController=Get.put(createController());
    if(_firstInit){
      ftController.context=context;
      initView();
    }
    _firstInit=false;
    return Material(
      type: MaterialType.transparency,
      child: WillPopScope(
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: (){
            if(hideKeyboard()){
              var node = FocusScope.of(context);
              if(!node.hasPrimaryFocus&&node.focusedChild!=null){
                FocusManager.instance.primaryFocus?.unfocus();
              }
            }
          },
          child: Container(
            alignment: Alignment.center,
            child: createWidget(),
          ),
        ),
        onWillPop: ()async{
          return false;
        },
      ),
    );
  }

  initView(){}

  Widget createWidget();

  T createController();

  bool hideKeyboard()=>false;
}