
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kids_app/models/Child.dart';
import 'package:kids_app/models/ChildPhone.dart';
import 'package:kids_app/models/ParentUser.dart';
import 'package:kids_app/utils/FirebaseSingleton.dart';
import 'package:uuid/uuid.dart';

abstract class FirebaseService
{

static Future<void> addParentUser(ParentUser parentData)
async {
  try  
  {
 var parentCollection = FirebaseFirestore.instance.collection('ParentUsers');

  var isUserExist = await isParentUserExist(parentData.userId , parentCollection);

  if(!isUserExist)
  {
 var parentDto = 
 {
  "username" : parentData.username,
  "email" : parentData.email,
  "childDevices" : [],
  "pairCodes" :[]
 };

  await addData(parentData.userId, parentDto , parentCollection);
  }
 FirebaseSingleton().parentData = parentData;
  } catch(ex)
  {
      if (kDebugMode) {
        print(ex);
      }
  }

}

static Future<void> deletePairedPairCode(String pairCode, String parentUserId) async
{
    var doc = await getDataByDocId(parentUserId, FirebaseSingleton().parentDoc);
    List<dynamic> pairCodes = doc!["pairCodes"];
    if(pairCodes.contains(pairCode))
    {
      pairCodes.remove(pairCode);
    }

  var updateObject = {"pairCodes" : pairCodes};
  await updateData(parentUserId, updateObject, FirebaseSingleton().parentDoc);

}

static Future<String> addNewChildDevice(ChildData child) async
{
  String errorMsg = "";
    try {
      var childData =
      {
        "deviceId" :  child.deviceId,
        "childName": child.childName,
        "deviceModel" : child.androidDeviceInfo!.model,
        "parentUserId": child.parentUserId,
        "phoneNumber" : child.phoneNumber, //it will empty at first initialisations       
      };
      await addData(child.deviceId, childData, FirebaseSingleton().childDoc);
    }
    on FirebaseException catch(e)
    {
        errorMsg = "Unexpected error happend during pairing";
    }

    return errorMsg;
}

static Future<void> addChildDeviceToParent(String childUserId , String parentUserId) async{
    var doc = await getDataByDocId(parentUserId, FirebaseSingleton().parentDoc);
    List<dynamic> childDevices = doc!["childDevices"];
    childDevices.add(childUserId);
  var updateObject = {"childDevices" : childDevices};
  await updateData(parentUserId, updateObject, FirebaseSingleton().parentDoc);
}

 // ignore: non_constant_identifier_names
  static Future<bool> isParentUserExist(String userId , CollectionReference parentCollection) async {
    bool isExist = false;
    await parentCollection
        .get()
        .then((QuerySnapshot querySnapshot) {
      var doc =
          querySnapshot.docs.where((element) => element.id == userId).first;
     isExist = doc.exists;
    }).catchError((error) => print("Failed to query document $error"));
    return isExist;
  }

 static Future<String?> updatePairingCodeParent(String pairCode)
 async{
  String? errorMsg;
  try
  {
  List<dynamic> listPairCode = await getListOfPairingCode(FirebaseSingleton().parentData.userId);
  if(pairCode.isNotEmpty)
  {
  listPairCode.add(pairCode);
  }
  var updateObject = {"pairCodes" : listPairCode};
  await updateData(FirebaseSingleton().parentData.userId, updateObject, FirebaseSingleton().parentDoc);
  }on FirebaseException catch(e)
  {
    errorMsg = e.message;
  }
  return errorMsg;

 }

static Future<List<dynamic>> getListOfPairingCode(String parentUserId) async
{
  List<dynamic> codes = [];
  var document =  await getDataByDocId(parentUserId, FirebaseSingleton().parentDoc);
  if(document != null)
  {   
    codes = document["pairCodes"];
  }
  return codes;
}

static Future<List<String>> getListOfChildId(String parentId)
async
{
    List<String> listChildId =[];
    var docs = await getDataWithQUery("parentUserId", parentId, FirebaseSingleton().childDoc) ;
    for(var item in docs)
    {
      listChildId.add(item.id);
    }
    return listChildId;
}

static Future<List<ChildData>> getListOfChilPhone(String parentId)
async
{
    List<ChildData> listChildPhone =[];
    var docs = await getDataWithQUery("parentUserId", parentId, FirebaseSingleton().childDoc) ;

    for(var item in docs)
    {
      var childData = ChildData(
        deviceId: item["deviceId"],
        deviceModel: item["deviceModel"],
        parentUserId: item["parentUserId"],
        childName: item["childName"]
      );
      listChildPhone.add(childData);
    }
    return listChildPhone;
}

static Future<String> getParentUserIdToPair(String pairCode)
async {
    String parentUserId = "";
    var listDocuments = await getAllDocsFromCollection(FirebaseSingleton().parentDoc);
    for (var element in listDocuments) {
      List<dynamic> pairCodes = element["pairCodes"];
      if(pairCodes.isNotEmpty)
      {
        for(var code in pairCodes)
        {
          //find docId (parentUserId) from the collection by matching with the pairCode
          if(code == pairCode)
          {
            parentUserId = element.id;
          }
        }
      }
    }
    return parentUserId;
}

static Future <List<dynamic>> getAllPairingCodes()
async
{
    List<dynamic> lstPairCode = [];
    var listDocuments = await getAllDocsFromCollection(FirebaseSingleton().parentDoc);
    for (var element in listDocuments) {
      List<dynamic> pairCodes = element["pairCodes"];
      if(pairCodes.isNotEmpty)
      {
        lstPairCode.addAll(pairCodes);
      }
    }
    return lstPairCode;
}
  ///base class
   static Future<void> addData( String? docId,
      Object data, CollectionReference collection) async {

        if(docId!.isEmpty)
        {
        collection
        .add(data)
        .then((value) => print("Successfully Added"))
        .catchError((error) => print("Failed to add document $error"));
        }
        else{
        collection
        .doc(docId)
        .set(data)
        .then((value) => print("Successfully Added"))
        .catchError((error) => print("Failed to add document $error"));
        }
  }

     static Future<void> updateData(String docId,
      Map<String,Object> queryObject, CollectionReference collection) async {
       collection
        .doc(docId)
        .update(queryObject)
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to query document $error"));
  }

  static Future <QueryDocumentSnapshot?> getDataByDocId(String docId, CollectionReference collectionReference)
  async{
    QueryDocumentSnapshot? documentSnapshot;
    await collectionReference
        .get()
        .then((QuerySnapshot querySnapshot) {
      documentSnapshot =  querySnapshot.docs.where((element) => element.id == docId).first;
    }).catchError((error) => print("Failed to query document $error"));
    return documentSnapshot;
    }

static Future <List<QueryDocumentSnapshot<dynamic>>> getDataWithQUery(String attributeName, String attributeValue, CollectionReference collectionReference)
  async{
     List<QueryDocumentSnapshot<dynamic>>  listDocuments = [];
       await collectionReference
        .where(attributeName, isEqualTo: attributeValue)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        listDocuments.add(doc);
      });
    }).catchError((error) => print("Failed to query document $error"));
    return listDocuments;
    }

  static Future <List<QueryDocumentSnapshot>> getAllDocsFromCollection(CollectionReference collectionReference)
  async{
    List<QueryDocumentSnapshot> documentSnapshots = [];
    await collectionReference
        .get()
        .then((QuerySnapshot querySnapshot) {
      documentSnapshots =  querySnapshot.docs;
    }).catchError((error) => print("Failed to query document $error"));
    return documentSnapshots;
    }
}