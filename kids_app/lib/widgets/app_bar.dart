import 'package:flutter/material.dart';

import '../constants/colors.dart';

class AppBarWithLogo extends StatelessWidget {
  const AppBarWithLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return     Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                 Image(image: AssetImage('images/app_logo.png') , height: 80, width: 80),
                Text("IWI",
                style: TextStyle(
                    color: Color(AppColors.mainblue),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Andika",
                    fontSize: 24)),
              ],);
  }
}