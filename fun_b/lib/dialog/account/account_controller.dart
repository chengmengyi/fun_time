import 'package:flutter/material.dart';
import 'package:fun_b/bean/cash_type_bean.dart';
import 'package:fun_b/dialog/cash_task/cash_task_dialog.dart';
import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';

class AccountController extends BaseController{
  var cashType=selectedCashType.getData(),hasContent=false;
  List<CashTypeBean> cashTypeList=[
    CashTypeBean(unsIcon: "icon_uns_pal", selIcon: "icon_sel_pal"),
    CashTypeBean(unsIcon: "icon_uns_ama", selIcon: "icon_sel_ama"),
    CashTypeBean(unsIcon: "icon_uns_gp", selIcon: "icon_sel_gp"),
    CashTypeBean(unsIcon: "icon_uns_master", selIcon: "icon_sel_master"),
    CashTypeBean(unsIcon: "icon_uns_cash", selIcon: "icon_sel_cash"),
    CashTypeBean(unsIcon: "icon_uns_web", selIcon: "icon_sel_web"),
  ];

  TextEditingController textEditingController=TextEditingController();

  onChanged(String v){
    hasContent=v.isNotEmpty;
    update(["btn"]);
  }

  clickBtn()async{
    var content = textEditingController.text.trim();
    if(content.isEmpty){
      return;
    }
    var bean = await CashHep.instance.createCashTask(cashType, CashHep.instance.getConfigCashMoneyList().first, content);
    RouterUtils.back();
    EventData(code: EventCode.updateCashList).send();
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