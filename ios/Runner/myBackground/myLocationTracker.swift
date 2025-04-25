//
//  myLocationTracker.swift
//  Runner
//
//  Created by taha on 01/10/2024.
//
import BackgroundTasks
import Flutter
import UIKit
import CoreLocation



class LocationManager: NSObject, CLLocationManagerDelegate
{
    
 
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
       
        
       
        
        locationManager.delegate = self
        requestLocationPermission()
        locationManager.allowsBackgroundLocationUpdates=true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = .fitness
        
        
        
        print("here")
        

        
        
        locationManager.showsBackgroundLocationIndicator = true
        
        startSignificantChangeUpdates()
        startTrackingLocation()
    }
    
    // Request permission from the user
    func requestLocationPermission() {
        
        print("requestLocationPermission")
        locationManager.requestAlwaysAuthorization()  // Request "Always" authorization
    }
    
    // Start updating the location
    func startTrackingLocation() {
        print("startTrackingLocation")
        locationManager.startUpdatingLocation()
    }
    
    // Stop updating the location
    func stopTrackingLocation() {
        print("stopTrackingLocation")
        locationManager.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate method - called when a new location is received
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("here....")
        guard let location = locations.last else { return }
        print("New location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        
        let defaults = UserDefaults.standard
        let count = defaults.integer(forKey: "count")
        
        if let count = defaults.value(forKey: "count") as? Int {
            // If count exists, increment it by 1
            defaults.set(count + 1, forKey: "count")
        } else {
            // If count does not exist, initialize it to 1
            defaults.set(1, forKey: "count")
        }


        print("count: \(count)")
        
        
        
        // Here you can send the location data to your server, update the UI, etc.
    }
    
    // Handle any errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
    
    func startSignificantChangeUpdates() {
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
       
            switch manager.authorizationStatus {
            case .authorizedAlways:
                print("Location authorized: Always")
                
                manager.startUpdatingLocation()
                startSignificantChangeUpdates()
                startTrackingLocation()
            case .authorizedWhenInUse:
                print("Location authorized: When In Use")
                // You can prompt the user to allow "Always" for background tracking
            case .denied, .restricted:
                print("Location permission denied or restricted")
                // Handle the case where the user has denied location services
            case .notDetermined:
                print("Location permission not determined yet")
            @unknown default:
                break
            }
        
    
}


}


func getCounts()->Int{
    let defaults = UserDefaults.standard
    let count = defaults.integer(forKey: "count")
    if let count = defaults.value(forKey: "count") as? Int {
        // If count exists, increment it by 1
        return count;
    } else {
        // If count does not exist, initialize it to 1
        return 0;
    }
}




