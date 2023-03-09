import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: AppViewModel

    public init(viewModel: AppViewModel) {
      self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text(viewModel.currentWeather?.name ?? "")
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
