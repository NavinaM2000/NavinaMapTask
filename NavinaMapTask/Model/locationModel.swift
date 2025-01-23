//
//  locationModel.swift
//  MapView-UpdateCurrentLocation
//
//  Created by selvarani on 21/01/25.
//  Copyright © 2025 Shiju. All rights reserved.
//




import Foundation
import CoreLocation

struct Task: Codable {
    let id: UUID
    var title: String
    var description: String
     var latitude: Double
     var longitude: Double
    
    var location: CLLocationCoordinate2D {
        get {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
    init(id: UUID = UUID(), title: String, description: String, location: CLLocationCoordinate2D) {
        self.id = id
        self.title = title
        self.description = description
        self.latitude = location.latitude
        self.longitude = location.longitude
    }
}

