import 'package:flutter/material.dart';
import 'package:fun_b/dialog/cash_task/cash_task_dialog.dart';
import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';

class AccountController extends BaseController{
  var cashType=selectedCashType.getData(),hasContent=false;
  TextEditingController textEditingController=TextEditingController();

  onChanged(String v){
    hasContent=v.isNotEmpty;
    update(["btn"]);
  }

  clickBtn(int cashMoney)async{
    var content = textEditingController.text.trim();
    if(content.isEmpty){
      return;
    }
    var bean = await CashHep.instance.createCashTask(cashType, cashMoney, content);
    EventData(code: EventCode.updateCashList).send();
    UserInfoHep.instance.updateUserCoins(-cashMoney);
    RouterUtils.back();
    RouterUtils.dialog(
      widget: CashTaskDialog(bean: bean)
    );
  }

  @override
  void onClose() {
    super.onClose();
    textEditingController.dispose();
  }
}