import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';

class NormalWinController extends BaseController{

  clickGet(int reward,Function() dismiss){
    UserInfoHep.instance.updateUserCoins(reward);
    RouterUtils.back();
    dismiss.call();
  }
}