import Flutter
import UIKit
import myBackground.LocationStreamHandler
 
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var locationManager: LocationManager?
    var eventSink: FlutterEventSink?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller = window?.rootViewController as! FlutterViewController
        
        // MethodChannel for starting the service
        let nativeChannel = FlutterMethodChannel(name: "myLocationTracking", binaryMessenger: controller.binaryMessenger)
        nativeChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "startService" {
                self?.locationManager = LocationManager()
                self?.locationManager?.startTrackingLocation()
                result(1)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        // EventChannel for sending continuous location updates
        let eventChannel = FlutterEventChannel(name: "myLocationUpdates", binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(LocationStreamHandler(locationManager: locationManager, eventSink: eventSink))
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}