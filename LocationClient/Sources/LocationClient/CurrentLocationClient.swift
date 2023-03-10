import Combine
import CoreLocation

extension LocationClient {
    public static var current: Self {
        class Delegate: NSObject, CLLocationManagerDelegate {
            let subject: PassthroughSubject<DelegateEvent, Never>
            
            init(subject: PassthroughSubject<DelegateEvent, Never>) {
                self.subject = subject
            }
            
            func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
                subject.send(.didChangeAuthorization(status))
            }
            
            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                subject.send(.didUpdateLocations(locations))
            }
            
            func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                subject.send(.didFailWithError(error))
            }
        }
        
        let locationManager = CLLocationManager()
        let subject = PassthroughSubject<DelegateEvent, Never>()
        var delegate: Delegate? = Delegate(subject: subject)
        locationManager.delegate = delegate
        
        return Self(
            authorizationStatus: CLLocationManager.authorizationStatus,
            requestWhenInUseAuthorization: locationManager.requestWhenInUseAuthorization,
            requestLocation: locationManager.requestLocation,
            delegate: subject
                .handleEvents(receiveCancel: { delegate = nil })
                .eraseToAnyPublisher()
        )
    }
}
