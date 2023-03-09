import SwiftUI

@main
struct TheWeatherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: AppViewModel(weatherRepository: .current))
        }
    }
}
