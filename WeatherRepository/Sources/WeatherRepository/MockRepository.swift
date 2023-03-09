import Foundation
import Combine

public extension WeatherRepository {
    static let successSequence = Self(
        currentWeather: { _ in
            Just(CurrentWeatherResponse(coord: Coordinates(lon: 80.0, lat: 80.0),
                                        weather: [Weather(id: 803, main: "Clouds", description: "broken clouds", icon: "04d")],
                                        main: Main(temp: 278.62, feelsLike: 274.38, tempMin: 277.07, tempMax: 281.27, pressure: 1035, humidity: 42),
                                        id: 4887398,
                                        name: "Chicago"))
              .setFailureType(to: Error.self)
              .eraseToAnyPublisher()
        },
        searchPlace: { _ in
            Just([PlaceResponse.mock])
                .setFailureType(to: Error.self)
              .eraseToAnyPublisher()
        }
    )
}
