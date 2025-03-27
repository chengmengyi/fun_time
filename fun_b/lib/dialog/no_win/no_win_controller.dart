import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/tba_point/ad_point.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';
import 'package:fun_base/util/util.dart';

class NoWinController extends BaseController{
  @override
  void onInit() {
    super.onInit();
    TbaPointHep.instance.pointEvent(CustomId.play_fail_pop);
  }

  clickAgain(Function() dismiss){
    TbaPointHep.instance.pointEvent(CustomId.play_fail_pop_c);
    AdHep.instance.showAd(
      adType: AdType.interstitial,
      adPosId: AdPosId.sqftm_card_fail_int,
      showAd: CashHep.instance.checkShowAd(AdType.interstitial),
      closeAd: (){
        RouterUtils.back();
        dismiss.call();
      },
    );
  }

}