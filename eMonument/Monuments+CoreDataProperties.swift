//
//  Monuments+CoreDataProperties.swift
//  eMonument
//
//  Created by VIGUIER Julien on 10/01/2019.
//  Copyright © 2019 VIGUIER Julien. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit
import Contacts

extension Monuments: MKAnnotation, Encodable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Monuments> {
        return NSFetchRequest<Monuments>(entityName: "Monuments")
    }

    @NSManaged public var title: String?
    @NSManaged public var locationName: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    
    @NSManaged public var coordinate: CLLocationCoordinate2D
    
    convenience init(title: String, locationName: String, latitude: Double, longitude: Double) {
        self.init()
        self.title = title
        self.locationName = locationName
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var subtitle: String? {
        return locationName
    }
    
    private enum CodingKeys: String, CodingKey { case title, locationName, latitude, longitude, coordinate }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(locationName, forKey: .locationName)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}
