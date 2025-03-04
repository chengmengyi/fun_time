import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';

class BigWinController extends BaseController{

  clickDou(int reward,Function() dismiss){
    // AdHep.instance.showAd(
    //   adType: AdType.reward,
    //   closeAd: (){
    //     UserInfoHep.instance.updateUserCoins(reward*2);
    //     RouterUtils.back();
    //     dismiss.call();
    //   },
    // );

    UserInfoHep.instance.updateUserCoins(reward*2);
    RouterUtils.back();
    dismiss.call();
  }

  clickSingle(int reward,Function() dismiss){
    UserInfoHep.instance.updateUserCoins(reward);
    RouterUtils.back();
    dismiss.call();
  }
}