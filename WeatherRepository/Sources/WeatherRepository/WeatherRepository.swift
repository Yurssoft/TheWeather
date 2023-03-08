import CoreLocation
import Combine

public extension WeatherRepository {
    typealias CurrentWeatherPublisher = AnyPublisher<CurrentWeatherResponse, Error>
    typealias PlacePublisher = AnyPublisher<[PlaceResponse], Error>
}

public struct WeatherRepository {
    public var currentWeather: (CLLocationCoordinate2D) -> CurrentWeatherPublisher
    public var searchPlace: (String) -> PlacePublisher
    
    public init(
        currentWeather: @escaping (CLLocationCoordinate2D) -> CurrentWeatherPublisher,
        searchPlace: @escaping (String) -> PlacePublisher
    ) {
        self.currentWeather = currentWeather
        self.searchPlace = searchPlace
    }
}

// MARK: - CurrentWeatherResponse
public extension WeatherRepository {
    struct CurrentWeatherResponse: Decodable {
        let coord: Coordinates
        let weather: [Weather]
        let base: String
        let main: Main
        let visibility: Int
        let wind: Wind
        let dt: Int
        let timezone, id: Int
        let name: String
        let cod: Int
    }
    
    struct Coordinates: Codable {
        let lon, lat: Double
    }
    
    struct Main: Codable {
        let temp, feelsLike, tempMin, tempMax: Double
        let pressure, humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
        }
    }
    
    struct Weather: Codable {
        let id: Int
        let main, description, icon: String
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }
}

// MARK: - PlaceResponse
public extension WeatherRepository {
    struct PlaceResponse: Codable {
        let name: String
        let localNames: [String: String]?
        let lat, lon: Double
        let country, state: String

        enum CodingKeys: String, CodingKey {
            case name
            case localNames = "local_names"
            case lat, lon, country, state
        }
    }
}
