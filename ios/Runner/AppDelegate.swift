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

        // Initialize location manager
        locationManager = LocationManager()
        locationStreamHandler = LocationStreamHandler(locationManager: locationManager!)

        // Method channel
        let methodChannel = FlutterMethodChannel(name: "myLocationTracking", binaryMessenger: controller.binaryMessenger)
        methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
            case "startService":
                self?.locationManager?.startTracking()
                result(1)
            case "stopService":
                self?.locationManager?.stopTracking()
                result(1)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        // Event channel
        let eventChannel = FlutterEventChannel(name: "myLocationUpdates", binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(locationStreamHandler)

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
