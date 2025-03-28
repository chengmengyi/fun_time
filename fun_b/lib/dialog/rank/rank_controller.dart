import 'dart:math';
import 'package:fun_b/bean/rank_list_bean.dart';
import 'package:fun_b/dialog/cash_success/cash_success_dialog.dart';
import 'package:fun_b/dialog/cash_task/cash_task_dialog.dart';
import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';
import 'package:fun_base/util/util.dart';

class RankController extends BaseController{
  int cashType=0,cashMoney=0,myRankNum=0,rankAll=0;
  List<RankListBean> rankList=[];

  @override
  void onInit() {
    super.onInit();
    TbaPointHep.instance.pointEvent(CustomId.cash_queue_pop);
  }

  @override
  void onReady() {
    super.onReady();
    _initList();
  }

  clickWatchAd()async{
    if(myRankNum<=1){
      var cashInfo = await CashHep.instance.queryCashInfoByCashTypeMoney(cashType, cashMoney);
      if(null!=cashInfo){
        RouterUtils.back();
        RouterUtils.dialog(
            widget: CashTaskDialog(bean: cashInfo)
        );
      }
      return;
    }
    TbaPointHep.instance.pointEvent(CustomId.cash_queue_po_c,params: {"ad_number":cashTaskWatchVideoNum.getData()+1});
    AdHep.instance.showTaskAd(
      adType: AdType.reward,
      closeAd: ()async{
        cashTaskWatchVideoNum.saveData(cashTaskWatchVideoNum.getData()+1);
        var rank = await CashHep.instance.updateTaskRank(cashType: cashType, cashMoney: cashMoney,);
        showToast("Your Current rank：$rank");
        _initList();
      },
    );
  }

  _initList(){
    CashHep.instance.getCashAllPersonAndMyRank(
      cashType: cashType,
      cashMoney: cashMoney,
      call: (rankNum,rankAllPerson,account){
        myRankNum=rankNum;
        rankAll=rankAllPerson;
        update(["rank"]);
        rankList.clear();
        var phoneNum = rankAllPerson~/2;
        var emailNum = rankAllPerson-phoneNum-1;
        List<String> phoneAndEmailList=_generateRandomPhoneNumbers(phoneNum)+_generateRandomEmails(emailNum);
        for (int i = 0; i < phoneAndEmailList.length; i++) {
          rankList.add(RankListBean(id: "$i", account: phoneAndEmailList[i], amount: "${CashHep.instance.getConfigCashMoneyList().random()}"));
        }
        // rankList.shuffle();
        rankList.insert(myRankNum-1, RankListBean(id: "$rankNum", account: account, amount: "$cashMoney"));
        update(["rank_list","btn"]);
      },
    );
  }

  List<String> _generateRandomPhoneNumbers(int count) {
    List<String> phoneNumbers = [];
    List<String> prefixes = ['13', '14', '15', '16', '17', '18', '19'];
    Random random = Random();
    for (int i = 0; i < count; i++) {
      String prefix = prefixes[random.nextInt(prefixes.length)];
      String number = '';
      for (int j = 0; j < 9; j++) {
        number += random.nextInt(10).toString();
      }
      phoneNumbers.add(prefix + number);
    }
    return phoneNumbers;
  }


  List<String> _generateRandomEmails(int count) {
    List<String> emails = [];
    List<String> domains = ['gmail.com', 'yahoo.com', 'hotmail.com', '163.com', 'qq.com'];
    Random random = Random();
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    for (int i = 0; i < count; i++) {
      String username = '';
      int length = random.nextInt(6) + 3; // 用户名长度为 3 - 8 位
      for (int j = 0; j < length; j++) {
        username += chars[random.nextInt(chars.length)];
      }
      String domain = domains[random.nextInt(domains.length)];
      emails.add('$username@$domain');
    }
    return emails;
  }

  String hideAccount(String account){
    if(account.length<=1){
      return "*";
    }
    if(account.length<=8){
      String star="";
      for (int i = 0; i < account.length-1; i++) {
        star="$star*";
      }
      return "${account.substring(0,1)}$star";
    }
    var s = account.substring(account.length-8,account.length);
    String star="";
    for (int i = 0; i < 4; i++) {
      star="$star*";
    }
    return "${account.substring(0,1)}$star$s";
  }
}