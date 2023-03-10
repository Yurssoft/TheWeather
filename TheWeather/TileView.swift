import SwiftUI
import ImageManager
import WeatherRepository

struct TileView: View {
    let currentWeather: WeatherRepository.CurrentWeatherResponse
    var body: some View {
        VStack {
            CachedImage(urlString: currentWeather.weather.first?.iconURLString ?? "")
            Text(currentWeather.name ?? "")
            Text(currentWeather.weather.first?.main ?? "")
            Text("\(currentWeather.main.temp ?? 0)°")
        }
        .padding()
    }
}
