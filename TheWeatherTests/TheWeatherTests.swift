import XCTest
import Combine
import CoreLocation
import LocationClient
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
        viewModel.onAppear()
        viewModel.fetchSearchResults()
        // we need to wait, as we have async
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for seconds")], timeout: 0.1)
        
        XCTAssertEqual(viewModel.currentLocation!.coordinate.longitude, WeatherRepository.PlaceResponse.mock.coordinate.longitude)
        XCTAssertEqual(viewModel.currentLocation!.coordinate.latitude, WeatherRepository.PlaceResponse.mock.coordinate.latitude)
        XCTAssertEqual(viewModel.weatherResults, [.mock])
    }
    
    func testLocationAuthStatusChange() {
        var authorizationStatus = CLAuthorizationStatus.notDetermined
        let locationDelegateSubject = PassthroughSubject<LocationClient.DelegateEvent, Never>()

        let viewModel = AppViewModel(
            weatherRepository: WeatherRepository(
                currentWeather: { _ in .init(.mock) },
                searchPlace: { _ in .init([.mock]) }
            ), locationClient: LocationClient(
                authorizationStatus: { authorizationStatus },
                requestWhenInUseAuthorization: {
                    if authorizationStatus == .authorizedWhenInUse {
                        locationDelegateSubject.send(.didChangeAuthorization(authorizationStatus))
                    }
                },
                requestLocation: {
                    if authorizationStatus == .authorizedWhenInUse {
                        locationDelegateSubject.send(.didUpdateLocations([LocationClient.chicago]))
                    }
                },
                delegate: locationDelegateSubject.eraseToAnyPublisher()
            ),
            id: "Mock.ID"
        )

        XCTAssertEqual(viewModel.currentLocation, nil)
        XCTAssertEqual(viewModel.weatherResults, [])
        
        authorizationStatus = .authorizedWhenInUse
        viewModel.onAppear()
        
        _ = XCTWaiter.wait(for: [expectation(description: "")], timeout: 0.1)
        
        viewModel.fetchSearchResults()
        
        _ = XCTWaiter.wait(for: [expectation(description: "")], timeout: 0.1)
        
        
        XCTAssertEqual(viewModel.currentLocation!.coordinate.longitude, WeatherRepository.PlaceResponse.mock.coordinate.longitude)
        XCTAssertEqual(viewModel.currentLocation!.coordinate.latitude, WeatherRepository.PlaceResponse.mock.coordinate.latitude)
        XCTAssertEqual(viewModel.weatherResults, [.mock])
    }
}
