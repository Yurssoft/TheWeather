import Foundation
import WeatherRepository
import Combine

public class AppViewModel: ObservableObject {
    @Published var currentWeather: WeatherRepository.CurrentWeatherResponse?
    @Published var currentLocation: WeatherRepository.PlaceResponse? = WeatherRepository.PlaceResponse.mock
    @Published var weatherResults: [WeatherRepository.PlaceResponse] = []
    
    var weatherRequestCancellable: AnyCancellable?
    
    let weatherRepository: WeatherRepository
    
    public init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
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
}
