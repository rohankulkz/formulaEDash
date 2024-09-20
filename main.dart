import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geri_flutter_dash/chartData.dart';
import 'package:geri_flutter_dash/flagBuilder.dart';
import 'dart:developer' as l;
import 'dart:html' as html;
import 'package:geri_flutter_dash/recordCompiler.dart' as record_machine;
import 'package:geri_flutter_dash/tableGenerator.dart' as table_machine;
import 'package:flutter/services.dart';
import 'package:geri_flutter_dash/analyticsWidgets.dart' as analytics_widget_machine;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'apiClient.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(185, 232, 223, 0.5)),
          useMaterial3: true,
          fontFamily: "Roboto"),
      home: const MyHomePage(title: 'Admin'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



Color mainThemeBLue = Color.fromRGBO(26,115,232, 1);
// Color mainThemeBlack = Colors.black87.withOpacity(0.8);
//Color mainThemeBlack = Color.fromRGBO(26,115,232, 1);

//note not actually black, more of a navy blue but too lazy to rename variable
Color mainThemeBlack = Color.fromRGBO(27,58,87, 1);




class _MyHomePageState extends State<MyHomePage> {


  late CrosshairBehavior _crosshairBehavior0;
  late CrosshairBehavior _crosshairBehavior1;
  late ZoomPanBehavior _zoomPanBehavior0;
  late ZoomPanBehavior _zoomPanBehavior1;



  late String appState;
  String accessToken = "";
  @override
  void initState() {
    appState = "login";
    // TODO: implement initState
    _crosshairBehavior0 = CrosshairBehavior(enable: true, activationMode: ActivationMode.singleTap);
    _crosshairBehavior1 = CrosshairBehavior(enable: true, activationMode: ActivationMode.singleTap);
    _zoomPanBehavior0 = ZoomPanBehavior(enableDoubleTapZooming: true, enableMouseWheelZooming: true, enableSelectionZooming: true);
    _zoomPanBehavior1 = ZoomPanBehavior(enableDoubleTapZooming: true, enableMouseWheelZooming: true, enableSelectionZooming: true);

    super.initState();
  }

  //Color mainThemeBLue = Color.fromRGBO(63,145,207, 1);
  //Color mainThemeBLue = Colors.black87.withOpacity(0.8);

  late String location;
  int index = 0;

  List<String> locations = <String>["No Locations"];

  List<String> getLocations() {
    return locations;
  }

  void openInWindow(String uri, String name) {
    html.window.open(uri, name);
  }


  double seperationConstant = 0;

  Widget getUserSection(){
    return Container(
      margin: EdgeInsets.only(bottom: seperationConstant),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25)
        ),

        child:
        Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Container(
                margin: EdgeInsets.only(left: 0, right: MediaQuery.of(context).size.width*0.02, top: 0, bottom: 0),

                child: Text(accessToken, style: TextStyle(
                    fontSize: MediaQuery.of(context).textScaleFactor * 17
                ),
                ),
              ),
              Container(
                child: Icon(Icons.person_2, size: 25,),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.black)
                ),

              )
            ],
            )
        )
    );
  }


  Widget getLogoutSection(){
    return

      GestureDetector(
        onTap: () => logout(),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25)
        ),

        child:
        Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 0, right: MediaQuery.of(context).size.width*0.015, top: 0, bottom: 0),

                  child: Text("Logout", style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 17
                  ),
                  ),
                ),
                Container(
                  child: Icon(Icons.logout, size: 25,),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black)
                  ),

                )
              ],
            )
        )
    )
      );
  }

  //TODO implement real logout methods
  void logout(){
    appState = "login";
    accessToken = "";
    loadedData = [["No Loaded Data"]];
    setState(() {

    });
  }



  List<Widget> getOptions(){

    return [getUserSection(), getLogoutSection()];

  }
  int sideBarIndex = 0;





  List<ChartData> masterSentimentData = [
    ChartData(0, 0),
    ChartData(0, 0),
    ChartData(0, 0),
    ChartData(0, 0),
    ChartData(0, 0),
  ];

  int masterTotalUsers = 269;
  int masterTotalQueries = 15490;
  int masterTotalSessions = 3509;
  double masterAverageSatisfaction = 93.7;

  int flagIndex = 0;

  List<List<Map<String, String>>> superFlagData =
  [];


  int surveyIndex = 0;

  List<List<Map<String, String>>> superSurveyData =
  [
  ];

  int batchReminderIndex = 0;

  List<List<Map<String, String>>> superBatchReminderData =
  [

  ];



  //designed kinda weird not sure why it works but it does
  increaseFlagPage(int max){
    if(flagIndex >= max){
      flagIndex  = max-1;
    }
    else{
      flagIndex++;
    }
    //log(userPage.toString());
    if(flagIndex>max-1){
      flagIndex = max-1;
    }
    changeDashView(2);
  }

  decreaseFlagPage(){
    if(flagIndex == 0){
      flagIndex  = 0;
    }
    else{
      flagIndex--;
    }
    //log(userPage.toString());
    changeDashView(2);
  }




  List<Map<String, String>> masterRecords = [];


  late Widget content;

  void changeDashView(int page){
    sideBarIndex = page;

    if(page == 0){

      if(masterRecords.length == 0){
        masterRecords =  record_machine.generateRecords(198);
      }
      content = getRawDataPage(loadedData, loadedData.length);
    }
    if(page == 1){


      content = getAnalyticsPage(
          loadedData,
          masterSentimentData.reversed.toList(),
          loadedData.length,
          masterTotalQueries,
          masterTotalSessions,
          masterAverageSatisfaction);
    }
    if(page == 2){
      content = getFlagsPage();

    }
    if(page == 3){
      content = getSettingsPage();
    }

    setState(() {

    });
  }





  void refreshUsage() async{
    changeDashView(1);


  }


  void changeUserPage(){

  }


  BoxDecoration getDecor(int decorIndex){
    if(decorIndex == sideBarIndex){
      return BoxDecoration(
        color: Colors.grey.withOpacity(0.5)
      );
    }
    else{
      return BoxDecoration(
          color: Colors.white.withOpacity(0.3)
      );
    }
  }


  getSideBarLength(){
    return 100;
  }
  getSideBarHeight(){
    return 100;
  }
  getHeaderHeight(){
    return 70;
  }


  int userPage = 1;

  increasePage(int max){
      if(userPage+1 > max){
      userPage  = max;
    }
    else{
      userPage++;
    }
    //log(userPage.toString());
    changeDashView(0);
  }

  decreasePage(){
      if(userPage == 1){
        userPage  = 1;
      }
      else{
        userPage--;
      }
      //log(userPage.toString());
      changeDashView(0);
  }




  Widget paginationWidget(int page, int max, VoidCallback decrease, VoidCallback increase){

    return Container(
      width: 300,
      height: 50,
      margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        //border: Border.all(color: Colors.black.withOpacity(0.4))
      ),
      alignment: Alignment.topCenter,
      child:

      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: decrease,
            child: Icon(Icons.arrow_left_outlined, size: 50,),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Text("$page of $max")
          ),
          InkWell(
            onTap: increase,
            child: Icon(Icons.arrow_right_outlined, size: 50,),
          ),
        ],
      ),
    );

  }




  SingleChildScrollView getUsersPage(List<Map<String, String>> data, int maxLength){
    return

      SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                height: 1120,
                width: 900,
                margin: EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey.withOpacity(0.4))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Container(
                          height: 70,
                          width: 800,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 25, top: 25, bottom: 25, right: 0),
                          child: SelectableText("Raw Data", style: TextStyle(fontSize: 25)),
                        ),
                        Container(
                            alignment: Alignment.center,

                            margin: EdgeInsets.only(
                                top: 0, bottom: 0, right: 25, left: 0),
                            child: InkWell(
                                onTap: () => refresh(),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Icon(Icons.refresh),
                                ))),
                      ]
                      ,
                    ),
                    Container(
                      height: 30,
                      width: 900,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 25, top: 0, bottom: 0, right: 0),
                            child: const SelectableText("Name"),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 300, top: 0, bottom: 0, right: 0),

                            child: const SelectableText("Sentiment"),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 75, top: 0, bottom: 0, right: 0),

                            child: const SelectableText("Satisfaction"),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 75, top: 0, bottom: 0, right: 0),

                            child: const SelectableText("Reminder Set"),
                          )
                        ],
                      ),
                    ),
                    table_machine.generateUsersTable(data)
                  ],
                ),
              ),
              paginationWidget(userPage, maxLength, () => decreasePage(), () => increasePage(maxLength))

            ],
          )
      )
    ;

  }



  SingleChildScrollView getRawDataPage(List<List<String>> data, int maxLength){



    List<Container> titles = [];


    for (String s in data[0]){
      titles.add(
        Container(
          width: 170,

          margin: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 0),
        child: SelectableText(s),
      )
      );
    }







    return

    SingleChildScrollView(
      scrollDirection: Axis.vertical,
    child: Column(
      children: [
          Container(
            height: 1120,
            width: 2400,
            margin: EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey.withOpacity(0.4))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                    Container(
                      height: 70,
                      width: 800,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 20, top: 25, bottom: 25, right: 0),
                      child: SelectableText("Raw Data", style: TextStyle(fontSize: 25)),
                    ),
                      Container(
                          alignment: Alignment.center,

                          margin: EdgeInsets.only(
                              top: 0, bottom: 0, right: 25, left: 0),
                          child: InkWell(
                              onTap: () => refresh(),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Icon(Icons.refresh),
                              ))),
                  ]
                    ,
                  ),
                        Container(
                          height: 30,
                          //width: 900,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: titles,
                          ),
                        ),
                    table_machine.generateRawTable(data, 1 + (userPage-1)*44, userPage*44)
                  ],
                ),
              ),
        paginationWidget(userPage, maxLength~/44 , () => decreasePage(), () => increasePage(maxLength))

      ],
    )
    )
     ;

  }




  //GraphOptions Control Station


  List<List<int>> indexTracker = [[0,0],[0,0],[0,0],[0,0]];


  void changeIndex(int graph, int option, int value){
    indexTracker[graph][option] = value;
  }

  int getIndex(int graph, int option){
    return indexTracker[graph][option];
  }

  //GraphOptions Control Station


  SingleChildScrollView getAnalyticsPage(List<List<String>> graphData, List<ChartData> sentimentData, int totalUsers, int totalQueries, int totalSessions, double averageSatisfaction){

    graphData = graphData.sublist(1, graphData.length);

    return
      SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                height: 1400,
                width: 1400,
                margin: EdgeInsets.only(top: 0, bottom: 20, right: 20, left: 20),
                decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(25),
                    //border: Border.all(color: Colors.grey.withOpacity(0.4))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      width: 1500,
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.all(25),
                      child: SelectableText("Analytics", style: TextStyle(fontSize: 25)),
                    )
                    ,
                    Container(
                      height: 300,
                      width: 1500,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 50, top: 0, bottom: 0, right: 0),
                            child: analytics_widget_machine.buildUsersWidget(totalUsers),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 400,
                      width: 1500,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 50, top: 0, bottom: 0, right: 0),
                            child: analytics_widget_machine.usageGraph(loadedData, () => refreshUsage(), loadedData[0],  changeIndex, 0, getIndex, _crosshairBehavior0, _zoomPanBehavior0),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 30, top: 0, bottom: 0, right: 0),
                            child: analytics_widget_machine.usageGraph(loadedData, () => refreshUsage(), loadedData[0], changeIndex, 1, getIndex, _crosshairBehavior1, _zoomPanBehavior1),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 440,
                      width: 1500,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 50, top: 25, bottom: 0, right: 0),
                            child: analytics_widget_machine.analyticsShell([]),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 30, top: 25, bottom: 0, right: 0),
                            child: analytics_widget_machine.analyticsShell([]),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          )
      );

  }


  late String uploadedFile;
  String fileName = "";

  void filePicker() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      uploadedFile = utf8.decode(file.bytes!);
      fileName = file.name;
      changeDashView(2);
    } else {
      // User canceled the picker
    }
  }

  void uploadData() async{

    String tempValue = await uploadDataToWeb(accessToken, nicknameBox.text, uploadedFile);

    //print(tempValue);

    if(tempValue == "true"){
      uploadedFile = "";
      fileName = "";
      changeDashView(2);
    }
    else{
      //print("failed");
      fileName = "Upload Failed";
      changeDashView(2);
    }
  }

  Widget getFlagsPage(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top:20, left: 30, right: 30, bottom: 0),
              child: getFlagAssessmentWidget(nicknameBox, ()=> filePicker(), uploadData, fileName),

            )
          ],
        )
    );
  }

  Widget getSettingsPage(){
    return SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,

          child: Text("Settings"),

        )
    );
  }

  SingleChildScrollView getSidebar(){
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => changeDashView(0),
          child: Container(
        height: getSideBarHeight(),
            width: getSideBarLength(),
            decoration: getDecor(0),
            child: Icon(Icons.people),
          ),
        ),
        InkWell(
          onTap: () => changeDashView(1),

          child: Container(
            width: getSideBarLength(),
            height: getSideBarHeight(),

            decoration: getDecor(1),
            child: Icon(Icons.analytics),

          ),
        ),
        InkWell(
          onTap: () => changeDashView(2),

          child: Container(
            width: getSideBarLength(),
            height: getSideBarHeight(),

            decoration: getDecor(2),
            child: Icon(Icons.upload_file),

          ),
        ),
      ],
    )
    );
  }


  Scaffold mainDashboardView(){
    List<Widget> options = getOptions();
    location = getLocations()[index];
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: getHeaderHeight(),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomRight: Radius.circular(0),
                    bottomLeft: Radius.circular(0)),
                //color: Color.fromRGBO(27,114,232, 1),
                color: mainThemeBLue,
                border: Border.all(color: Colors.white, width: 0.5),


              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                      children: [



                        InkWell(
                            onTap: () => openInWindow("https://ev.studentorg.berkeley.edu/", '_self'),
                            child: Container(

                              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02, right: MediaQuery.of(context).size.width*0.01, top: 5, bottom: 10)
                              ,child:
                            ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Image.asset("assets/images/favicon.png")
                            ),
                            )
                        ),
                        Container(
                          child: Text(
                            "",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).textScaleFactor * 23,
                                color: Colors.white
                            ),
                          ),
                        )
                      ]
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 0, right: MediaQuery.of(context).size.width*0.02, top: 0, bottom: 0),
                        child: InkWell(
                          //onTap (),
                          child: InkWell(
                              onTap: () => changeDashView(2),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Icon(Icons.upload_file),
                              )),
                        ),
                      ),
                      Container(
                        child: InkWell(
                          //onTap (),
                          child: InkWell(
                              onTap: () => refresh(),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Icon(Icons.refresh),
                              )),
                        ),
                      ),
                      Container(

                          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02, right: MediaQuery.of(context).size.width*0.01, top: 0, bottom: 0),
                          child: DecoratedBox(

                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 0, bottom: 0),
                                  child:
                                  DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        alignment: Alignment.centerLeft,
                                        borderRadius: BorderRadius.circular(29),
                                          value: location,
                                          items: getLocations().map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                          onChanged: (String? value) {
                                            // This is called when the user selects an item.
                                            setState(() {
                                              //location = value!;
                                              index = getLocations().indexOf(value!);
                                            });
                                          })
                                  )
                              )
                          )
                      ),


                      Container(
                        margin: EdgeInsets.only(left: 0, right: MediaQuery.of(context).size.width*0.02, top: 0, bottom: 0),
                        child:


                        // InputDecorator(
                        // decoration: InputDecoration(
                        //   border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))
                        // ),
                        // child:
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            dropdownColor: mainThemeBLue,
                            borderRadius: BorderRadius.circular(29),
                            iconSize: 0,
                            value: options.first,
                            items: options.map<DropdownMenuItem<Widget>>((Widget value) {
                              return DropdownMenuItem<Widget>(
                                child: value,
                                value: value,
                              );
                            }).toList(),
                            onChanged: (value) {  },
                          ),
                        )
   // ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
            child:
            //Expanded(
               // child:
              Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(

                child: getSidebar(),
                height: MediaQuery.of(context).size.height-getHeaderHeight(),
                decoration: BoxDecoration(
                    border:  Border(top: BorderSide(color: Colors.white),
                        bottom: BorderSide(color: mainThemeBLue, width: 1),
                        left: BorderSide(color: mainThemeBLue, width: 1),
                        right: BorderSide(color: mainThemeBLue, width: 1)
                    ),
                    color: Colors.grey.withOpacity(0.1)
                ),
              ),


             Container(
                  alignment: Alignment.topLeft,
                  height: MediaQuery.of(context).size.height-getHeaderHeight(),
                  child: content,
             )

    //             Expanded(
    //               child: content,
    //
    //             )
            ],
                )
            //)
            ),
          ],
        ),
      ),
    );
  }


  TextEditingController usernameBox = TextEditingController();
  TextEditingController passwordBox = TextEditingController();
  TextEditingController nicknameBox = TextEditingController();



  Scaffold mainLoginView(){
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: getHeaderHeight(),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomRight: Radius.circular(0),
                    bottomLeft: Radius.circular(0)
                ),
                border: Border.all(color: Colors.white, width: 0.5),
                //color: Color.fromRGBO(27,114,232, 1),
                color: mainThemeBLue,

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                      children: [



                        InkWell(
                            onTap: () => openInWindow("https://ev.studentorg.berkeley.edu/", '_self'),
                            child: Container(

                              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02, right: MediaQuery.of(context).size.width*0.03, top: 5, bottom: 10)
                              ,child:
                            ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Image.asset("assets/images/favicon.png")
                            ),
                            )
                        ),
                        Container(
                          child: Text(
                            "",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).textScaleFactor * 23,
                                color: Colors.white
                            ),
                          ),
                        )
                      ]
                  ),
                              ],
                              )
                          ),

            Container(
              margin: EdgeInsets.only(left: 0, right: 0, top: MediaQuery.of(context).size.height*0.07, bottom: 0),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.withOpacity(0.4)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
                child:
                     Padding(

                padding: EdgeInsets.all(50),
                child: Column(
              children: [

                Container(
                  child: Text("Login", style: TextStyle(
                    fontSize: 25
                  ),),
                ),
                Container(
                    width: maxWidthLoginBox(),
                    margin: EdgeInsets.only(left: 0, right: 0, top: MediaQuery.of(context).size.height*0.08, bottom: 0),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                          hintText: "Username"
                      ),
                      controller: usernameBox,
                    )
                ),
                Container(
                    width: maxWidthLoginBox(),
                    margin: EdgeInsets.only(left: 0, right: 0, top: MediaQuery.of(context).size.height*0.04, bottom: 0),

                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                        hintText: "Password",
                      ),
                      controller: passwordBox,
                      obscureText: true,
                    )
                ),
                Container(
                    margin: EdgeInsets.only(left: 0, right: 0, top: MediaQuery.of(context).size.height*0.04, bottom: 0),

                    child: ElevatedButton(
                        onPressed: () => login(usernameBox.text,passwordBox.text),
                        child: Container(
                          width: maxWidthLoginButton(),
                          margin: EdgeInsets.only(left: 0, right: 0, top: MediaQuery.of(context).size.height*0.0, bottom: 0),
                          alignment: Alignment.center,
                          child: const Text("Login"),
                        )
                    )
                )

              ],
            )
                )

            )


                    ],
                  ),
              ),
            );
  }


  Scaffold LoginLoadView(){
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                height: getHeaderHeight(),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0)
                  ),
                  border: Border.all(color: Colors.white, width: 0.5),
                  //color: Color.fromRGBO(27,114,232, 1),
                  color: mainThemeBLue,

                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Row(
                        children: [



                          InkWell(
                              onTap: () => openInWindow("https://ev.studentorg.berkeley.edu/", '_self'),
                              child: Container(

                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02, right: MediaQuery.of(context).size.width*0.03, top: 5, bottom: 10)
                                ,child:
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset("assets/images/favicon.png")
                              ),
                              )
                          ),
                          Container(
                            child: Text(
                              "",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).textScaleFactor * 23,
                                  color: Colors.white
                              ),
                            ),
                          )
                        ]
                    ),
                  ],
                )
            ),

            Container(
                margin: EdgeInsets.only(left: 0, right: 0, top: MediaQuery.of(context).size.height*0.07, bottom: 0),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.withOpacity(0.4)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child:
                Padding(

                    padding: EdgeInsets.all(50),
                    child: Column(
                      children: [
                        LoadingAnimationWidget.twistingDots(
                          leftDotColor: mainThemeBlack,
                          rightDotColor: mainThemeBLue,
                          size: 75,
                        ),
                      ],
                    )
                )

            )


          ],
        ),
      ),
    );
  }

 //Max width for login boxes
  double maxWidthLoginBox(){
    double width = MediaQuery.of(context).size.width*0.5;
    if(width>300){
      width = 300;
    }
    return width;
  }

  double maxWidthDropdown(){
    double width = MediaQuery.of(context).size.width*0.2;
    if(width>170){
      width = 170;
    }
    return width;
  }

  //Max width for login buttons
  double maxWidthLoginButton(){
    double width = MediaQuery.of(context).size.width*0.2;
    if(width>200){
      width = 200;
    }
    return width;
  }

  late List<List<String>> loadedData = [["No Loaded Data"]];

  void refresh() async{
    locations = (await getNicknames(accessToken));
    loadedData = convertToCSV(await getData(accessToken, location));
    //print("Current Location: " + location);
    //print("Current Data: " + loadedData.toString());
    changeDashView(0);
  }


  void login(String username, String password) async{
      //log("$username | $password");

    if(password.length == 0 || username.length == 0){
      setState(() {
        appState = "loginLoad";
      });
      await Future.delayed(Duration(milliseconds: 1000));
      setState(() {
        appState = "login";
      });
      return;
    }

    usernameBox.text = "";
    passwordBox.text = "";

    setState(() {
      appState = "loginLoad";
    });

    bool resp = (await callLogin(username, password) == username);
    //bool resp = true;
    locations = (await getNicknames(username));

    //await Future.delayed(Duration(milliseconds: 2000));
    if(resp){
    setState(() {
      appState = "dashboard";
      accessToken = username;
      changeDashView(0);
    });
    }
    else{
      //TODO ADD ALARM HERE
      setState(() {
        appState = "login";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if(appState == "dashboard"){
      return mainDashboardView();
    }
    if(appState == "login"){
      return mainLoginView();
    }
    if(appState == "loginLoad"){
      return LoginLoadView();
    }
    else{
      return Scaffold();
    }
  }
}



