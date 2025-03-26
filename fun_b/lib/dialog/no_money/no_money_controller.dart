import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';

class NoMoneyController extends BaseController{

  @override
  void onInit() {
    super.onInit();
    TbaPointHep.instance.pointEvent(CustomId.cash_not_pop);
  }

  click(){
    TbaPointHep.instance.pointEvent(CustomId.cash_not_pop_c);
    RouterUtils.back();
    EventData(code: EventCode.updateHomeIndex,intValue: 0).send();
  }
}