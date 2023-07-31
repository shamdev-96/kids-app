// ignore: file_names
import 'package:device_info_plus/device_info_plus.dart';

class ChildData {
  ChildData(
      { this.deviceId = "",
      this.childName = "" ,
      this.phoneNumber = "",
      this.parentUserId = "",
      this.deviceModel = "",
      this.childId = "",
      this.androidDeviceInfo, });
  
  ///this also refers to docId in Firebase
  String deviceId ;
  String childName;
  String phoneNumber;
  String parentUserId;
  String deviceModel;
  String childId;
  AndroidDeviceInfo? androidDeviceInfo;
}
