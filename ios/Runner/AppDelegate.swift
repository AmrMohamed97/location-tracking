import Flutter
import UIKit



@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      
      
      var locationManager: LocationManager?
      
    //start service
      let controller = window?.rootViewController as! FlutterViewController
      let nativeChannel = FlutterMethodChannel(name: "myLocationTracking",binaryMessenger: controller.binaryMessenger)
      nativeChannel.setMethodCallHandler {
          (call: FlutterMethodCall, result: @escaping FlutterResult) in
                if call.method == "startService" {
                    locationManager = LocationManager()
                    locationManager?.startTrackingLocation()
                 
                    result(1)
                } else {
                    result(FlutterMethodNotImplemented)
                }
            }
      
      
      
      
      
      
      //get Counts
      let controller2 = window?.rootViewController as! FlutterViewController
      let nativeChannel2 = FlutterMethodChannel(name: "getCountChannel",binaryMessenger: controller2.binaryMessenger)
      nativeChannel2.setMethodCallHandler {
          (call: FlutterMethodCall, result: @escaping FlutterResult) in
                if call.method == "getCount" {
                    
                   
                   var count = getCounts()
                    result(String(count))
                } else {
                    result(FlutterMethodNotImplemented)
                }
            }
      
      
      
      
      
      
     // SwiftFlutterBackgroundServicePlugin.taskIdentifier = "location"
     
    
      GeneratedPluginRegistrant.register(with: self)
     
      
//      locationManager?.startTrackingLocation()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
