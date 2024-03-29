import Combine
import CoreLocation

extension LocationClient {
    public static var chicago = CLLocation(latitude: 41.8755616, longitude: -87.6244212)
    public static var authorizedWhenInUseSequence: Self {
        let subject = PassthroughSubject<DelegateEvent, Never>()
        
        return Self(
            authorizationStatus: { .authorizedWhenInUse },
            requestWhenInUseAuthorization: { },
            requestLocation: { subject.send(.didUpdateLocations([chicago])) },
            delegate: subject.eraseToAnyPublisher()
        )
    }
    
    public static var notDeterminedSequence: Self {
        var status = CLAuthorizationStatus.notDetermined
        let subject = PassthroughSubject<DelegateEvent, Never>()
        
        return Self(
            authorizationStatus: { status },
            requestWhenInUseAuthorization: {
                status = .authorizedWhenInUse
                subject.send(.didChangeAuthorization(status))
            },
            requestLocation: { subject.send(.didUpdateLocations([CLLocation()])) },
            delegate: subject.eraseToAnyPublisher()
        )
    }
}
