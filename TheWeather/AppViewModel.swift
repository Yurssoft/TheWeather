import Foundation
import WeatherRepository
import Combine
import LocationClient

struct ErrorWrapper: Equatable, Identifiable {
    let id = UUID().uuidString
    let text: String
}

public class AppViewModel: ObservableObject {
    static private let defaultsPlaceKey = "\(AppViewModel.self)defaultsPlaceKey"
    @Published var searchPlace = ""
    @Published var errorText: ErrorWrapper?
    @Published var currentWeather: WeatherRepository.CurrentWeatherResponse?
    @Published var currentLocation: WeatherRepository.PlaceResponse?
    @Published var weatherResults: [WeatherRepository.PlaceResponse] = []
    
    var weatherRequestCancellable: AnyCancellable?
    var weatherPlaceRequestCancellable: AnyCancellable?
    var locationDelegateCancellable: AnyCancellable?
    
    let weatherRepository: WeatherRepository
    let locationClient: LocationClient
    
    public init(weatherRepository: WeatherRepository, locationClient: LocationClient) {
        self.weatherRepository = weatherRepository
        self.locationClient = locationClient
        if let placeData = UserDefaults.standard.value(forKey: Self.defaultsPlaceKey) as? Data {
            currentLocation = placeData.toResponse()
        }
        fetchWeather()
        subscribeToLocationDelegate()
    }
    
    private func subscribeToLocationDelegate() {
        locationDelegateCancellable = locationClient.delegate
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] event in
                switch event {
                case .didChangeAuthorization(let status):
                    switch status {
                    case .notDetermined:
                        break
                        
                    case .restricted:
                        errorText = ErrorWrapper(text: "Location restricted")
                        
                    case .denied:
                        errorText = ErrorWrapper(text: "Location denied")
                        
                    case .authorizedAlways, .authorizedWhenInUse:
                        locationClient.requestLocation()
                        
                    @unknown default:
                        break
                    }
                    
                case .didUpdateLocations(let locations):
                    currentLocation = .createFrom(location: locations.first!.coordinate)
                    fetchWeather()
                    
                case .didFailWithError:
                    errorText = ErrorWrapper(text: "Location general error")
                }
            }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.locationClient.requestWhenInUseAuthorization()
            self.locationClient.requestLocation()
//        }
    }
    
    func fetchWeather() {
        guard let location = currentLocation else { return }
        
        self.weatherResults = []
        
        weatherRequestCancellable = weatherRepository
            .currentWeather(location.coordinate)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] response in
                    self?.currentWeather = response
                })
    }
    
    func selectPlace(place: WeatherRepository.PlaceResponse) {
        UserDefaults.standard.setValue(place.toData(), forKey: Self.defaultsPlaceKey)
        currentLocation = place
        searchPlace = ""
        fetchWeather()
    }
    
    func fetchSearchResults() {
        weatherPlaceRequestCancellable = weatherRepository
            .searchPlace(searchPlace)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [unowned self] places in
                    weatherResults = places
                }
            )
    }
}
