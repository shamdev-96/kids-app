import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kids_app/models/AlertData.dart';
import 'package:kids_app/screens/main_page_screen.dart';
import 'package:kids_app/screens/parent_register_screen.dart';
import 'package:kids_app/screens/user_info_screen.dart';
import 'package:lottie/lottie.dart';

import '../constants/colors.dart';
import '../models/ParentUser.dart';
import '../services/FirebaseService.dart';
import '../utils/FirebaseSingleton.dart';
import '../utils/firebase_authentication.dart';
import '../widgets/app_dialog.dart';

class ParentLoginScreen extends StatefulWidget {
  @override
  _ParentLoginScreenState createState() => _ParentLoginScreenState();
}

class _ParentLoginScreenState extends State<ParentLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSigningIn = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,    
        body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Stack(fit: StackFit.loose, children: [
             Center(
                      child: Lottie.asset("lotties/welcome.json",
                          height: 150, width: 150, fit: BoxFit.fitHeight)),
             

                  Container(
                    margin: EdgeInsets.only(top: 120, bottom: 30),
                    child: Center(
                        child: Column(
                      children: [
                        Text(
                          "Welcome Back!",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Andika",
                              fontSize: 28),
                        )
                      ],
                    )),
                  ),
                ]),
           
                ),
                
                Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1)),
                              filled: true,
                              fillColor: Color(AppColors.greyTextField),
                              hintText: 'Username/Email',
                              hintStyle: TextStyle(
                                  color: Color(AppColors.greyhintText)),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter your email';
                              }
                              else{
                                email = value;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            // keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscureText,
                            obscuringCharacter: "*",
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1)),
                              filled: true,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color(AppColors.greyhintText)),
                              ),
                              fillColor: Color(AppColors.greyTextField),
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                  color: Color(AppColors.greyhintText)),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter your password';
                              }
                              else{
                                password = value;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: () async => {
                              await handleUserLogin(context, _emailController.text, _passwordController.text)
                            },
                            child:  Container(
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
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'Andika'),
                                  ),
                                ],
                              )),
                         
                          ),
                         
                          const SizedBox(height: 20),
                          const Center(
                            child: Text(
                              'Or',
                              style: TextStyle(
                                  color: Color(AppColors.greyhintText),
                                  fontSize: 20,
                                  fontFamily: 'Andika'),
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _isSigningIn = true;
                                });

                                await handleGoogleSign(context);
                              },
                              child: Container(
                                  height: 60,
                                  width: 370,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      //  border: Border(left: BorderSide(color: Colors.black)),
                                      border: Border.all(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      //  SizedBox(width: 20),
                                      Image(
                                          image:
                                              AssetImage('images/google.png'),
                                          height: 50,
                                          width: 50),
                                      Text(
                                        'Continue with Google',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Andika'),
                                      ),
                                    ],
                                  ))),
                          const SizedBox(height: 20),
                          const Center(
                            child: Text(
                              'Dont have an account yet?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Andika'),
                            ),
                          ),
                          const SizedBox(height: 5),
                           Center(
                            child: GestureDetector(
                              onTap:() {
                                Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ParentRegisterScreen(),
      ),
    );
                              },
                              child: const Text(
                              'Register',
                              style: TextStyle(
                                  color: Color(AppColors.mainblue),
                                  fontSize: 20,
                                  fontFamily: 'Andika'),
                            ),),
                          ),
                      
                        ]))
              ],
            )));
  }
}

Future<void> handleUserLogin(BuildContext context , String email , String password) async {

  if(email == "" || password == "")
  {
    var alertData =  AlertData(title: "Login Failed", message: "Email/Password cannot be empty", 
                actionText: "OK", assetFiles: "lotties/error.json");
    return App_Dialog.BuildDialog_Popout_Lottie(context, alertData);
  }

  var tupleResult = await FirebaseAuthentication.signInWithEmailAndPassword(context , email, password);
   User? user = tupleResult.item1;
  if (user != null) {
        var parentUser =  ParentUser(userId: user.uid , username: user.displayName! , email: user.email);
    FirebaseSingleton().parentData = parentUser;
      Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>  MainPageScreen(
          currentPage: 1 , user: FirebaseSingleton().parentData,
        ),
      ),
    );
  }
  else{
    if(tupleResult.item2.isNotEmpty)
    {
          var alertData =  AlertData(title: "Signin Failed", message: tupleResult.item2, 
                actionText: "OK", assetFiles: "lotties/error.json");
     return App_Dialog.BuildDialog_Popout_Lottie(context, alertData);
    }
  }
}

Future<void> handleGoogleSign(BuildContext context) async {
  var tupleResult = await FirebaseAuthentication.signInWithGoogle(context: context);
  User? user = tupleResult.item1;
  if (user != null) {
        var parentUser =  ParentUser(userId: user.uid , username: user.displayName! , email: user.email);
        FirebaseSingleton().parentData =  parentUser;
    FirebaseService.addParentUser(parentUser);
       Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>  MainPageScreen(
          currentPage: 1 , user: FirebaseSingleton().parentData,
        ),
      ),
    );
  }
  else{
    if(tupleResult.item2.isNotEmpty)
    {
          var alertData =  AlertData(title: "Google Signin Failed", message: tupleResult.item2, 
                actionText: "OK", assetFiles: "lotties/error.json");
     return App_Dialog.BuildDialog_Popout_Lottie(context, alertData);
    }
  }
}
