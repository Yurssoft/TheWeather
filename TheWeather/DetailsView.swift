import Foundation
import UIKit
import Combine
import SwiftUI
import WeatherRepository
import Kingfisher

typealias UIViewControllerType = DetailsViewController

struct DetailsViewControllerSwiftUI: UIViewControllerRepresentable {
    let weather: WeatherRepository.CurrentWeatherResponse
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let details = DetailsViewController()
        let model = DetailsViewController.ViewModel(weather: weather)
        details.viewModel = model
        return details
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

extension DetailsViewController {
    
    struct DetailsData {
        let name: String
        let icon: URL
        //...
    }
    
    final class ViewModel {
        @Published private(set) var detailsData = DetailsData(name: "", icon: URL(string: "https://www.google.com/")!) // fix  by adding state
        private let weather: WeatherRepository.CurrentWeatherResponse
        init(weather: WeatherRepository.CurrentWeatherResponse) {
            self.weather = weather
            fetchDetails()
        }
        
        func fetchDetails() {
            //imagine network request here...
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                detailsData = DetailsData(name: weather.name, icon: URL(string: weather.weather.first!.iconURLString)!)
            }
        }
    }
}

final class DetailsViewController: UIViewController {
    private var subscriptions = Set<AnyCancellable>()
    let image = UIImageView()
    let label = UILabel()
    
    var viewModel: DetailsViewController.ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(image)
        view.addSubview(label)
        view.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        // possible to add constraints
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.$detailsData
            .sink { [unowned self] data in
                self.image.kf.setImage(with: data.icon) // move to image library and use own extension
                self.label.text = data.name
            }
            .store(in: &subscriptions)
    }
}
