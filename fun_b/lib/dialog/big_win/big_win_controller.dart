import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/tba_point/ad_point.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';
import 'package:fun_base/util/util.dart';

class BigWinController extends BaseController{
  void onInit() {
    super.onInit();
    TbaPointHep.instance.pointEvent(CustomId.bigwin_pop);
    if(firstRewardDialogShow.getData()){
      firstRewardDialogShow.saveData(false);
      TbaPointHep.instance.pointEvent(CustomId.card_coin_guide_pop);
    }
  }

  clickDou(int reward,Function() dismiss){
    TbaPointHep.instance.pointEvent(CustomId.bigwin_pop_c);
    if(firstRewardDialogClickClaim.getData()){
      firstRewardDialogClickClaim.saveData(false);
      TbaPointHep.instance.pointEvent(CustomId.card_coin_guide_pop_c);
    }
    AdHep.instance.showAd(
      adType: AdType.reward,
      adPosId: AdPosId.sqftm_bigwin_rv,
      showIntAd: CashHep.instance.checkShowIntAd(AdType.reward),
      closeAd: (){
        UserInfoHep.instance.updateUserCoins(reward*2);
        RouterUtils.back();
        dismiss.call();
      },
    );
  }

  clickSingle(int reward,Function() dismiss){
    TbaPointHep.instance.pointEvent(CustomId.bigwin_pop_close);
    AdHep.instance.showAd(
      adType: AdType.interstitial,
      adPosId: AdPosId.sqftm_bigwin_int,
      showIntAd: CashHep.instance.checkShowIntAd(AdType.interstitial),
      closeAd: (){
        UserInfoHep.instance.updateUserCoins(reward);
        RouterUtils.back();
        dismiss.call();
      },
    );
  }
}