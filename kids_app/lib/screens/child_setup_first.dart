
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kids_app/models/AlertData.dart';
import 'package:kids_app/models/Child.dart';
import 'package:kids_app/screens/phone_setup_first.dart';
import 'package:kids_app/services/FirebaseService.dart';
import 'package:kids_app/utils/DeviceInfoSingleton.dart';
import 'package:kids_app/widgets/app_dialog.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:uuid/uuid.dart';
import '../constants/colors.dart';

class ChildSetupFirst extends StatefulWidget {
  const ChildSetupFirst(
      {Key? key, required String childName})
      : _childName = childName,
        super(key: key);
  
final String _childName;

  @override
  // ignore: library_private_types_in_public_api
  _ChildSetupFirstState createState() => _ChildSetupFirstState();
}

class _ChildSetupFirstState extends State<ChildSetupFirst> {
   TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  String currentText = "";
   String _childName = "";
  final formKey = GlobalKey<FormState>();
  // final TextEditingController _codeController1 = TextEditingController();
  // final TextEditingController _codeController2 = TextEditingController();
  // final TextEditingController _codeController3 = TextEditingController();
  // final TextEditingController _codeController4 = TextEditingController();
 @override
  void initState() {
    _childName = widget._childName;
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
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
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
                  margin: EdgeInsets.only(top: 60),
                  child:  
                        const Text(
                          "Pairing the child phone..",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Andika",
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        )                   
                  ),
                  Center(
                      child: Lottie.asset("lotties/pairing.json",
                          height: 180, width: 180, fit: BoxFit.fill)),
                              
              Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  child:  const Center(
                    child:         Text(
                          "Enter pairing code:",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Andika",
                              fontSize: 25),
                        )                   
                  )
                
                  ),  
                Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 4,
                      obscureText: true,
                      obscuringCharacter: '*',
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(20),
                        fieldHeight: 60,
                        fieldWidth: 60,
                        selectedFillColor: const Color(AppColors.mainpurple),
                        activeFillColor: const Color(AppColors.mainblue),
                        inactiveFillColor: const Color(AppColors.secondarypurple)
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        debugPrint("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                      currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
             
       GestureDetector(
                
                            onTap: () async =>  { 
                              await verifyPairingCode(context,currentText)
                             },
                            child:  Container(
                              margin: EdgeInsets.only(top:100 , bottom: 20),
                              height: 60,
                              width: 370,
                              decoration: const BoxDecoration(
                                  color: Color(AppColors.mainblue),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Next',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'Andika'),
                                  ),
                                ],
                              )),
                         
                          ),                                 
          Center(
                            child: GestureDetector(
                              onTap:() {
                                Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PhoneSetupFirst(),
      ),
    );
                              },
                              child: const Text(
                              'Go back',
                              style: TextStyle(
                                  color: Color(AppColors.mainblue),
                                  fontSize: 20,
                                  fontFamily: 'Andika'),
                            ),),
                          ),
                      
              ],
            )));
  }

  Future<void> verifyPairingCode(BuildContext context, String pairCode) async
  {
    //we find match parentUserId by the pairing code. If found, then we add into database
      String parentUserId = await FirebaseService.getParentUserIdToPair(pairCode);
      if(parentUserId.isNotEmpty)
      {
        //update parentdata to link the child device. 
        var child =  ChildData(androidDeviceInfo: DeviceInfoSingleton().deviceInfo ,
        childName: _childName , deviceId:  const Uuid().v1(), parentUserId: parentUserId  );
        String errorMsg = await FirebaseService.addNewChildDevice(child);
        if(errorMsg.isEmpty)
        {
          //this is to add array of connected childDevices by referencing to deviceId (docId of ChildDevices)
            await FirebaseService.addChildDeviceToParent(child.deviceId, parentUserId);

            //we have to delete the pairCode in Parent node, so the app wont retrieve anymore to pair
            await FirebaseService.deletePairedPairCode(pairCode, parentUserId);
          var alertData = AlertData(title: "BuildDialog_Popout_Lottie_WithoutAction", message: "Successfully Paired!", actionText: "", assetFiles: "lotties/success.json");
          return App_Dialog.BuildDialog_Popout_Lottie_WithoutAction(context, alertData);
        }
        else
        {
           var alertData = AlertData(title: "Device Pairing Failed", message:errorMsg, actionText: "OK", assetFiles: "lotties/error.json");
          return App_Dialog.BuildDialog_Popout_Lottie(context, alertData);
        }

      }
      else
      {
          var alertData = AlertData(title: "Device Pairing Failed", message: "Pairing code is not Valid", actionText: "OK", assetFiles: "lotties/error.json");
          return App_Dialog.BuildDialog_Popout_Lottie(context, alertData);
      }
  }
}