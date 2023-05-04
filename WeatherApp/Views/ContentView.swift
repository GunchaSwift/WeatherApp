//
//  ContentView.swift
//  WeatherApp
//
//  Created by Guntars Reiss on 03/05/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    var body: some View {
        VStack {
            // Detect the authorization status of user's location
            if locationManager.authorizationState == .notDetermined {
                // We don't have authorization yet
                let _ = print("We don't have authorization yet")
                // TODO: Show onboarding and then ask for permission (currently asking for permission at launch!)
                Color(hue: 0.599, saturation: 0.707, brightness: 0.415)
                    .ignoresSafeArea()
            } else if locationManager.authorizationState == .authorizedAlways || locationManager.authorizationState == .authorizedWhenInUse {
                // We have authorization
                let _ = print("We have authorization")
                // Check if we have weather data
                if let location = locationManager.location {
                    if let weather = weather {
                        // We have weather
                        let _ = print("We have weather")
                        WeatherView(weather: weather)
                    } else {
                        // Still loading
                        let _ = print("Still loading")
                        LoadingView()
                            .task {
                                do {
                                    weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                } catch {
                                    print("Error getting the weather: \(error)")
                                }
                            }
                    }
                }
                
            }
        }
        .background(Color(hue: 0.599, saturation: 0.707, brightness: 0.415))
        .preferredColorScheme(.dark)
            
        /*VStack {
            // Something is not working here... Change the whole shit.
            if locationManager.manager.authorizationStatus == .authorizedAlways || locationManager.manager.authorizationStatus == .authorizedWhenInUse {
                // User has authorized location's usage
                let _ = print("User has authorized location's usage")
                if let location = locationManager.location {
                    if let weather = weather {
                        WeatherView(weather: weather)
                    } else {
                        LoadingView()
                            .task {
                                do {
                                    weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                } catch {
                                    print("Error getting weather: \(error)")
                                }
                            }
                    }
                }
            } else if locationManager.manager.authorizationStatus == .denied {
                // User denied location's usage
                let _ = print("User has denied location's usage")
            } else {
                // User hasn't authorized location's usage yet
                let _ = print("User hasn't authorized location's usage yet")
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        /*VStack {
            if let location = locationManager.location {
                if let weather = weather {
                    WeatherView(weather: weather)
                } else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                            } catch {
                                print("Error getting weather: \(error)")
                            }
                        }
                }
            } else {
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }*/
        }*/
        //.background(Color(hue: 0.599, saturation: 0.707, brightness: 0.415))
        //.preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
