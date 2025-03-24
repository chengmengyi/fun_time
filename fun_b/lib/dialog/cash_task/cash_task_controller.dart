import 'package:fun_b/bean/cash_info_bean.dart';
import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';
import 'package:fun_base/util/util.dart';

class CashTaskController extends BaseController{

  String getTaskStr(CashInfoBean bean){
    var tixianTask = CashHep.instance.getConfigTaskByIndex(bean.taskIndex??0);
    if(null==tixianTask){
      return "";
    }
    if(tixianTask.title=="card"){
      return "Scratch ${bean.totalPro??0} Cards";
    }else if(tixianTask.title=="video"){
      return "Watch ${bean.totalPro??0} Ad Video";
    }else{
      return "";
    }
  }

  String getTaskIcon(CashInfoBean bean){
    var tixianTask = CashHep.instance.getConfigTaskByIndex(bean.taskIndex??0);
    return tixianTask?.title==CashTaskType.card?"task_card":"task_video";
  }

  clickGo(CashInfoBean bean){
    var tixianTask = CashHep.instance.getConfigTaskByIndex(bean.taskIndex??0);
    if(null==tixianTask){
      RouterUtils.back();
      return;
    }
    if(tixianTask.title==CashTaskType.card){
      RouterUtils.back();
      EventData(code: EventCode.updateHomeIndex,intValue: 0).send();
    }else if(tixianTask.title==CashTaskType.video){
      AdHep.instance.showTaskAd(
        adType: AdType.reward,
        closeAd: (){
          RouterUtils.back();
          CashHep.instance.updateCashTask(CashTaskType.video);
        },
      );
    }else{
      RouterUtils.back();
    }
  }
}