import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';

class BoxDialogController extends BaseController{

  clickGet(Function() dismiss){
    RouterUtils.back();
    dismiss.call();
  }
}