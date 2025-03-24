import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/tba_point/ad_point.dart';
import 'package:fun_base/util/util.dart';

class BigWinController extends BaseController{

  clickDou(int reward,Function() dismiss){
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