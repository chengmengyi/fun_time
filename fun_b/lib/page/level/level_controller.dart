import 'package:fun_b/bean/level_data.dart';
import 'package:fun_b/hep/level_hep.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/tba_point/ad_point.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';
import 'package:fun_base/util/util.dart';

class LevelController extends BaseController{
  List<LevelData> list=[];

  @override
  void onInit() {
    super.onInit();
    TbaPointHep.instance.pointEvent(CustomId.level_reward_page);
  }

  @override
  void onReady() {
    super.onReady();
    _initList();
  }

  clickSingle(LevelData data){
    TbaPointHep.instance.pointEvent(CustomId.level_reward_claim,params: {"level":data.levelNum??0});
    if(data.singleStatus==LevelStatus.received){
      return;
    }
    if(data.singleStatus==LevelStatus.normal){
      showToast("Not Enough Diamonds");
      return;
    }
    UserInfoHep.instance.updateUserCoins(50);
    _updateLevelData(data.levelNum??0,LevelStatus.received,UpdateLevelStatusType.singleStatus);
  }

  clickDouble(LevelData data){
    TbaPointHep.instance.pointEvent(CustomId.level_reward_claim_double,params: {"level":data.levelNum??0});
    if(data.doubleStatus==LevelStatus.received){
      return;
    }
    if(data.doubleStatus==LevelStatus.normal){
      showToast("Not Enough Diamonds");
      return;
    }
    AdHep.instance.showAd(
      adType: AdType.reward,
      showAd: false,
      adPosId: AdPosId.sqftm_box_rv,
      closeAd: (){
        UserInfoHep.instance.updateUserCoins(100);
        _updateLevelData(data.levelNum??0,LevelStatus.received,UpdateLevelStatusType.doubleStatus);
      },
    );
  }

  _updateLevelData(int nowLevel,int status,UpdateLevelStatusType statueType)async{
    await LevelHep.instance.updateLevelData(nowLevel, status,statueType);
    _initList();
  }

  _initList()async{
    var levelList = await LevelHep.instance.getLevelList();
    list.clear();
    list.addAll(levelList);
    update(["list"]);
  }

  int getCurrentLevel()=>UserInfoHep.instance.getUserDiamond()~/3;

  double getLevelPro(){
    var d = UserInfoHep.instance.getUserDiamond()%3/3;
    if(d<=0){
      return 0.0;
    }else if(d>=1){
      return 1.0;
    }else{
      return d;
    }
  }
}