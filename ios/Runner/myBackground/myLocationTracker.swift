import BackgroundTasks
import Flutter
import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var eventSink: FlutterEventSink?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        requestLocationPermission()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = .fitness
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.distanceFilter = 10 // Trigger updates when moving 10 meters
    }
    
    // Request permission from the user
    func requestLocationPermission() {
        locationManager.requestAlwaysAuthorization() // Request "Always" authorization
    }
    
    // Start updating the location
    func startTrackingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // Stop updating the location
    func stopTrackingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // Pass the event sink from Flutter
    func setEventSink(_ sink: FlutterEventSink?) {
        eventSink = sink
    }
    
    // CLLocationManagerDelegate method - called when a new location is received
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // Log the location
        print("New location: \(latitude), \(longitude)")
        
        // Increment the count in UserDefaults
        let defaults = UserDefaults.standard
        let currentCount = defaults.integer(forKey: "count")
        defaults.set(currentCount + 1, forKey: "count")
        
        // Send location updates to Flutter
        if let sink = eventSink {
            let locationData = ["latitude": latitude, "longitude": longitude]
            sink(locationData)
        }
    }
    
    // Handle any errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
        eventSink?(FlutterError(code: "LOCATION_ERROR", message: error.localizedDescription, details: nil))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("Location authorized: Always")
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            print("Location authorized: When In Use")
        case .denied, .restricted:
            print("Location permission denied or restricted")
        case .notDetermined:
            print("Location permission not determined yet")
        @unknown default:
            break
        }
    }
}