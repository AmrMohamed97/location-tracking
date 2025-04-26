import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  // await initializeService();//background services
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  static const platform = MethodChannel("myLocationTracking");
  static const eventChannel = EventChannel("myLocationUpdates");
  StreamSubscription<dynamic>? _locationSubscription;
  String _location = "Waiting for location...";
  bool _serviceStarted = false;

  @override
  void initState() {
    super.initState();
    _startListeningToLocationUpdates();
  }

  Future<void> _startService() async {
    try {
      final result = await platform.invokeMethod('startService');
      setState(() {
        _serviceStarted = true;
      });
      print("Service started: $result");
    } on PlatformException catch (e) {
      print("Failed to start service: ${e.message}");
      setState(() {
        _serviceStarted = false;
      });
      // يمكنك هنا عرض رسالة للمستخدم تطلب منه إعطاء الصلاحيات
    }
  }

  void _startListeningToLocationUpdates() {
    _locationSubscription = eventChannel.receiveBroadcastStream().listen(
      (dynamic location) {
        setState(() {
          print("Received location update: $location");
          _location = location.toString();
        });
      },
      onError: (dynamic error) {
        print("Error receiving location updates: $error");
      },
    );
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: MaterialButton(
                child: Text(_serviceStarted ? 'Service Running' : 'Start Service'),
                onPressed: _serviceStarted ? null : () async {
                  await _startService();
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Current Location: $_location",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}