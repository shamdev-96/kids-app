import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kids_app/screens/main_page_screen.dart';
import 'package:kids_app/services/FirebaseService.dart';
import 'package:kids_app/utils/FirebaseSingleton.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../constants/colors.dart';
import '../models/AlertData.dart';
import '../utils/helpers.dart';
import '../widgets/app_dialog.dart';

class ParentPairInfo extends StatefulWidget {
  const ParentPairInfo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ParentPairInfoState createState() => _ParentPairInfoState();
}

class _ParentPairInfoState extends State<ParentPairInfo> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  late String generatedPin;
  List<String> listChildId = [];
  final  _fieldRef = FirebaseSingleton().parentDoc.doc(FirebaseSingleton().parentData.userId);
  final formKey = GlobalKey<FormState>();
  // final TextEditingController _codeController1 = TextEditingController();
  // final TextEditingController _codeController2 = TextEditingController();
  // final TextEditingController _codeController3 = TextEditingController();
  // final TextEditingController _codeController4 = TextEditingController();
  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    initializeData();
    super.initState();

    // Listen for changes in the Firestore value and update the TextField
    _fieldRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        List<dynamic> childDevices = snapshot['childDevices'];
        if(childDevices.length > listChildId.length)
        {
          //this means new device is added
          navigateAfterSuccessful();
        }
 
      }
    });
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 80, bottom: 60),
                  child: const Center(
                      child: Text(
                    "Pair with pairing code",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Andika",
                        fontWeight: FontWeight.bold,
                        fontSize: 28),
                  )),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "On your child's phone :",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Andika",
                          fontSize: 20),
                    ),
                    Text(
                      "1. Open IWI (Family Control) app",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Andika",
                          fontSize: 20),
                    ),
                    Text(
                      "2. Select (Child) phone",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Andika",
                          fontSize: 20),
                    ),
                    Text(
                      "3. Enter the pairing code below",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Andika",
                          fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height: 70,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(AppColors.mainblue),
                        ),
                        child: Center(
                            child: Text(
                          generatedPin[0],
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Andika",
                              fontSize: 25),
                        ))),
                    Container(
                        height: 70,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(AppColors.mainblue),
                        ),
                        child: Center(
                            child: Text(
                          generatedPin[1],
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Andika",
                              fontSize: 25),
                        ))),
                    Container(
                        height: 70,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(AppColors.mainblue),
                        ),
                        child: Center(
                            child: Text(
                          generatedPin[2],
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Andika",
                              fontSize: 25),
                        ))),
                    Container(
                        height: 70,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(AppColors.mainblue),
                        ),
                        child: Center(
                            child: Text(
                          generatedPin[3],
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Andika",
                              fontSize: 25),
                        ))),
                  ],
                ),
    
                GestureDetector(
                  onTap: () async => {await cancelPairing(context)},
                  child: Container(
                      margin: EdgeInsets.only(top: 230),
                      height: 60,
                      width: 370,
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'Cancel',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Andika'),
                          ),
                        ],
                      )),
                ),
              ],
            )));
  }

  initializeData() async {
    generatedPin = Helpers.getRandomPin().toString();
    String? errorMsg =
        await FirebaseService.updatePairingCodeParent(generatedPin);
      listChildId = await FirebaseService.getListOfChildId(FirebaseSingleton().parentData.userId);
    if (kDebugMode) {
      print(errorMsg);
    }

  }

navigateAfterSuccessful()
{
    var alertData =  AlertData(title: "Pairing", message: "New child device is Successfully paired", 
                actionText: "OK", assetFiles: "lotties/success.json");
     App_Dialog.BuildDialog_Popout_Lottie(context, alertData);
     
      Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainPageScreen(
            currentPage: 1, user: FirebaseSingleton().parentData),
      ),
    );
}
  cancelPairing(BuildContext context) async {
    await FirebaseService.updatePairingCodeParent("");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainPageScreen(
            currentPage: 1, user: FirebaseSingleton().parentData),
      ),
    );
  }
}
