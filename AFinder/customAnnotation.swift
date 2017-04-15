//
//  customAnnotation.swift
//  AFinder
//
//  Created by Berksu on 14/04/2017.
//  Copyright © 2017 Berksu Kısmet. All rights reserved.
//

import MapKit

class customAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var phone: String!
    var name: String!
    var address: String!
    var image: UIImage!
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
