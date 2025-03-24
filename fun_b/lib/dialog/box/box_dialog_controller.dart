import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/tba_point/ad_point.dart';
import 'package:fun_base/util/util.dart';

class BoxDialogController extends BaseController{
  var addNum=0.0;

  @override
  void onInit() {
    super.onInit();
    addNum=CashHep.instance.getBoxAddNum();
  }

  clickDouble(Function() dismiss){
    AdHep.instance.showAd(
      adType: AdType.reward,
      adPosId: AdPosId.sqftm_box_rv,
      showIntAd: CashHep.instance.checkShowIntAd(AdType.reward),
      closeAd: (){
        UserInfoHep.instance.updateUserCoins((Decimal.parse("$addNum")*Decimal.fromInt(2)).toDouble());
        RouterUtils.back();
        dismiss.call();
      },
    );
  }

  clickGet(Function() dismiss){
    AdHep.instance.showAd(
      adType: AdType.interstitial,
      adPosId: AdPosId.sqftm_box_int,
      showIntAd: CashHep.instance.checkShowIntAd(AdType.interstitial),
      closeAd: (){
        UserInfoHep.instance.updateUserCoins(addNum);
        RouterUtils.back();
        dismiss.call();
      },
    );
  }

}