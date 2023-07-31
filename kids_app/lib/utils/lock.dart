
//Summary: Contains all functionality to lock the screen
import 'package:device_policy_manager/device_policy_manager.dart';

class Lock
{
  static Future<void> lockScreen()
  async {
      await DevicePolicyManager.lockNow();
  }

  static Future <void> requestAdminPermission()
  async
  {
      await DevicePolicyManager.requestPermession(
                        "Your app is requesting the Adminstration permission");
                  
  }

  static Future<bool> isAdminPermissionGranted()
  async {
      return await DevicePolicyManager.isPermissionGranted();
  }
}