

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kids_app/enums/UserType.dart';
import 'package:kids_app/models/ParentUser.dart';
import 'package:kids_app/screens/child_name_setup.dart';
import 'package:kids_app/screens/child_setup_first.dart';
import 'package:kids_app/screens/main_page_screen.dart';
import 'package:kids_app/screens/parent_login_screen.dart';
import 'package:kids_app/services/FirebaseService.dart';
import 'package:kids_app/utils/FirebaseSingleton.dart';
import 'package:tuple/tuple.dart';

class FirebaseAuthentication
{
static Future<FirebaseApp> initializeFirebase({
  required BuildContext context, required UserType userType
})async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseSingleton().parentUser = user;

switch(userType)
{
  case UserType.parent:
  if (user != null) {
    FirebaseSingleton().parentData =  ParentUser(
      userId: user.uid,
      email: user.email,
      username: user.displayName!
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainPageScreen(
          user: FirebaseSingleton().parentData,
          currentPage: 1,
        ),
      ),
    );
  }
  else{
   Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ParentLoginScreen(),
      ),
    );

  }
  break;
  case UserType.children:
   Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ChildNameSetup(),
      ),
    );

  //   if (user != null) {
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(
  //       builder: (context) => UserInfoScreen(
  //         user: user,
  //       ),
  //     ),
  //   );
  // }
  // else{
  //  Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(
  //       builder: (context) => ChildSetupFirst(),
  //     ),
  //   );

  // }
    break;
}

    return firebaseApp;
  }

static Future<Tuple2<User? , String>> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    String errorMsg = "";
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
         var parentUser =  ParentUser(userId: userCredential.user!.uid , username: user!.displayName! , email: userCredential.user!.email);
      FirebaseService.addParentUser(parentUser);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          errorMsg =  "Account already exist with different credentials";
        }
        else if (e.code == 'invalid-credential') {
          errorMsg = "Invalid credentials";
        }
      } catch (e) {
        // handle the error here
      }
    }

    return Tuple2<User? , String>(user, errorMsg);
  }

static Future<Tuple2<User? , String>>  signInWithEmailAndPassword(BuildContext context, String email, String password) async {
     User? user;
    String errorMsg = "";

  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password);

        user =  userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      errorMsg = "No user found for that email.";
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
      errorMsg = "Wrong password provided for that user.";

    }
  }

  return  Tuple2<User? , String>(user, errorMsg);
  
}
static Future<String> registerWithEmailPassword(String email, String password , String username) async {
  var errorMsg = "";
  try {
    
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    var parentUser =  ParentUser(userId: userCredential.user!.uid , username: username , email: userCredential.user!.email);
    FirebaseService.addParentUser(parentUser);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      errorMsg = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      errorMsg = 'The account already exists for that email';
    }
  } catch (e) {
    errorMsg = e.toString();
  }
  return errorMsg;

}

static Future<String> signOut() async
{
  String errorMsg = "";
  try
  {
    await FirebaseAuth.instance.signOut();
  } on FirebaseAuthException catch (e)
  {
    errorMsg =  e.message!;
  }
  return errorMsg;
}

 static SnackBar customSnackBar({required String content}) {
  return SnackBar(
    backgroundColor: Colors.black,
    content: Text(
      content,
      style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
    ),
  );
}
}