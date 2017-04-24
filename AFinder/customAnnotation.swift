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
    var name: String!
    var date: String!
    
    var stacks: [String]!
    var pinTintColor: UIColor?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
