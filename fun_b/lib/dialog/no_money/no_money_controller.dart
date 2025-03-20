import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';

class NoMoneyController extends BaseController{

  click(){
    RouterUtils.back();
    EventData(code: EventCode.updateHomeIndex,intValue: 0).send();
  }
}