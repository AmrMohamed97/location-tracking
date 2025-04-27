import Flutter
import Foundation

class LocationStreamHandler: NSObject, FlutterStreamHandler {
    private var locationManager: LocationManager?
    private var eventSink: FlutterEventSink?

    init(locationManager: LocationManager?, eventSink: FlutterEventSink?) {
        self.locationManager = locationManager
        self.eventSink = eventSink
        super.init()
        self.locationManager?.setEventSink(eventSink)
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        locationManager?.setEventSink(events)
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        locationManager?.setEventSink(nil)
        return nil
    }
}