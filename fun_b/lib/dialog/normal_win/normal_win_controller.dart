import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_b/hep/game_config_hep.dart';
import 'package:fun_b/hep/hep.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/tba_point/ad_point.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';
import 'package:fun_base/util/util.dart';

class NormalWinController extends BaseController{
  WinnerType winnerType=WinnerType.fruitMatch;

  @override
  void onInit() {
    super.onInit();
    TbaPointHep.instance.pointEvent(CustomId.coin_pop,params: {"source_from":Hep.getTbaPlayTypeStr(winnerType)});
    if(firstRewardDialogShow.getData()){
      firstRewardDialogShow.saveData(false);
      TbaPointHep.instance.pointEvent(CustomId.card_coin_guide_pop);
    }
  }

  // clickDouble(int reward,Function() dismiss){
  //
  //   AdHep.instance.showAd(
  //     adType: AdType.reward,
  //     adPosId: AdPosId.sqftm_card_rv,
  //     showAd: CashHep.instance.checkShowAd(AdType.reward),
  //     closeAd: (){
  //       UserInfoHep.instance.updateUserCoins((Decimal.parse("$reward")*Decimal.fromInt(2)).toDouble());
  //       RouterUtils.back();
  //       dismiss.call();
  //     },
  //   );
  // }

  clickSingle(int reward,Function() dismiss){
    TbaPointHep.instance.pointEvent(CustomId.coin_pop_c,params: {"source_from":Hep.getTbaPlayTypeStr(winnerType)});
    if(firstRewardDialogClickClaim.getData()){
      firstRewardDialogClickClaim.saveData(false);
      TbaPointHep.instance.pointEvent(CustomId.card_coin_guide_pop_c);
    }
    AdHep.instance.showAd(
      adType: AdType.interstitial,
      adPosId: AdPosId.sqftm_card_int,
      showAd: CashHep.instance.checkShowAd(AdType.interstitial),
      closeAd: (){
        UserInfoHep.instance.updateUserCoins(reward);
        RouterUtils.back();
        dismiss.call();
      },
    );
  }
}