

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoSingleton  {
  static final DeviceInfoSingleton _instance = DeviceInfoSingleton._internal();

late AndroidDeviceInfo deviceInfo;

  factory DeviceInfoSingleton() {
    return _instance;
  }

  DeviceInfoSingleton._internal() {
   print('initialize singleton class - FirebaseSingleton');
  }

Future<void> initializeDeviceInfo() async
{
 DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    deviceInfo = await deviceInfoPlugin.androidInfo;
}

}
