import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_b/hep/game_config_hep.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/tba_point/ad_point.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';
import 'package:fun_base/util/util.dart';

class AddChanceController extends BaseController{
  @override
  void onInit() {
    super.onInit();
    TbaPointHep.instance.pointEvent(CustomId.more_chance_pop);
  }

  clickVideo(WinnerType winnerType){
    TbaPointHep.instance.pointEvent(CustomId.more_chance_pop_c);
    AdHep.instance.showAd(
      adType: AdType.reward,
      adPosId: AdPosId.sqftm_card_chance_rv,
      showIntAd: CashHep.instance.checkShowIntAd(AdType.reward),
      closeAd: (){
        RouterUtils.back();
        _addPlayNum(winnerType, true);
      },
    );
  }

  // clickCoins(WinnerType winnerType){
  //   RouterUtils.back();
  //   _addPlayNum(winnerType, false);
  // }

  _addPlayNum(WinnerType winnerType,bool fromVideo){
    UserInfoHep.instance.updateCanPlayNum(1,winnerType,fromVideo: fromVideo);
  }
}