import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';
import 'package:fun_base/util/tba_point/ad_point.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';
import 'package:fun_base/util/util.dart';

class BoxDialogController extends BaseController{
  var addNum=0.0;

  @override
  void onInit() {
    super.onInit();
    addNum=CashHep.instance.getBoxAddNum();
    TbaPointHep.instance.pointEvent(CustomId.box_double_pop);
  }

  clickDouble(Function(bool received) dismiss){
    TbaPointHep.instance.pointEvent(CustomId.box_double_pop_c);
    AdHep.instance.showAd(
      adType: AdType.reward,
      adPosId: AdPosId.sqftm_box_rv,
      showAd: CashHep.instance.checkShowAd(AdType.reward),
      closeAd: (){
        UserInfoHep.instance.updateUserCoins((Decimal.parse("$addNum")*Decimal.fromInt(2)).toDouble());
        RouterUtils.back();
        dismiss.call(true);
      },
    );
  }

  clickGiveUp(Function(bool received) dismiss){
    TbaPointHep.instance.pointEvent(CustomId.box_double_pop_close);
    AdHep.instance.showAd(
      adType: AdType.interstitial,
      adPosId: AdPosId.sqftm_box_int,
      showAd: CashHep.instance.checkShowAd(AdType.interstitial),
      closeAd: (){
        EventData(code: EventCode.showBoxFinger).send();
        RouterUtils.back();
        dismiss.call(false);
      },
    );
  }

}