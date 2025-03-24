import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/base_routers/base_routers_name.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/base_local_data.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/util/voice_player.dart';

class SetController extends BaseController{

  clickBg(){
    VoicePlayer.instance.setPlayOrStopBg();
    update(["bg"]);
  }

  clickGk(){
    VoicePlayer.instance.setPlayOrStopVoice();
    update(["gk"]);
  }

  toWeb(){
    RouterUtils.toNamed(routersName: BaseRoutersName.web,params: {"url":privacy});
  }


  toEmail()async{
    var uri = Uri(scheme: "mailto",path: email);
    var can = await canLaunchUrl(uri);
    if(can){
      launchUrl(uri);
    }
  }
}