import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';

class CashSuccessController extends BaseController{

  click(int cashType,int cashMoney)async{
    await CashHep.instance.completedCashTask(cashType, cashMoney);
    RouterUtils.back();
  }
}