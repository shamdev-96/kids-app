// ignore: file_names
import 'AppLocalUsageService..dart';


abstract class AppUsageService  {


  // List<AppUsageInfo> get info => _info;

  @override
 static Future<List<AppUsageInfo>> getAppUsageService() async {
     List<AppUsageInfo> _info = <AppUsageInfo>[];
    try {
      var endDate = DateTime.now();
      var startDate = endDate.subtract(Duration(hours: 1));
      var infoList = await AppUsage.getAppUsage(startDate, endDate);
      _info = infoList;
    } on AppUsageException catch (exception) {
      print(exception);
    }
    return _info;
  }
}
