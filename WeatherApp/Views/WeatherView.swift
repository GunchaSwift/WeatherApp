//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Guntars Reiss on 03/05/2023.
//

import SwiftUI

struct WeatherView: View {
    @State var weather: ResponseBody
    var weatherManager = WeatherManager()
    var locationManager = LocationManager()
    
    var body: some View {
            ZStack(alignment: .leading) {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(weather.name)
                                .bold().font(.title)
                            Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                                .fontWeight(.light)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Refresh the current weather data
                        Button {
                            // Fetch new current location of the user
                            locationManager.manager.startUpdatingLocation()
                            Task {
                                do {
                                    // Fetch new current weather data
                                    weather = try await weatherManager.getCurrentWeather(latitude: locationManager.location?.latitude ?? 50.2020, longitude: locationManager.location?.longitude ?? 14.2020)
                                    // Stop fetching current location of the user
                                    locationManager.manager.stopUpdatingLocation()
                                } catch {
                                    print("Error getting the weather: \(error)")
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise.icloud")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            
                        }
                        .padding(.trailing, 5)

                    }
                    
                    Spacer()
                    
                    VStack {
                        HStack {
                            VStack(spacing: 20) {
                                // Dynamic icon for current weather condition.
                                switch weather.weather[0].main {
                                case "Clouds":
                                    Image(systemName: "cloud")
                                        .font(.system(size: 40))
                                case "Rain":
                                    Image(systemName: "cloud.rain")
                                        .font(.system(size: 40))
                                case "Snow":
                                    Image(systemName: "cloud.snow")
                                        .font(.system(size: 40))
                                case "Clear":
                                    Image(systemName: "sun.max")
                                        .font(.system(size: 40))
                                default:
                                    Image(systemName: "sun.max")
                                        .font(.system(size: 40))
                                }
                                
                                Text(weather.weather[0].main)
                            }
                            .frame(width: 150, alignment: .leading)
                            
                            Spacer()
                            
                            Text(weather.main.feelsLike.roundDouble() + "°")
                                .font(.system(size: 100))
                                .fontWeight(.bold)
                                .padding()
                        }
                        
                        Spacer()
                            .frame(height: 80)
                        
                        AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2020/01/24/21/33/city-4791269_960_720.png")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 350)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Weather now")
                            .bold().padding(.bottom)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                WeatherRow(logo: "thermometer", name: "Min temp", value: (weather.main.tempMin.roundDouble() + "°"))
                                
                                WeatherRow(logo: "wind", name: "Wind speed", value: (weather.wind.speed.roundDouble() + "m/s"))
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                WeatherRow(logo: "thermometer", name: "Max temp", value: (weather.main.tempMax.roundDouble() + "°"))
                                
                                WeatherRow(logo: "humidity", name: "Humidity", value: (weather.main.humidity.roundDouble() + "%"))
                            }
                        }
                        .padding([.horizontal, .bottom])
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, 20)
                    // TODO: Dynamic background color for current time of the day and/or weather condition.
                    .foregroundColor(Color(hue: 0.599, saturation: 0.707, brightness: 0.415))
                    .background(.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(Color(hue: 0.599, saturation: 0.707, brightness: 0.415))
            .preferredColorScheme(.dark)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather)
    }
}
