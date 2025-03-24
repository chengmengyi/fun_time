import 'package:flutter_ad_ios_plugins/data/ad_info_data.dart';
import 'package:fun_base/util/tba_point/base_point.dart';
import 'package:applovin_max/applovin_max.dart';

enum AdPosId{
  sqftm_launch,
  sqftm_bubble_rv,
  sqftm_box_rv,
  sqftm_box_int,
  sqftm_level_rv,
  sqftm_level_int,
  sqftm_card_chance_rv,
  sqftm_card_fail_int,
  sqftm_card_rv,
  sqftm_card_int,
  sqftm_bigwin_rv,
  sqftm_bigwin_int,
  sqftm_skipwait_rv,
}

class AdPoint extends BasePoint{
  Future<Map<String,dynamic>> getAdMap(MaxAd? maxAd,AdInfoData? adInfoData,AdPosId adPosId)async{
    var map = await getBaseMap();
    map["sparse"]={
      "goofy":(maxAd?.revenue??0)*1000000,
      "drama":"USD",
      "pluck":maxAd?.networkName??"",
      "impish":adInfoData?.adPlat??"",
      "puerto":adInfoData?.adId??"",
      "zambia":adPosId.name,
      "autonomy":adInfoData?.adType??"",
      "axiom":maxAd?.revenuePrecision??"",
    };
    return map;
  }
}