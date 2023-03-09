import Foundation

public extension WeatherRepository {
    static let current = Self(
        currentWeather: { coordinate in
            URLSession.shared.dataTaskPublisher(for: APIEndpoint.weatherEndpoint(for: coordinate))
                .map { data, _ in data }
                .decode(type: CurrentWeatherResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        },
        searchPlace: { placeName in
            URLSession.shared.dataTaskPublisher(for: APIEndpoint.geolocationEndpoint(for: placeName))
                .map { data, _ in data }
                .decode(type: [PlaceResponse].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    )
}
