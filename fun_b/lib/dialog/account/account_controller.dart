import 'package:flutter/material.dart';
import 'package:fun_b/bean/cash_type_bean.dart';
import 'package:fun_b/dialog/cash_first_step/cash_first_step_dialog.dart';
import 'package:fun_b/dialog/cash_task/cash_task_dialog.dart';
import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';

class AccountController extends BaseController{
  var cashType=selectedCashType.getData(),hasContent=false;
  TextEditingController textEditingController=TextEditingController();

  List<CashTypeBean> cashTypeList=[
    CashTypeBean(unsIcon: "icon_uns_pal", selIcon: "icon_sel_pal"),
    CashTypeBean(unsIcon: "icon_uns_ama", selIcon: "icon_sel_ama"),
    CashTypeBean(unsIcon: "icon_uns_gp", selIcon: "icon_sel_gp"),
    CashTypeBean(unsIcon: "icon_uns_master", selIcon: "icon_sel_master"),
    CashTypeBean(unsIcon: "icon_uns_cash", selIcon: "icon_sel_cash"),
    CashTypeBean(unsIcon: "icon_uns_web", selIcon: "icon_sel_web"),
  ];

  @override
  void onInit() {
    super.onInit();
    TbaPointHep.instance.pointEvent(CustomId.cash_confirm_pop);
  }

  clickCashType(int index){
    if(cashType==index){
      return;
    }
    cashType=index;
    selectedCashType.saveData(cashType);
    update(["list"]);
  }

  onChanged(String v){
    hasContent=v.isNotEmpty;
    update(["btn"]);
  }

  clickBtn(int cashMoney)async{
    TbaPointHep.instance.pointEvent(CustomId.cash_confirm_pop_c);
    var content = textEditingController.text.trim();
    if(content.isEmpty){
      return;
    }
    var bean = await CashHep.instance.createCashTask(cashType, cashMoney, content);
    EventData(code: EventCode.updateCashList).send();
    UserInfoHep.instance.updateUserCoins(-cashMoney);
    RouterUtils.back();
    RouterUtils.dialog(
      widget: CashFirstStepDialog(cashType: cashType, cashMoney: cashMoney, bean: bean)
    );
  }

  @override
  void onClose() {
    super.onClose();
    textEditingController.dispose();
  }
}