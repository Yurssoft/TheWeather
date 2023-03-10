import SwiftUI
import ImageManager

struct ContentView: View {
    @ObservedObject var viewModel: AppViewModel

    public init(viewModel: AppViewModel) {
      self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CachedImage(urlString: viewModel.currentWeather?.weather.first?.iconURLString ?? "")
                Text(viewModel.currentWeather?.name ?? "")
                Text(viewModel.currentWeather?.weather.first?.main ?? "")
                Text("\(viewModel.currentWeather?.main.temp ?? 0)°")
            }
            .padding()
            .navigationBarTitle("The Weather")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: AppViewModel(weatherRepository: .successSequence))
    }
}
