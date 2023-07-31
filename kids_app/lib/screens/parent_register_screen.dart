import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kids_app/models/AlertData.dart';
import 'package:kids_app/screens/parent_login_screen.dart';
import 'package:kids_app/screens/user_info_screen.dart';
import 'package:kids_app/widgets/app_dialog.dart';
import 'package:lottie/lottie.dart';

import '../constants/colors.dart';
import '../utils/firebase_authentication.dart';

class ParentRegisterScreen extends StatefulWidget {
  @override
  _ParentRegisterScreenState createState() => _ParentRegisterScreenState();
}

class _ParentRegisterScreenState extends State<ParentRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSigningIn = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _usernameController = TextEditingController();
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
                  margin: EdgeInsets.only(top: 20),
                  child: Stack(fit: StackFit.loose, children: [
                  Center(
                      child: Lottie.asset("lotties/register.json",
                          height: 130, width: 130, fit: BoxFit.fitHeight)),
                  Container(
                    margin: EdgeInsets.only(top: 140, bottom: 30),
                    child: Center(
                        child: Column(
                      children: [
                        Text(
                          "Create an account",
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
                          //Username
                          TextFormField(
                            controller: _usernameController,
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
                              hintText: 'Username',
                              hintStyle: TextStyle(
                                  color: Color(AppColors.greyhintText)),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          //Email
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
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                  color: Color(AppColors.greyhintText)),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter your email';
                              }
                              else
                              {
                                email = value;
                              }
                              return null;
                            },
                          ),                   
                          const SizedBox(height: 20),
                         //Password
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
                                    color: const Color(AppColors.greyhintText)),
                              ),
                              fillColor: const Color(AppColors.greyTextField),
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                  color: Color(AppColors.greyhintText)),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter your password';
                              }
                              else
                              {
                               password = value;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          //Re-enter Password
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
                              hintText: 'Re-enter password',
                              hintStyle: TextStyle(
                                  color: Color(AppColors.greyhintText)),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'You have to re-enter your passsword to verify';
                              }
                              else
                              {
                                if(value != password)
                                {
                                    return 'Your password isnt match';
                                }
                              }
                              return null;
                            },
                          ),                       
                          const SizedBox(height: 20),
                          //Register button
                          GestureDetector(
                            onTap: () async => {
                              await registerUser(context, _emailController.text, _passwordController.text , _usernameController.text)
                            },
                            child: Container(
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
                                    'Register',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'Andika'),
                                  ),
                                ],
                              )),
                         
                          ),                         
                          const SizedBox(height: 15),
                          const Center(
                            child: Text(
                              'Or',
                              style: TextStyle(
                                  color: Color(AppColors.greyhintText),
                                  fontSize: 20,
                                  fontFamily: 'Andika'),
                            ),
                          ),
                          const SizedBox(height: 15),
                           const Center(
                            child: Text(
                              'Already have an account?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Andika'),
                            ),
                          ),
                          const SizedBox(height: 5),
                           Center(
                            child: GestureDetector(
                              onTap: () {                           
                               Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ParentLoginScreen(),
      ),
    );
  
                              },
                              child:   const Text(
                              'Login',
                              style: TextStyle(
                                  color: Color(AppColors.mainblue),
                                  fontSize: 20,
                                  fontFamily: 'Andika'),
                            ),
                       
                            ),
                         
                          ),
                        ]))
              ],
            )));
  }
}

Future <void> registerUser(BuildContext context, String email, String password , String username)
async{
  var errorMsg = await FirebaseAuthentication.registerWithEmailPassword(email,password,username);
if(errorMsg.isNotEmpty)
{
  var alertData = new AlertData(title: "Register Failed", message: errorMsg, actionText: "Okay", assetFiles: "lotties/error.json");
  App_Dialog.BuildDialog_Popout_Lottie(context, alertData);
}
else
{
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ParentLoginScreen(),
      ),
    );
}
  
  
}

