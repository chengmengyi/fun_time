import 'package:fun_b/bean/cash_info_bean.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';

class CashFirstStepController extends BaseController{
  @override
  void onInit() {
    super.onInit();
    TbaPointHep.instance.pointEvent(CustomId.cash_task_pop);
  }

  double getPro(CashInfoBean bean){
    if((bean.totalPro??0)==0){
      return 0.0;
    }
    var d = (bean.currentPro??0)/(bean.totalPro??0);
    if(d>=1.0){
      return 1.0;
    }else if(d<=0.0){
      return 0.0;
    }else{
      return d;
    }
  }

  click(){
    TbaPointHep.instance.pointEvent(CustomId.cash_task_pop_c);
    RouterUtils.back();
    EventData(code: EventCode.updateHomeIndex,intValue: 0).send();
  }
}