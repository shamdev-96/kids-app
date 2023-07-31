
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:kids_app/services/FirebaseService.dart';
import 'package:kids_app/utils/FirebaseSingleton.dart';

abstract class AppBackgroundService  {
  // static final AppBackgroundService _instance = AppBackgroundService._internal();

 int counter = 1;
// late FlutterBackgroundService _backgroundService;
  // factory AppBackgroundService() {
  //   return _instance;
  // }

  // AppBackgroundService._internal() {
  //  print('initialize singleton class - AppBackgroundService');
  //  _backgroundService =  FlutterBackgroundService();
  // }

static Future <void> initializeBackgroundService ()
 async {
FlutterBackgroundService backgroundService = FlutterBackgroundService();
  await backgroundService.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
    ), iosConfiguration: IosConfiguration());

    backgroundService.startService();

  }

static Future <void> onStart(ServiceInstance service) async {
  print("App in run in background");
  var taskDto = 
 {
  "counter" : 1
 };
 await FirebaseService.addData(null,taskDto, FirebaseSingleton().backgroundTaskDoc);
}
}
