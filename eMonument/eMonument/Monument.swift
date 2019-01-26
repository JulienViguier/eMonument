//
//  Monument.swift
//  eMonument
//
//  Created by VIGUIER Julien on 10/01/2019.
//  Copyright © 2019 VIGUIER Julien. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Monument: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
    }
    
    init?(json: [String: Any]) {
        guard let title = json["title"] as? String,
            let locationName = json["locationName"] as? String,
            let coordinateJSON = json["coordinates"] as? [String: Double],
            let latitude = coordinateJSON["lat"],
            let longitude = coordinateJSON["long"]
            else {
                return nil
        }
        self.title = title
        self.locationName = locationName
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var subtitle: String? {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let address = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: address)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
