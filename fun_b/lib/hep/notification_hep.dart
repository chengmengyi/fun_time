import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fun_base/util/util.dart';

class NotificationId{
  static const int guding=100;
  static const int qiandao=101;
  static const int gua=102;
  static const int zhifu=103;
}

class NotificationHep{
  static final NotificationHep _instance = NotificationHep();
  static NotificationHep get instance=>_instance;

  final _plugins=FlutterLocalNotificationsPlugin();

  initNotification()async{
    var result = await _plugins.initialize(
        const InitializationSettings(
            iOS: DarwinInitializationSettings(
              requestAlertPermission: true,
              requestBadgePermission: true,
              requestSoundPermission: true,
            )
        ),
        onDidReceiveNotificationResponse: (res){
          var type = res.notificationResponseType;
          if(type==NotificationResponseType.selectedNotification||type==NotificationResponseType.selectedNotificationAction){

          }
        }
    );
    if(result==true){
      _plugins.periodicallyShowWithDuration(
        NotificationId.guding,
        "Scratch to Earn",
        ["💰Scratch. Win. Cash Out - Your Ticket to Instant Payouts","🎁Turn Virtual Cards Into Real Cash","🔥Uncover Instant Rewards with Scratch FunTime"].random(),
        const Duration(minutes: 30),
        const NotificationDetails(),
      );

      _plugins.periodicallyShowWithDuration(
        NotificationId.qiandao,
        "Cash in check daily",
        "Scratch your way to real cash prizes with Scratch FunTime!",
        const Duration(minutes: 60),
        const NotificationDetails(),
      );

      _plugins.periodicallyShowWithDuration(
        NotificationId.gua,
        "Go Scratch , Big Win!",
        ["💰Earn money on the go with Scratch FunTime's instant payouts.","🎁Reveal hidden rewards and get paid out instantly."].random(),
        const Duration(minutes: 60),
        const NotificationDetails(),
      );

      _plugins.periodicallyShowWithDuration(
        NotificationId.zhifu,
        "Pending withdraw amount",
        "\$500 has arrived in your account",
        const Duration(minutes: 30),
        const NotificationDetails(),
      );
    }
  }
}