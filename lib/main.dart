import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_methods.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  // await initializeService();//background services

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  var platform = const MethodChannel("myLocationTracking");

  startService() async {
    try {
      await platform.invokeMethod('startService');

    } on PlatformException catch (e) {
      print("Failed to get count: '${e.message}'.");
      return 0;
    }
  }

  String count="0";
  getCount()async{
    var getCountChannel = const MethodChannel("getCountChannel");
    String co="0";
    try {
      co= await getCountChannel.invokeMethod('getCount');

    } on PlatformException catch (e) {
      print("Failed to get count: '${e.message}'.");
      co="0";
    }
   setState(() {count=co;});
  }



@override
  void initState() {
    // TODO: implement initState
    super.initState();
   //if(Platform.isIOS) {
   //   startService();

    Timer.periodic(const Duration(seconds: 2), (s)async { await  getCount();});

  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Text(count,style: TextStyle(fontSize: 20),)),
            SizedBox(height: 100,),


            Center(
              child: MaterialButton(
                child: const Text('start service'),
                onPressed: ()async {await startService();



                },
              ),
            ),


          ],
        ),
      ),
    );
  }

  Future<int> getDataInPref()async{
    var prefs=await SharedPreferences.getInstance();

    var val= prefs.getInt("task");
    if(val==null){await prefs.setInt("task", 0);return 0;}
    else{return val;}

  }


  increaseDataInPrefs()async{
    print("start increasing .......");
    var prefs=await SharedPreferences.getInstance();
    var current =await getDataInPref();
    await prefs.setInt("task",current+1 );


    var current2 =await getDataInPref();
    print("finish increasing .......$current>= $current2");
  }

  clearCache()async{
    var prefs=await SharedPreferences.getInstance();
    prefs.clear();
  }
}

