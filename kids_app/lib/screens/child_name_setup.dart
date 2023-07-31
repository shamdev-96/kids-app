import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kids_app/models/AlertData.dart';
import 'package:kids_app/models/Child.dart';
import 'package:kids_app/screens/child_setup_first.dart';
import 'package:kids_app/screens/phone_setup_first.dart';
import 'package:kids_app/services/FirebaseService.dart';
import 'package:kids_app/utils/DeviceInfoSingleton.dart';
import 'package:kids_app/widgets/app_dialog.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:uuid/uuid.dart';
import '../constants/colors.dart';

class ChildNameSetup extends StatefulWidget {
  const ChildNameSetup({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChildNameSetupState createState() => _ChildNameSetupState();
}

class _ChildNameSetupState extends State<ChildNameSetup> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  String currentText = "";
  final TextEditingController _nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  // final TextEditingController _codeController1 = TextEditingController();
  // final TextEditingController _codeController2 = TextEditingController();
  // final TextEditingController _codeController3 = TextEditingController();
  // final TextEditingController _codeController4 = TextEditingController();
  @override
  void initState() {
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
                    child: const Text(
                      "Pairing the child phone..",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Andika",
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    )),
                Center(
                    child: Lottie.asset("lotties/pairing.json",
                        height: 180, width: 180, fit: BoxFit.fill)),
                Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    child: const Center(
                        child: Text(
                      "Enter Kid Name:",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Andika",
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ))),
                Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Center(
                      child: TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Andika",
                            fontSize: 23),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 3)),
                          filled: false,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(AppColors.mainblue), width: 2)),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter your email';
                          }

                          return null;
                        },
                      ),
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            ChildSetupFirst(childName: _nameController.text),
                      ),
                    );
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 100, bottom: 20),
                      height: 60,
                      width: 370,
                      decoration: const BoxDecoration(
                          color: Color(AppColors.mainblue),
                          borderRadius: BorderRadius.all(Radius.circular(25))),
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
                    onTap: () {
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
                    ),
                  ),
                ),
              ],
            )));
  }

  Future<void> verifyPairingCode(BuildContext context, String pairCode) async {
    //we find match parentUserId by the pairing code. If found, then we add into database
    String parentUserId = await FirebaseService.getParentUserIdToPair(pairCode);
    if (parentUserId.isNotEmpty) {
      //update parentdata to link the child device.
      var child = ChildData(
          androidDeviceInfo: DeviceInfoSingleton().deviceInfo,
          childName: "Sham",
          deviceId: const Uuid().v1(),
          parentUserId: parentUserId);
      String errorMsg = await FirebaseService.addNewChildDevice(child);
      if (errorMsg.isEmpty) {
        //this is to add array of connected childDevices by referencing to deviceId (docId of ChildDevices)
        await FirebaseService.addChildDeviceToParent(
            child.deviceId, parentUserId);

        //we have to delete the pairCode in Parent node, so the app wont retrieve anymore to pair
        await FirebaseService.deletePairedPairCode(pairCode, parentUserId);
        var alertData = AlertData(
            title: "BuildDialog_Popout_Lottie_WithoutAction",
            message: "Successfully Paired!",
            actionText: "",
            assetFiles: "lotties/success.json");
        return App_Dialog.BuildDialog_Popout_Lottie_WithoutAction(
            context, alertData);
      } else {
        var alertData = AlertData(
            title: "Device Pairing Failed",
            message: errorMsg,
            actionText: "OK",
            assetFiles: "lotties/error.json");
        return App_Dialog.BuildDialog_Popout_Lottie(context, alertData);
      }
    } else {
      var alertData = AlertData(
          title: "Device Pairing Failed",
          message: "Pairing code is not Valid",
          actionText: "OK",
          assetFiles: "lotties/error.json");
      return App_Dialog.BuildDialog_Popout_Lottie(context, alertData);
    }
  }
}
