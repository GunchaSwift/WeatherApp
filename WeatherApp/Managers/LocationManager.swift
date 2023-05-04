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
    }
    
    // Location-related properties and methods
    @Published var location: CLLocationCoordinate2D?
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    // Request location func that is called when pressing button in WelcomeView, when user hasn't authorized usage of location yet.
    func requestLocation() {
        isLoading = true
        manager.requestWhenInUseAuthorization()
    }
    
    // This method is called either when locationManager instance is created or when the app's authorization status changes.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            // We have permission, set it
            authorizationState = manager.authorizationStatus
            
            // Start locating
            isLoading = true
            manager.startUpdatingLocation()
        } else if manager.authorizationStatus == .denied {
            // We don't have permission
            // TODO: Handle this
        }
    }
    
    // This tells delegate that new location data is available.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // New location data is available!
        location = locations.last?.coordinate
        isLoading = false
        manager.stopUpdatingLocation()
    }
    
    // This tells the delegate that the location manager was unable to retrieve a location value.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
        print(error.localizedDescription)
        isLoading = false
    }
    
}
