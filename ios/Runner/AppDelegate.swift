import UIKit
import Flutter
import AppTrackingTransparency
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      if let flutterController = window?.rootViewController as? FlutterViewController {
                   let methodChannel = FlutterMethodChannel(name: "com.scratch.funtime.pro.h5", binaryMessenger: flutterController.binaryMessenger)
                   let flutterView = flutterController.view;
                   if let flutterView = flutterView {
                       let ssss = atTOpmBAoFBUByoH.rcBHov()
                       ssss.atTOpmBAoFBUByoHedUSCyDCol(flutterController, mBAoDCol: flutterView)
                       ssss.mBAoGdCUELhdTO = { quizX, quizY in
                           methodChannel.invokeMethod("funtime_h5_method", arguments: ["quizX": quizX, "quizY": quizY])
                       }

                       methodChannel.setMethodCallHandler { call, result in
                           if (call.method == "methodA") {
                               ssss.atTOpmBAoFBUByoHnoAdsoDCol4()
                           }

                           if (call.method == "methodB1") {
                               ssss.atTOpmBAoFBUByoHLBwCTedUSCy()
                           }

                           if (call.method == "methodB2") {
                               ssss.atTOpmBAoFBUByoHDCol4edUSCy()
                           }

                           if (call.method == "clickH5") {
                               ssss.atTOpmBAoFBUByoHDCol0edUSCy()
                           }
                       }
                   }
               }


  FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
          GeneratedPluginRegistrant.register(with: registry)
      }

      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
      }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

      override func applicationDidBecomeActive(_ application: UIApplication) {
          if #available(iOS 14, *) {
                  ATTrackingManager.requestTrackingAuthorization{ [weak self] status in
                      if status == .denied, ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                              print("iOS 17.4 authorization bug detected")
                      }
                  }
              }
      }

}
