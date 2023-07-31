

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kids_app/models/ChildPhone.dart';
import 'package:kids_app/models/ParentUser.dart';

class FirebaseSingleton  {
  static final FirebaseSingleton _instance = FirebaseSingleton._internal();

late CollectionReference parentDoc;
late CollectionReference childDoc;
late CollectionReference backgroundTaskDoc;
late List<ChildPhone> childPhoneList;
late User? parentUser;

//this value will be populated after parent login
late ParentUser parentData ;

  factory FirebaseSingleton() {
    return _instance;
  }

  FirebaseSingleton._internal() {
   print('initialize singleton class - FirebaseSingleton');
   parentDoc = FirebaseFirestore.instance.collection('ParentUsers');
   childDoc = FirebaseFirestore.instance.collection('ChildDevice');
   backgroundTaskDoc = FirebaseFirestore.instance.collection('BackgroundTask');
   parentData =  ParentUser();
   parentUser = null;
   childPhoneList = [];
  }

}
