import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kids_app/constants/colors.dart';
import 'package:kids_app/models/ParentUser.dart';
import 'package:kids_app/screens/parent_login_screen.dart';
import 'package:kids_app/screens/parent_pair_info.dart';
import 'package:kids_app/services/FirebaseService.dart';
import 'package:kids_app/utils/FirebaseSingleton.dart';
import 'package:kids_app/widgets/app_bar.dart';

import '../models/Child.dart';
import '../models/ScreenTime.dart';
import '../utils/firebase_authentication.dart';
import 'child_phone_main.dart';

class MainPageScreen extends StatefulWidget {
  const MainPageScreen(
      {Key? key, required int currentPage, required ParentUser user})
      : _currentPage = currentPage,
        _user = user,
        super(key: key);

  final int _currentPage;
  final ParentUser _user;

  @override
  _MainPageScreenState createState() => _MainPageScreenState();
}

List<ChildData> _childPhones = [];

class _MainPageScreenState extends State<MainPageScreen>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex = 0;
  late ParentUser _user;
  late AnimationController _animationController;
  // late List<ChildData> _childPhones = [];
  late Animation<double> _animation;
  final List<Widget> _pages = [
   const ListViewPage(),
   const ProfilePage(),
  ];

  @override
  void initState() {
    _selectedIndex = widget._currentPage - 1;
    _user = widget._user;
    // initializeData();
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

//to iniatialize necessary data of child phone
  initializeData() async {
    // var childPhone =  ChildData( deviceId: "1" , childName: "Sham" ,
    //  phoneNumber: "0112623032" , parentUserId: FirebaseSingleton().parentData.userId , deviceModel: "Samsung S10", androidDeviceInfo: null);

    //  var childPhone2 =  ChildData( deviceId: "2" , childName: "Test1234" ,
    //  phoneNumber: "0112623032" , parentUserId: FirebaseSingleton().parentData.userId , deviceModel: "Iphone 11", androidDeviceInfo: null);
    // _childPhones.add(childPhone);
    // _childPhones.add(childPhone2);
    _childPhones = await FirebaseService.getListOfChilPhone(
        FirebaseSingleton().parentData.userId);
  }

  void _showPopup() {
    _animationController.forward();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Popup Content',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        backgroundColor: const Color(AppColors.mainblue),
        selectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.mobile_friendly_rounded),
            label: 'Kid Phone List',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'My Profile',
              backgroundColor: Colors.black),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ListViewPage extends StatelessWidget {
  const ListViewPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildAppBarLogo(),
          const Text("Paired Devices:",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Andika",
                  fontSize: 24)),
          Expanded(
            child: FutureBuilder<List<ChildData>>(
              future: FirebaseService.getListOfChilPhone(
                  FirebaseSingleton().parentData.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error fetching data',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Andika",
                              fontSize: 24)));
                } else {
                  List<ChildData>? items = snapshot.data;
                  if (items != null && items.isNotEmpty) {
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              navigateToChildPage(context, items[index]);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(AppColors.mainblue),
                              ),
                              height: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 30),
                                  const Icon(Icons.phone_android_rounded,
                                      size: 40),
                                  SizedBox(width: 70),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 15),
                                        Text(items[index].childName,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Andika",
                                                fontSize: 20),
                                            textAlign: TextAlign.justify),
                                        Text(items[index].deviceModel,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Andika",
                                                fontSize: 20),
                                            textAlign: TextAlign.start),
                                        SizedBox(height: 15)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ));
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("No Child Device is Added",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Andika",
                              fontSize: 24),
                          textAlign: TextAlign.justify),
                    );
                  }
                }
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ParentPairInfo()),
              );
            },
            child: Container(
                height: 60,
                width: 370,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Color(AppColors.mainblue), width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      '+  Add New Kid Phone',
                      style: TextStyle(
                          color: Color(AppColors.mainblue),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Andika'),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}

navigateToChildPage(BuildContext context, ChildData childData) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => ChildPhoneMain(
            currentPage: 1,
            childDetails: childData,
          )));
}

buildAppBarLogo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      SizedBox(height: 20),
      AppBarWithLogo(),
      SizedBox(height: 40),
    ],
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          buildAppBarLogo(),
          GestureDetector(
              onTap: () async => {await handleSignOut(context)},
              child: Container(
                  margin: EdgeInsets.only(top: 210),
                  height: 60,
                  width: 370,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color(AppColors.mainblue), width: 4),
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'Signout',
                        style: TextStyle(
                            color: Color(AppColors.mainblue),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Andika'),
                      ),
                    ],
                  )))
        ],
      ),
    );
  }
}

Future<void> handleSignOut(BuildContext context) async {
  String errorMsg = await FirebaseAuthentication.signOut();

  if (errorMsg.isEmpty) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ParentLoginScreen()));
  } else {
    if (kDebugMode) {
      print(errorMsg);
    }
  }
}
