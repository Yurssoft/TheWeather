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
    
    private var viewModel: DetailsViewController.ViewModel! {
        didSet {
            setupBindings() // controller inits faster, so we wait for model to arrive
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(image)
        view.addSubview(label)
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
