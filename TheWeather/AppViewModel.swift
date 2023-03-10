import Foundation
import WeatherRepository
import Combine

public class AppViewModel: ObservableObject {
    static private let defaultsPlaceKey = "\(AppViewModel.self)defaultsPlaceKey"
    @Published var searchPlace = ""
    @Published var currentWeather: WeatherRepository.CurrentWeatherResponse?
    @Published var currentLocation: WeatherRepository.PlaceResponse?
    @Published var weatherResults: [WeatherRepository.PlaceResponse] = []
    
    var weatherRequestCancellable: AnyCancellable?
    var weatherPlaceRequestCancellable: AnyCancellable?
    
    let weatherRepository: WeatherRepository
    
    public init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
        if let placeData = UserDefaults.standard.value(forKey: Self.defaultsPlaceKey) as? Data {
            currentLocation = placeData.toResponse()
        }
        fetchWeather()
    }
    
    func fetchWeather() {
        guard let location = currentLocation else { return }

        self.weatherResults = []
        
        weatherRequestCancellable = weatherRepository
            .currentWeather(location.coordinate)
          .sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] response in
              self?.currentWeather = response
          })
    }
    
    func selectPlace(place: WeatherRepository.PlaceResponse) {
        UserDefaults.standard.setValue(place.toData(), forKey: Self.defaultsPlaceKey)
        currentLocation = place
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
