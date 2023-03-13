import XCTest
import Combine
@testable import WeatherRepository
@testable import TheWeather

extension WeatherRepository.CurrentWeatherResponse {
    static let mock = WeatherRepository.CurrentWeatherResponse(coord: WeatherRepository.Coordinates(lon: 44, lat: 44), weather: [], main: WeatherRepository.Main(temp: 33, feelsLike: 33, tempMin: 33, tempMax: 33, pressure: 33, humidity: 33), id: 38874, name: "Pedirff")
}

extension AnyPublisher {
    init(_ value: Output) {
        self = Just(value).setFailureType(to: Failure.self).eraseToAnyPublisher()
    }
}

extension WeatherRepository {
    static let emptyClosuresFatal = Self(
        currentWeather: { _ in fatalError() },
        searchPlace: { _ in fatalError() }
    )
}

final class TheWeatherTests: XCTestCase {
    
    func testAuthorizedWhenInUse() {
        let viewModel = AppViewModel(
            weatherRepository: WeatherRepository(
                currentWeather: { _ in .init(.mock) },
                searchPlace: { _ in .init([.mock]) }
            ),
            locationClient: .authorizedWhenInUseSequence,
            id: "Mock.ID"
        )
        
        // we need to wait, as location fetched in delegate in async
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for seconds")], timeout: 1.0)
        
        XCTAssertEqual(viewModel.currentLocation!, .mock)
        XCTAssertEqual(viewModel.weatherResults, [.mock])
    }
}
