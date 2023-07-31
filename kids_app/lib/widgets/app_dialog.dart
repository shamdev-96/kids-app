import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:kids_app/constants/colors.dart';
import 'package:lottie/lottie.dart';

import '../models/AlertData.dart';

abstract class App_Dialog
{
  // ignore: non_constant_identifier_names
  static BuildDialog_Popout_Lottie(
      BuildContext context, AlertData alertData) {
    double screenWidth = MediaQuery.of(context).size.width;
    return showAnimatedDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            height: 180,
            width: 400,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 60 ,//200
                      width: 60 ,//200
                      child: Lottie.asset(alertData.assetFiles)),
                  Container(
                    width: 350, //300
                    height: 30, //100
                    margin: const EdgeInsets.only(
                        top: 10, bottom: 10), //10
                    child: Text(
                      alertData.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: "Andika" , fontSize: 20 , color: Color(AppColors.mainblue)),
                    ),
                  ),
                  Container(
                    width: 370, 
                    height: 60,
                    child: Text(
                      alertData.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: "Andika" , fontSize: 16 , color: Colors.black),
                      // style: StyleConstant.h3TextStyle_BestSchool_Black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
              GestureDetector(
                            onTap: ()  => {
                                 Navigator.of(context).pop()
                            },
                            child: Center(
                              child:     Container(
                              height: 40,
                              width: 150,
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: const BoxDecoration(
                                  color: Color(AppColors.mainblue),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:  [
                                  Text(alertData.actionText,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Andika'),
                                  ),
                                ],
                              )),
                         
                            )
                         
                          )
          ],
        );
      },
      animationType: DialogTransitionType.size,
      curve: Curves.fastOutSlowIn
    );
  }

static BuildDialog_Popout_Lottie_WithoutAction(
      BuildContext context, AlertData alertData) {
    return showAnimatedDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            height: 180,
            width: 400,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 80 ,//200
                      width: 80 ,//200
                      child: Lottie.asset(alertData.assetFiles, width: 80,height: 80)),
                  Container(
                    width: 350, //300
                    height: 30, //100
                    margin: const EdgeInsets.only(
                        top: 10, bottom: 10), //10
                    child: Text(
                      alertData.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: "Andika" , fontSize: 22 , color: Color(AppColors.mainblue)),
                    ),
                  )       
                ],
              ),
            ),
          ),       
        );
      },
      animationType: DialogTransitionType.size,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 2),
    );
  }

}