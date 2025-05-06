import Flutter
import Foundation

class LocationStreamHandler: NSObject, FlutterStreamHandler {
    private var locationManager: LocationManager?

    init(locationManager: LocationManager?) {
        self.locationManager = locationManager
        super.init()
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        locationManager?.setEventSink(events)
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        locationManager?.setEventSink(nil)
        return nil
    }
}
