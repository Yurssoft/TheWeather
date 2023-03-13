import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: AppViewModel
    
    public init(viewModel: AppViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.searchPlace.isEmpty {
                    tileView()
                } else {
                    List {
                        ForEach(viewModel.weatherResults) { place in
                            Button(action: { viewModel.selectPlace(place: place) }) {
                                VStack(alignment: .leading) {
                                    Text(place.name)
                                        .font(.headline)
                                    Text(place.state)
                                    Text(place.country)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("The Weather")
        }
        .searchable(text: $viewModel.searchPlace, placement: .navigationBarDrawer(displayMode: .always), prompt: "Enter City Or Zip")
        .onSubmit(of: .search, viewModel.fetchSearchResults)
        .onChange(of: viewModel.searchPlace) { _ in viewModel.fetchSearchResults() }
        .alert(item: $viewModel.errorText) { text in
            Alert(title: Text(viewModel.errorText?.text ?? ""), message: Text("-"), dismissButton: .default(Text("Got it!")))
        }
        .onAppear(perform: viewModel.onAppear)
    }
    
    @ViewBuilder
    func tileView() -> some View {
        if let weather = viewModel.currentWeather {
            TileView(currentWeather: weather)
        } else {
            Text("Search For Place")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: AppViewModel(weatherRepository: .successSequence, locationClient: .authorizedWhenInUseSequence))
    }
}
