import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kids_app/screens/phone_setup_first.dart';
import 'package:kids_app/services/AppBackgroundService.dart';
import 'package:kids_app/services/FirebaseService.dart';
import 'package:kids_app/utils/FirebaseSingleton.dart';
import 'dart:async';

import 'package:lottie/lottie.dart';
import 'package:workmanager/workmanager.dart';  

Future<void> callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async{
     var taskDto = 
 {
  "counter" : 1
 };
 await Firebase.initializeApp();
 await FirebaseService.addData("",taskDto, FirebaseSingleton().backgroundTaskDoc);
 return Future.value(true);
  });
}
 Future <void> main()  async{
    WidgetsFlutterBinding.ensureInitialized();
    await  Workmanager().initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  await Workmanager().registerPeriodicTask("task looping - sham", "simpleTaskLooping - sham");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterFire Samples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {  
  @override  
  SplashScreenState createState() => SplashScreenState();  
}  
class SplashScreenState extends State<MyHomePage> {  
  @override  
  void initState() {  
    super.initState();  
    Timer(Duration(seconds: 5),  
            ()=>Navigator.pushReplacement(context,  
            MaterialPageRoute(builder:  
                (context) => PhoneSetupFirst()  
            )  
         )  
    );  
  }  
  @override  
  Widget build(BuildContext context) {  
    return Container(  
        color: Colors.white,  
        child:Center(child: 
         Lottie.asset("lotties/animate_logo.json")
          // Column(children: [
          //   Lottie.asset("lotties/animate_logo.json"),
          //   Text("IWI Family Control" ,style: TextStyle(
          //     fontFamily: 'Andika')),
          // ]
          // )
    ));  
  }  
} 
