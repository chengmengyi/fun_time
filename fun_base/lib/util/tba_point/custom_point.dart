import 'package:fun_base/util/tba_point/base_point.dart';

enum CustomId{
  organic_to_buy,
  session,
  install,
  launch_page,
  cloak_req,
  cloak_suc,
  af_req,
  af_suc,
  card_page,
  card_guide,
  card_guide_c,
  card_coin_guide_pop,
  card_coin_guide_pop_c,
  daily_wheel_pop,
  daily_wheel_pop_c,
  card_detail_page,
  box_c,
  box_double_pop,
  box_double_pop_c,
  box_double_pop_close,
  bigwin_pop,
  bigwin_pop_c,
  bigwin_pop_close,
  coin_pop,
  coin_pop_c,
  play_fail_pop,
  play_fail_pop_c,
  more_chance_pop,
  more_chance_pop_c,
  level_reward_page,
  level_reward_claim,
  level_reward_claim_double,
  cash_page,
  float_c,
  cash_page_c,
  cash_task_pop,
  cash_task_pop_c,
  cash_confirm_pop,
  cash_confirm_pop_c,
  cash_queue_pop,
  cash_queue_po_c,
  one_last_step_pop,
  one_last_step_pop_c,
  cash_not_pop,
  cash_not_pop_c,
  inform_c,
  push_status,
  cash_money_detail,
  cash_ad_detail,
  sqftm_ad_chance,
  sqftm_ad_impression_fail,
  sqftm_ad_impression,
  testSql,
}

class CustomPoint extends BasePoint{
  Future<Map<String,dynamic>> getCustomMap(CustomId customId,Map<String, dynamic>? params)async{
    var map = await getBaseMap();
    map["ruben"]=customId.name;
    if(null!=params){
      for (var keys in params.keys) {
        map["paunch^$keys"]=params[keys];
      }
    }
    return map;
  }
}