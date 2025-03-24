import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/tba_point/ad_point.dart';
import 'package:fun_base/util/util.dart';

class NoWinController extends BaseController{
  clickAgain(Function() dismiss){
    AdHep.instance.showAd(
      adType: AdType.interstitial,
      adPosId: AdPosId.sqftm_card_fail_int,
      showIntAd: CashHep.instance.checkShowIntAd(AdType.interstitial),
      closeAd: (){
        RouterUtils.back();
        dismiss.call();
      },
    );
  }
}