//
//  LocationController.swift
//  Tine
//
//  Created by Jake Hardy on 3/22/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import Firebase
import CoreLocation
//import GeoFire


// Class handles all actions of locational importance

class LocationController {
    
    // MARK: - Location Services
    
    static let geoFire = GeoFire(firebaseRef: FirebaseController.firebase.childByAppendingPath("/location/"))
    
    
    static func setLocation(shedID: String, location: CLLocation, completion: (success: Bool) -> Void) {
        
        self.geoFire.setLocation(location, forKey: shedID) { (error) -> Void in
            if let error = error {
                completion(success: false)
                print(error)
                return
            }
            completion(success: true)
        }
        
    }
    
    static func queryAroundMe(center: CLLocation, completion: (shedIDs: [String]) -> Void) {
        
        var shedIDs = [String]()
    
        let circleQuery = geoFire.queryAtLocation(center, withRadius: 80.0)
        circleQuery.observeEventType(.KeyEntered, withBlock: { (string, location) -> Void in
            shedIDs.append(string)
        })
        
    }
    
}