//
//  PlaceAnnotation.swift
//  Places
//
//  Created by ShrawanKumar Sharma on 18/04/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
  let coordinate: CLLocationCoordinate2D
  let title: String?
  
  init(location: CLLocationCoordinate2D, title: String) {
    
    self.coordinate = location
    self.title = title
    
    super.init()
  }
}

