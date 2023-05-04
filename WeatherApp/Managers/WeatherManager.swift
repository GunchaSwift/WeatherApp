//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Guntars Reiss on 03/05/2023.
//

import Foundation
import CoreLocation

class WeatherManager {
    // API key to OpenWeatherMap account.
    let apiKey = "3b8acc9b00e6bd263590ae43d777ca0c"
    
    // This method gets current weather data from API, using longitude and latitude provided from user's location. We use 'async', because networking might take longer time to complete.
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric") else { fatalError("Missing URL") }
        
        // URLRequest encapsulates the URL and policies used to load it. This only represents information about the request.
        let urlRequest = URLRequest(url: url)
        
        // When request completes, we can immediately assign its data to properties. Here it takes URL and returns Data. URLSession provide an API for downloading and uploading data to URL endpoints.
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data") }
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        return decodedData
    }
}

struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}
