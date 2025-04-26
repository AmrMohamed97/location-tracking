import Flutter
import UIKit

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
        eventChannel.setStreamHandler(LocationStreamHandler(locationManager: &locationManager, eventSink: &eventSink))
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

// StreamHandler for EventChannel
class LocationStreamHandler: NSObject, FlutterStreamHandler {
    
    weak var locationManager: LocationManager?
    var eventSink: FlutterEventSink?
    
    init(locationManager: inout LocationManager?, eventSink: inout FlutterEventSink?) {
        self.locationManager = locationManager
        self.eventSink = eventSink
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        locationManager?.setEventSink(events)
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        locationManager?.setEventSink(nil)
        return nil
    }
}    // SwiftFlutterBackgroundServicePlugin.taskIdentifier = "location"
     
    
      GeneratedPluginRegistrant.register(with: self)
     
      
//      locationManager?.startTrackingLocation()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
