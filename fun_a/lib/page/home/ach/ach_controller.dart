import 'package:fun_a/bean/ach_bean.dart';
import 'package:fun_a/dialog/normal_win/normal_win_dialog.dart';
import 'package:fun_a/hep/ach_hep.dart';
import 'package:fun_a/hep/game_config_hep.dart';
import 'package:fun_a/hep/hep.dart';
import 'package:fun_a/hep/played_num_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_result.dart';
import 'package:fun_base/util/util.dart';

class AchController extends BaseController{
  List<AchBean> achList=[];

  @override
  void onReady() {
    super.onReady();
    _initAchList();
  }

  _initAchList()async{
    achList.clear();
    achList.addAll((await AchHep.instance.getAchList()));
    update(["list"]);
  }

  double getPro(AchBean bean){
    if((bean.totalPro??0)==0){
      return 0.0;
    }
    var d = (bean.currentPro??0)/(bean.totalPro??0);
    if(d<=0){
      return 0.0;
    }else if(d>=1.0){
      return 1.0;
    }else{
      return d;
    }
  }

  String getBtnStr(AchBean bean){
    switch(bean.status){
      case AchStatus.go: return "GO";
      case AchStatus.receive: return "Receive";
      case AchStatus.collected: return "Collected";
      default: return "";
    }
  }

  clickBtn(AchBean bean)async{
    if(bean.status==AchStatus.go){
      switch(bean.achType){
        case AchType.fruit:
          var canPlay = await PlayedNumHep.instance.checkCanPlay(WinnerType.fruitMatch);
          if(canPlay){
            Hep.toPlayPage(WinnerType.fruitMatch);
          }
          break;
        case AchType.winner:
          var canPlay = await PlayedNumHep.instance.checkCanPlay(WinnerType.winnerGame);
          if(canPlay){
            Hep.toPlayPage(WinnerType.winnerGame);
          }
          break;
        case AchType.betting:
          var canPlay = await PlayedNumHep.instance.checkCanPlay(WinnerType.bettingHigh);
          if(canPlay){
            Hep.toPlayPage(WinnerType.bettingHigh);
          }
          break;
        case AchType.chasing:
          var canPlay = await PlayedNumHep.instance.checkCanPlay(WinnerType.chasingLuck);
          if(canPlay){
            Hep.toPlayPage(WinnerType.chasingLuck);
          }
          break;
        default:
          var winnerType = await PlayedNumHep.instance.randomPlay();
          if(null!=winnerType){
            Hep.toPlayPage(winnerType);
          }else{
            showToast("No scratch card, please try again later！");
          }
          break;
      }
      return;
    }
    if(bean.status==AchStatus.receive){
      RouterUtils.dialog(
        widget: NormalWinDialog(
          reward: 1000,
          dismiss: (){
            AchHep.instance.updateAchCollectedStatus(bean.achType??"");
          },
        ),
      );
    }
  }

  @override
  EventResult? initEventResult() => EventResult(
    call: (data){
      if(data.code==EventCode.updateAchA){
        _initAchList();
      }
    }
  );
}