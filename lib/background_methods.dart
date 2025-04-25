// /*
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
//
//
//
//
//
//
//
//
//
//
// const notificationChannelId = 'my_foreground';
//
// const notificationId = 888;
//
//
// Future<void> initializeService() async {
//   final service = FlutterBackgroundServiceIOS();
//
//
//
//  var result= await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will be executed when app is in foreground or background in separated isolate
//       onStart: onStart,
//       // auto start service
//       autoStart: true,
//       isForegroundMode: true,
//     */
// /*  notificationChannelId: 'my_foreground',
//       initialNotificationTitle: 'AWESOME SERVICE',
//       initialNotificationContent: 'Initializing',
//       foregroundServiceNotificationId: 888,*//*
//
//     ),
//     iosConfiguration: IosConfiguration(
//       autoStart: true,
//       onForeground: onStart,
//       onBackground: onIosBackground,
//
//     ),
//   );
//
//
//
//
//
//   //service.startService();
//  // service.start();
//   FlutterBackgroundServiceIOS().start();
//
//   //service.invoke("start");
// }
//
//
//
//
//
// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//  DartPluginRegistrant.ensureInitialized();
//
//   print("=====ios=====");
//   print("=====ios=====2");
//   print("=====ios=====3");
//   //var x= await sendData("----------onIosBackground--------------");
//  // print(" \n ${x.body}");
//
//  await  increaseDataInPrefs();
//
//
//   print("=====ios===finish==");
//   return true;
// }
//
//
//
//
//
//
//
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//
//
//
//
//
//   service.on('stopService').listen((event) {service.stopSelf();});
//
//   print("=====onStart=====");
//
//   // bring to foreground
//   */
// /*Timer.periodic(const Duration(seconds: 5), (timer) async {
//
//
//     try {
//        // var x= await sendData("------------------------");
//        // print(" \n ${x.body}");
//       print(" ====");
//     } on HttpException catch(e) {
//       print(e.message.toString());
//     }
//
//
//
//     print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
//     final deviceInfo = DeviceInfoPlugin();
//     String? device;
//     if (Platform.isAndroid) {
//       final androidInfo = await deviceInfo.androidInfo;
//       device = androidInfo.model;
//     }
//     else if (Platform.isIOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       device = iosInfo.model;
//     }
//
//     service.invoke('update',
//       {
//         "current_date": DateTime.now().toIso8601String(),
//         "device": device,
//       },
//     );
//   });*//*
//
// }
//
//
//
// Future<int> getDataInPref()async{
//   var prefs=await SharedPreferences.getInstance();
//
//   var val= prefs.getInt("task");
//   if(val==null){await prefs.setInt("task", 0);return 0;}
//   else{return val;}
//
// }
//
//
// increaseDataInPrefs()async{
//   print("start increasing .......");
//   var prefs=await SharedPreferences.getInstance();
//   var current =await getDataInPref();
//   await prefs.setInt("task",current+1 );
//
//
//   var current2 =await getDataInPref();
//   print("finish increasing .......$current>= $current2");
// }
//
// clearCache()async{
//   var prefs=await SharedPreferences.getInstance();
//   prefs.clear();
// }
// */
