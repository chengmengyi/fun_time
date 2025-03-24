import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';

class CommentController extends BaseController{
  var starIndex=-1,canClick=true;

  clickStar(int index, Function(int star) dismiss)async{
    if(!canClick){
      return;
    }
    canClick=false;
    starIndex=index;
    update(["list","finger"]);
    await Future.delayed(const Duration(milliseconds: 800));
    RouterUtils.back();
    dismiss.call(index);
  }

  clickClose(){
    if(!canClick){
      return;
    }
    RouterUtils.back();
  }
}