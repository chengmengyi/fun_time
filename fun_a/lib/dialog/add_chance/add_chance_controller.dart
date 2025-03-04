import 'package:fun_a/hep/game_config_hep.dart';
import 'package:fun_a/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/util.dart';

class AddChanceController extends BaseController{

  clickVideo(WinnerType winnerType){
    // AdHep.instance.showAd(
    //   adType: AdType.reward,
    //   closeAd: (){
    //     RouterUtils.back();
    //     _addPlayNum(winnerType, true);
    //   },
    // );
  }

  clickCoins(WinnerType winnerType){
    RouterUtils.back();
    _addPlayNum(winnerType, false);
  }

  _addPlayNum(WinnerType winnerType,bool fromVideo){
    UserInfoHep.instance.updateCanPlayNum(1,winnerType,fromVideo: fromVideo);
  }
}