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
