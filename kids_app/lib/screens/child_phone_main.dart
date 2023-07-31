import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kids_app/constants/colors.dart';
import 'package:kids_app/screens/main_page_screen.dart';
import 'package:kids_app/utils/FirebaseSingleton.dart';
import 'package:kids_app/widgets/app_bar.dart';

import '../models/Child.dart';
import '../models/ScreenTime.dart';

class ChildPhoneMain extends StatefulWidget {
  const ChildPhoneMain(
      {Key? key, required int currentPage, required ChildData childDetails})
      : _currentPage = currentPage,
        _childDetails = childDetails,
        super(key: key);

  final int _currentPage;
  final ChildData _childDetails;

  @override
  _ChildPhoneMainState createState() => _ChildPhoneMainState();
}

List<ChildData> _childPhones = [];
  final List<ScreenTimeData> screenTimeData = [
    ScreenTimeData("Mon", 4.5),
    ScreenTimeData("Tue", 5.2),
    ScreenTimeData("Wed", 6.8),
    ScreenTimeData("Thu", 4.0),
    ScreenTimeData("Fri", 7.5),
    ScreenTimeData("Sat", 6.0),
    ScreenTimeData("Sun", 3.5),
  ];
class _ChildPhoneMainState extends State<ChildPhoneMain>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex = 0;
  late ChildData _childDetails;
  late AnimationController _animationController;
  // late List<ChildData> _childPhones = [];
  late Animation<double> _animation;
  final List<Widget> _pages = [
  const MainTabPage(),
   const StatisticsPage(),
   const ModesPage(),
   const SchedulePage(),
   const LocationPage()
  ];



  @override
  void initState() {
    _selectedIndex = widget._currentPage - 1;
    _childDetails = widget._childDetails;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // shadowColor: Colors.grey,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            _childDetails.childName,
            textAlign: TextAlign.justify,
            style: const TextStyle(
                color: Colors.black, fontFamily: "Andika", fontSize: 20),
          ),
        ),

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(AppColors.mainblue),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => MainPageScreen(
                    currentPage: 1, user: FirebaseSingleton().parentData)));
          },
        ),
      ),
      body: 
       _pages[_selectedIndex],     
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        backgroundColor: const Color(AppColors.mainblue),
        selectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph),
              label: 'Screen Time'),
              BottomNavigationBarItem(
              icon: Icon(Icons.lock),
              label: 'Modes'),
                 BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Schedule'),
                 BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Location'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MainTabPage extends StatelessWidget {
  const MainTabPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(50),
      child:  Center(
        child:       Column(
        children: [
            
          Container(
            margin: const EdgeInsets.only(top: 30 , bottom: 50),
            child: const Text(
              "SCREEN TIME:", style:  TextStyle(
                color: Colors.black, fontFamily: "Andika", fontSize: 20  , fontWeight: FontWeight.bold)
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                       Stack(
            
                children: [
                 const Center(
                    child:  SizedBox(
                      height: 240,
                      width: 240,
                      child:     CircularProgressIndicator(
                    value: 25 / 100.0, // Set the value of the progress (between 0 and 1)
                    backgroundColor: Colors.green, // Set the background color of the progress bar
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red), // Set the color of the progress indicator
                    strokeWidth: 25, // Set the width of the progress indicator
                  ),
                    )   ),
            Center(
              child:  Container(
                margin: EdgeInsets.only(top: 45 ),
                 child: Text("02:40" , style:TextStyle(color: Colors.black, fontFamily: "Andika", fontSize: 60  , fontWeight: FontWeight.bold))
                 
        //           RichText(
        //   text: TextSpan(
        //     style: DefaultTextStyle.of(context).style,
        //     children: <TextSpan>[
        //       TextSpan(text: '1', style: TextStyle(color: Colors.black, fontFamily: "Andika", fontSize: 60  , fontWeight: FontWeight.bold)),
        //       TextSpan(text: 'hr ',style: TextStyle(color: Colors.black, fontFamily: "Andika", fontSize: 20  )),
        //         TextSpan(text: '10', style: TextStyle(color: Colors.black, fontFamily: "Andika", fontSize: 60  , fontWeight: FontWeight.bold)),
        //       TextSpan(text: 'min',style: TextStyle(color: Colors.black, fontFamily: "Andika", fontSize: 20  )),
        //     ],
        //   ),
        // ),
                         
            //      const Text(
            //   "02:40", style:  TextStyle(
            //     color: Colors.black, fontFamily: "Andika", fontSize: 70  , fontWeight: FontWeight.bold)
            // ),
              )
            ) , 
         Center(
              child:  Container(
                margin: EdgeInsets.only(top: 145),
                child:  const Text(
              "Remaining:", textAlign: TextAlign.justify, style:  TextStyle(
                color: Colors.black, fontFamily: "Andika", fontSize: 18  )
            ),
              )
            ) , 
             Center(
              child:  Container(
                margin: EdgeInsets.only(top: 170),
              child:  Text("00:20" , style: TextStyle(color: Colors.black, fontFamily: "Andika", fontSize: 20 , fontWeight: FontWeight.bold ),
              
        //       RichText(
        //   text: TextSpan(
        //     style: DefaultTextStyle.of(context).style,
        //     children: <TextSpan>[
        //       TextSpan(text: '0', style: TextStyle(
        //         color: Colors.black, fontFamily: "Andika", fontSize: 20 , fontWeight: FontWeight.bold  )),
        //       TextSpan(text: 'hr ',style: TextStyle(
        //         color: Colors.black, fontFamily: "Andika", fontSize: 12 )),
        //              TextSpan(text: '20', style: TextStyle(
        //         color: Colors.black, fontFamily: "Andika", fontSize: 20 , fontWeight: FontWeight.bold  )),
        //       TextSpan(text: 'min ',style: TextStyle(
        //         color: Colors.black, fontFamily: "Andika", fontSize: 12 )),
        //     ],
        //   ),
        // ),
              ))
            ) ,
             Container(
                              height: 55,
                              width: 80,
                              decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Limit:',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Andika'),
                                  ),
                                  Text("03:00" , style:TextStyle(fontFamily: "Andika", fontSize: 16 , fontWeight: FontWeight.bold  ) ,)
        //                         RichText(
        //   text: TextSpan(
        //     style: DefaultTextStyle.of(context).style,
        //     children: const <TextSpan>[
        //       TextSpan(text: '2', style: TextStyle(fontFamily: "Andika", fontSize: 16 , fontWeight: FontWeight.bold  )),
        //       TextSpan(text: 'hr ',style: TextStyle(fontFamily: "Andika", fontSize: 12 )),
        //              TextSpan(text: '30', style: TextStyle( fontFamily: "Andika", fontSize: 16 , fontWeight: FontWeight.bold  )),
        //       TextSpan(text: 'min ',style: TextStyle( fontFamily: "Andika", fontSize: 12 )),
        //     ],
        //   ),
        // ),
                                ],
                              )),
                         
                ],
              ),                                         
            ],
          ),
   
           SizedBox(height: 120),

                                     GestureDetector(
                            onTap: ()  => {

                            },
                            child:  Container(
                              height: 50,
                              width: 350,
                              decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text(
                                    'EDIT SCREEN TIME',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Andika'),
                                  ),
                                ],
                              )),
                         
                          ),
                      
         
      
    ],
      ),
  
        
      )
      

    );
  }
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

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 12 , top: 10, bottom: 10,right: 10),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              maxY: 10.0, // Adjust the maximum Y value based on your data
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (BuildContext context, value) 
                  {
                      return const TextStyle(
                     color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                      );
                  },
                  margin: 16,
                  getTitles: (double value) {
                    final int index = value.toInt();
                    if (index >= 0 && index < screenTimeData.length) {
                      return screenTimeData[index].day;
                    }
                    return '';
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                getTextStyles: (BuildContext context, value) 
                  {
                      return const TextStyle(
                     color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                      );
                  },
                  margin: 16,
                ),
              ),
              gridData: FlGridData(show: false),
              barGroups: screenTimeData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [BarChartRodData(y: data.screenTime, width: 18, borderRadius: BorderRadius.zero, colors: [Colors.blue])],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class ModesPage extends StatelessWidget {
  const ModesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text("Modes", style: TextStyle(color: Colors.black)),
      ),
    );
  }
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text("Schedule", style: TextStyle(color: Colors.black)),
      ),
    );
  }
}

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text("Location", style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
