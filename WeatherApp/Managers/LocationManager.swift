//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Guntars Reiss on 03/05/2023.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // Following code creates a location-manager and configures it immediately.
    let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        
        // TODO: Request permission from the use (Me Travel app) - REMOVE THIS LINE AFTER ONBOARDING IS COMPLETED!
        isLoading = true
        manager.startUpdatingLocation()
        print("Starting updating location...")
        manager.requestWhenInUseAuthorization()
        print("Requested when in use authorization...")
    }
    
    // Location-related properties and methods
    @Published var location: CLLocationCoordinate2D?
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    func requestLocation() {
        isLoading = true
        manager.startUpdatingLocation()
        print("Starting updating location...")
        manager.requestWhenInUseAuthorization()
        print("Requested when in use authorization...")
        // manager.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            // We have permission
            authorizationState = manager.authorizationStatus
            
            // TODO: Start locating
        } else if manager.authorizationStatus == .denied {
            // We don't have permission
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // New location data is available
        location = locations.first?.coordinate
        isLoading = false
        manager.stopUpdatingLocation()
        print("Stopped updating location!")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
        print(error.localizedDescription)
        isLoading = false
    }
    
}
