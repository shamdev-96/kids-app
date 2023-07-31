// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:kids_app/utils/firebase_authentication.dart';
// import 'package:kids_app/widgets/google_sign_in_button.dart';

// class SignInScreen extends StatefulWidget {
//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlue,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             left: 16.0,
//             right: 16.0,
//             bottom: 20.0,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Row(),
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Flexible(
//                     //   flex: 1,
//                     //   child: Image.asset(
//                     //     'assets/firebase_logo.png',
//                     //     height: 160,
//                     //   ),
//                     // ),
//                     SizedBox(height: 20),
//                     Text(
//                       'FlutterFire',
//                       style: TextStyle(
//                         color: Colors.yellow,
//                         fontSize: 40,
//                       ),
//                     ),
//                    const Text(
//                       'Authentication',
//                       style: TextStyle(
//                         color: Colors.orange,
//                         fontSize: 40,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               FutureBuilder(
//                 future: FirebaseAuthentication.initializeFirebase(context: context),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return const Text('Error initializing Firebase');
//                   } else if (snapshot.connectionState == ConnectionState.done) {
//                     return GoogleSignInButton();
//                   }
//                   return const CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       Colors.orange,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

