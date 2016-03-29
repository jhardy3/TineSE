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
    
    static private let CHECK_RADIUS_IN_METERS = 80.0
    
    // MARK: - Location Services
    
    // Creates a geofire reference in firebase
    static let geoFire = GeoFire(firebaseRef: FirebaseController.firebase.childByAppendingPath("/location/"))
    
    
    // Function sets a location in firebase. To be called when a shed is successfully created in firebase
    static func setLocation(shedID: String, location: CLLocation, completion: (success: Bool) -> Void) {
        
        // Sets a location where the shed ID is the key (hashable)
        self.geoFire.setLocation(location, forKey: shedID) { (error) -> Void in
            
            // Check for error
            if let error = error {
                completion(success: false)
                print(error)
                return
            }
            
            // If error does not exist complete true
            completion(success: true)
        }
        
        
        
    }
    
    // Checks surrounging area for
    static func queryAroundMe(center: CLLocation, completion: (shedIDs: [String]) -> Void) {
        
        // initiate an array to hold all shedIDs which query will find
        var shedIDs = [String]()
        
        // Create circle query based on current position and meter radius
        // Append shedIDs returned to shedIDs array
        let circleQuery = geoFire.queryAtLocation(center, withRadius: CHECK_RADIUS_IN_METERS)
        circleQuery.observeEventType(.KeyEntered, withBlock: { (string, location) -> Void in
            shedIDs.append(string)
        })
        
    }
    
}