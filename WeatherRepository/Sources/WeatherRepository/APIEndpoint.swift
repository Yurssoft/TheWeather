//
//  File.swift
//  
//
//  Created by W on 3/8/23.
//

import Foundation
import CoreLocation

extension WeatherRepository {
    
    final class APIEndpoint {
        private static let APIToken = "98e994285c7095395fda4290f182eed8"
        static func geolocationEndpoint(for place: String) -> String {
            "http://api.openweathermap.org/geo/1.0/direct?q=\(place)&limit=10&appid=\(APIToken)"
        }
        
        static func weatherEndpoint(for coordinate: CLLocationCoordinate2D) -> String {
            "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(APIToken)"
        }
    }
}
