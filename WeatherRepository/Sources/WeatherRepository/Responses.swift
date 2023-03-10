import Foundation
import CoreLocation

// MARK: - CurrentWeatherResponse
public extension WeatherRepository {
    struct CurrentWeatherResponse: Decodable {
        public let coord: Coordinates
        public let weather: [Weather]
        public let main: Main
        public let id: Int
        public let name: String
    }
    
    struct Coordinates: Codable {
        public let lon, lat: Double
    }
    
    struct Main: Codable {
        public let temp, feelsLike, tempMin, tempMax: Double
        public let pressure, humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
        }
    }
    
    struct Weather: Codable {
        public let id: Int
        public let main, description, icon: String
    }
}

public extension WeatherRepository.Weather {
    var iconURLString: String {
    "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
}

// MARK: - PlaceResponse
public extension WeatherRepository {
    struct PlaceResponse: Codable {
        public let name: String
        public let lat, lon: Double
        public let country, state: String

        enum CodingKeys: String, CodingKey {
            case name
            case lat, lon, country, state
        }
    }
}

public extension WeatherRepository.PlaceResponse {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    static var mock: Self {
        Self(name: "Chicago", lat: 41.8755616, lon: -87.6244212, country: "US", state: "Illinois")
    }
}
