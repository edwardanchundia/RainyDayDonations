//
//  LocationMapAnnotation.swift
//  RainyDayDonation
//
//  Created by Edward Anchundia on 1/11/17.
//  Copyright © 2017 Margaret Ikeda, Simone Grant, Edward Anchundia, Miti Shah. All rights reserved.
//

import UIKit
import Mapbox

class LocationMapAnnotation: NSObject, MGLAnnotation {
    var title: String?
    var subtitle: String?
    var name: String
    var school: String
    var url: String
    var coordinate: CLLocationCoordinate2D
    
    init(name: String, school: String, url: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.school = school
        self.url = url
        self.coordinate = coordinate
    }
}
