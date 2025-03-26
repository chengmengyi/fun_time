import 'package:fun_b/bean/cash_info_bean.dart';
import 'package:fun_b/bean/cash_list_bean.dart';
import 'package:fun_b/bean/cash_type_bean.dart';
import 'package:fun_b/dialog/account/account_dialog.dart';
import 'package:fun_b/dialog/cash_first_step/cash_first_step_dialog.dart';
import 'package:fun_b/dialog/cash_success/cash_success_dialog.dart';
import 'package:fun_b/dialog/cash_task/cash_task_dialog.dart';
import 'package:fun_b/dialog/no_money/no_money_dialog.dart';
import 'package:fun_b/dialog/rank/rank_dialog.dart';
import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_result.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';

class CashController extends BaseController{
  var chooseCashTypeIndex=0;
  List<CashTypeBean> cashTypeList=[
    CashTypeBean(unsIcon: "icon_uns_pal", selIcon: "icon_sel_pal"),
    CashTypeBean(unsIcon: "icon_uns_ama", selIcon: "icon_sel_ama"),
    CashTypeBean(unsIcon: "icon_uns_gp", selIcon: "icon_sel_gp"),
    CashTypeBean(unsIcon: "icon_uns_master", selIcon: "icon_sel_master"),
    CashTypeBean(unsIcon: "icon_uns_cash", selIcon: "icon_sel_cash"),
    CashTypeBean(unsIcon: "icon_uns_web", selIcon: "icon_sel_web"),
  ];

  final List<String> _payBgList=["pay_bg_pal","pay_bg_ama","pay_bg_gp","pay_bg_master","pay_bg_cash","pay_bg_web"];
  List<CashListBean> cashList=[];

  @override
  void onInit() {
    super.onInit();
    chooseCashTypeIndex=selectedCashType.getData();
  }

  @override
  void onReady() {
    super.onReady();
    _initCashList();
  }

  clickCashType(int index){
    if(chooseCashTypeIndex==index){
      return;
    }
    chooseCashTypeIndex=index;
    selectedCashType.saveData(chooseCashTypeIndex);
    update(["cash_type","cash_bg"]);
    _initCashList();
  }

  clickCashBtn(CashListBean bean){
    TbaPointHep.instance.pointEvent(CustomId.cash_page_c);
    if(null==bean.cashInfoBean){
      if(UserInfoHep.instance.getUserCoins()<bean.cashMoney){
        RouterUtils.dialog(
          widget: NoMoneyDialog(
            money: bean.cashMoney,
          ),
        );
        return;
      }else{
        RouterUtils.dialog(
          widget: AccountDialog(
            cashMoney: bean.cashMoney,
          ),
        );
      }
    }else{
      switch(bean.cashInfoBean?.cashStatus){
        case CashStatus.cards:
          RouterUtils.dialog(
            widget: CashFirstStepDialog(
              cashType: chooseCashTypeIndex,
              cashMoney: bean.cashMoney,
              bean: bean.cashInfoBean!,
            ),
          );
          break;
        case CashStatus.task:
          RouterUtils.dialog(
              widget: CashTaskDialog(bean: bean.cashInfoBean!)
          );
          break;
        case CashStatus.rank:
          RouterUtils.dialog(
            widget: RankDialog(
              cashTypeIcon: cashTypeList[chooseCashTypeIndex].selIcon,
              cashType: chooseCashTypeIndex,
              cashMoney: bean.cashMoney,
            ),
          );
          break;
        case CashStatus.complete:
          RouterUtils.dialog(
            widget: CashSuccessDialog(
              cashType: chooseCashTypeIndex,
              cashMoney: bean.cashMoney,
            ),
          );
          break;
      }
    }
  }

  String getCashMoneyBg()=>_payBgList[chooseCashTypeIndex];

  _initCashList()async{
    cashList.clear();
    var list = await CashHep.instance.initCashList(chooseCashTypeIndex);
    cashList.addAll(list);
    update(["list"]);
  }

  String getTaskLeftStr(CashInfoBean bean){
    if(bean.cashStatus==CashStatus.cards){
      return "Scratch ";
    }
    var tixianTask = CashHep.instance.getConfigTaskByIndex(bean.taskIndex??0);
    if(null==tixianTask){
      return "";
    }
    if(tixianTask.title=="card"){
      return "Scratch ";
    }else if(tixianTask.title=="video"){
      return "Watch ";
    }else{
      return "";
    }
  }

  String getTaskRightStr(CashInfoBean bean){
    if(bean.cashStatus==CashStatus.cards){
      return " Cards";
    }
    var tixianTask = CashHep.instance.getConfigTaskByIndex(bean.taskIndex??0);
    if(null==tixianTask){
      return "";
    }
    if(tixianTask.title=="card"){
      return " Cards";
    }else if(tixianTask.title=="video"){
      return " Ad Video";
    }else{
      return "";
    }
  }

  double getTaskPro(CashInfoBean? bean){
    var totalPro = bean?.totalPro??0;
    if(totalPro<=0){
      return 0.0;
    }
    var d = (bean?.currentPro??0)/totalPro;
    if(d<=0){
      return 0.0;
    }else if(d>=1){
      return 1.0;
    }else{
      return d;
    }
  }

  double getMoneyPro(int money){
    var d = UserInfoHep.instance.getUserCoins()/money;
    if(d<=0){
      return 0.0;
    }else if(d>=1){
      return 1.0;
    }else{
      return d;
    }
  }

  String getCashBtnStr(CashInfoBean? bean){
    if(null==bean){
      return "Cash Out";
    }
    if(bean.cashStatus==CashStatus.complete){
      return "Successful";
    }
    return "Processing";
  }

  String getCashBtnIcon(CashInfoBean? bean){
    if(null==bean){
      return "cash2";
    }
    else if(bean.cashStatus==CashStatus.complete){
      return "btn_success";
    }
    return "btn_process";
  }

  String getTaskIcon(CashInfoBean? bean){
    if(bean?.cashStatus==CashStatus.cards){
      return "task_card";
    }
    var tixianTask = CashHep.instance.getConfigTaskByIndex(bean?.taskIndex??0);
    return tixianTask?.title==CashTaskType.card?"task_card":"task_video";
  }

  @override
  EventResult? initEventResult() => EventResult(
    call: (data){
      switch(data.code){
        case EventCode.updateCashList:
          _initCashList();
          break;
        case EventCode.updateUserCoinsB:
          update(["list"]);
          break;
      }
    },
  );
}