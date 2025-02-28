import 'package:fun_a/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';

class UpLevelController extends BaseController{

  clickGet(Function() dismiss){
    UserInfoHep.instance.updateUserCoins(800);
    dismiss.call();
  }
}