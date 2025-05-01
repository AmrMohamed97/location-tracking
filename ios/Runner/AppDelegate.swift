import Flutter
import UIKit
 
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var locationManager: LocationManager?
    var locationStreamHandler: LocationStreamHandler?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller = window?.rootViewController as! FlutterViewController
        
        // تهيئة LocationManager و LocationStreamHandler مرة واحدة فقط
        locationManager = LocationManager()
        locationStreamHandler = LocationStreamHandler(locationManager: locationManager, eventSink: nil)
        
        // MethodChannel
        let nativeChannel = FlutterMethodChannel(name: "myLocationTracking", binaryMessenger: controller.binaryMessenger)
        nativeChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "startService" {
                self?.locationManager?.startTrackingLocation()
                result(1)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        // EventChannel
        let eventChannel = FlutterEventChannel(name: "myLocationUpdates", binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(locationStreamHandler)
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
import myBackground.LocationStreamHandler