import 'package:flutter/material.dart';
import 'package:kids_app/enums/UserType.dart';
import 'package:kids_app/screens/parent_login_screen.dart';
import 'package:kids_app/screens/sign_in_screen.dart';
import 'package:kids_app/services/AppBackgroundService.dart';
import 'package:kids_app/utils/DeviceInfoSingleton.dart';

import '../constants/colors.dart';
import '../utils/firebase_authentication.dart';


class PhoneSetupFirst extends StatelessWidget {

 @override
 Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const  Text('Whose Phone is this?' , style: TextStyle(fontFamily: 
           'Andika',fontSize: 30, color: Colors.black , fontWeight: FontWeight.bold),),
           GestureDetector(
            onTap: () async => {
              await checkIfUserLoggedIn(context, UserType.parent )
            },
            child: Container(            
              height: 280,
              width: 300,
              margin: const EdgeInsets.only(top: 40),
              decoration: const BoxDecoration(
                 color:  Color(AppColors.mainblue), 
                 borderRadius: BorderRadius.all(Radius.circular(15))
              ),                     
              child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,         
                  children: const  [
                   SizedBox(height: 10),
                      Text('Parent Phone' , style: TextStyle(fontFamily: 
           'Andika',fontSize: 28, color: Colors.white )),
                   SizedBox(height: 25),
                  Image(image: AssetImage('images/parent.png') , height: 200, width: 200),           
                  ],
                ),
              ),
            ),
              
            GestureDetector(
              onTap: () async => {
        await checkIfUserLoggedIn(context, UserType.children )
              },
              child:   Container( 
                      height: 280,
              width: 300,
              margin: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                 color:  Color(AppColors.mainpurple), 
                 borderRadius: BorderRadius.all(Radius.circular(15))
              ),                     
              child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
                  children:  [
                        SizedBox(height: 10),
                     Text('Child Phone' , style: TextStyle(fontFamily: 
           'Andika',fontSize: 28, color: Colors.white )),
                 SizedBox(height: 25),
                 Stack(
                  children: [
                    Image(image: AssetImage('images/children.png') , height: 200, width: 200), 
                  ],
                 )
        
                  ],
                ),
              ),
         
            )
            
            ],
        ),
      ),
    );
  }
}

Future<void> checkIfUserLoggedIn(BuildContext context , UserType userType)
async {
await FirebaseAuthentication.initializeFirebase(context: context , userType: userType );
await DeviceInfoSingleton().initializeDeviceInfo();

}
  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ParentLoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.bounceIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
