//
//  HunterController.swift
//  Tine
//
//  Created by Jake Hardy on 3/22/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import Foundation

// Class needs to implement functions that will be important for the main functionality of Hunter to Hunter interaction && Hunter to App interaction

class HunterController {
    
    static let sharedInstance = HunterController()
    
    var currentHunter: Hunter?
    
    // MARK: - Authentication && Creation
    
    // Create a new hunter
    static func createHunter(username: String, email: String, password: String, completion: (success: Bool) -> Void) {
        
        // Create a user on firebase end
        FirebaseController.firebase.createUser(email, password: password) { (error, data) -> Void in
            
            // Check for error and if present complete false and return
            if let error = error {
                print(error)
                completion(success: false)
                return
            }
            
            // If successful create Hunter and pass in identifer from authData
            if let authID = data["uid"] as? String {
                var newHunter = Hunter(username: username, identifier: authID)
                
                // Save new Hunter && Assign to sharedInstance. Complete true.
                newHunter.save()
                self.sharedInstance.currentHunter = newHunter
                
                completion(success: true)
            } else {
                
                // Complete false if authData fails
                completion(success: false)
            }
        }
        
    }
    
    // Authenticate a hunter logging in
    static func authenticateHunter(email: String, password: String, completion: (success: Bool) -> Void) {
        
        // Authenticate user on Firebase end
        FirebaseController.firebase.authUser(email, password: password) { (error, authData) -> Void in
            
            // If error is present complete false and return
            if let error = error {
                print(error)
                completion(success: false)
                return
            }
            
            // Grab hunter ID from authData or complete false
            guard let hunterID = authData.uid else { completion(success: false) ; return }
            
            // Fetch hunter asynchonously
            fetchHunterForIdentifier(hunterID, completion: { (hunter) -> Void in
                
                // If hunter is succesfully returned assign sharedInstance and complete true
                if let hunter = hunter {
                    completion(success: true)
                    self.sharedInstance.currentHunter = hunter
                    
                } else {
                    // If hunter is nil complete false
                    completion(success: false)
                }
            })
        }
    }
    
    // Unauthenticate a hunter / logging out
    static func unauthHunter() {
        
        // Check for hunter and save just to be certain all changed data is stored
        guard var hunter = self.sharedInstance.currentHunter else { return }
        hunter.save()
        
        // Call for Firebase to unauth user
        FirebaseController.firebase.unauth()
        self.sharedInstance.currentHunter = nil
    }
    
    // MARK: - Fetch Requests
    
    // Grab a single hunter from firebase using an identifier
    static func fetchHunterForIdentifier(identifier: String, completion: (hunter: Hunter?) -> Void) {
        
        // Grab data at hunter endpoint with specific identifier
        FirebaseController.dataAtEndPoint("/hunter/\(identifier)") { (data) -> Void in
            
            // guard for jsonData or complete nil
            guard let json = data as? [String : AnyObject] else { completion(hunter: nil) ; return }
            
            // if Hunter is initialized successfully complete with new hunter
            if let hunter = Hunter(json: json, identifier: identifier) {
                completion(hunter: hunter)
                
            } else {
                
                // if initialization fails complete nil
                completion(hunter: nil)
            }
            
        }
    }
    
    // Grab multiple hunters from firebase using an array of identifiers
    static func fetchHuntersWithIdentifierArray(identifiers: [String], completion: (hunters: [Hunter]) -> Void) {
        
        // init a hunter array which will eventually hold hunters to be
        var hunterArray = [Hunter]()
        
        // Create a group (because of async calls, an order of completion must be defined)
        let group = dispatch_group_create()
        
        // for each hunter Identifier in the identifiers array, a firebase call is made.
        for hunterID in identifiers {
            
            // Dispatch group is entered
            dispatch_group_enter(group)
            
            // fetch call is made
            fetchHunterForIdentifier(hunterID, completion: { (hunter) -> Void in
                
                // if hunter is not nil hunter is appended to hunterArray
                if let hunter = hunter {
                    hunterArray.append(hunter)
                }
                
                // dispatch group leaves notifying async call is over
                dispatch_group_leave(group)
            })
        }
        
        // Once all async calls finish the completion block is called with the hunterArray
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            completion(hunters: hunterArray)
        }
        
    }
    
    // Fetches all hunters in Firebase
    static func fetchAllHunters(completion: (hunters: [Hunter]) -> Void) {
        
        // grabs all data at hunter endpoint
        FirebaseController.dataAtEndPoint("/hunter/") { (data) -> Void in
            
            // initalizae a huntersArray which will hold all hunters to be
            var huntersArray = [Hunter]()
            
            // guard for json dictionary of hunters or complete with empty array
            guard let arrayOfJSONHunters = data as? [String : AnyObject] else { completion(hunters: []) ; return }
            
            // create a new group to maintain asynchronous order
            let group = dispatch_group_create()
            
            // For each id in JSON array keys group is entered
            for hunterID in arrayOfJSONHunters.keys {
                dispatch_group_enter(group)
                
                // fetch hunter for every ID with Firebase
                fetchHunterForIdentifier(hunterID, completion: { (hunter) -> Void in
                    
                    // if hunter isnt nil, add hunter to hunters array
                    if let hunter = hunter {
                        huntersArray.append(hunter)
                    }
                    
                    // notify group that async call has ended
                    dispatch_group_leave(group)
                })
            }
            
            // once all calls have finished, complete with huntersArray containing all hunters in Firebase
            dispatch_group_notify(group, dispatch_get_main_queue(), { () -> Void in
                completion(hunters: huntersArray)
            })
            
            
        }
    }
    
    // MARK: - Social Interaction Functions
    
    // Hunter track Hunter
    static func hunterTrackHunter(var hunter: Hunter) {
        
        // guard for current hunter, current hunter ID and tracked hunter ID
        guard var currentHunter = HunterController.sharedInstance.currentHunter, let currentHunterID = HunterController.sharedInstance.currentHunter?.identifier, let trackedHunterID = hunter.identifier else { return }
        
        // Add hunter to be tracked to current hunters tracking IDs array. Save Current Hunter
        currentHunter.trackingIDs.append(trackedHunterID)
        currentHunter.save()
        
        // Add current hunter ID to recently tracked hunter's trackedID's array. Save hunter
        hunter.trackedIDs.append(currentHunterID)
        hunter.save()
    }
    
    // Hunter untrack Hunter
    static func hunterUntrackHunter(var hunter: Hunter) {
        
        // check for current hunter, current hunter ID and tracked hunter else return from function
        guard var currentHunter = HunterController.sharedInstance.currentHunter, let currentHunterID = HunterController.sharedInstance.currentHunter?.identifier, let trackedHunter = hunter.identifier else { return }
        
        // If trackingIDs is greater than 0
        if currentHunter.trackingIDs.count > 0 {
            
            // Declare index of removal
            var indexOfRemoval: Int?
            
            // loop through IDs checking for a match, if found set index of removal
            for index in 0..<currentHunter.trackingIDs.count {
                if currentHunter.trackingIDs[index] == trackedHunter {
                    indexOfRemoval = index
                }
            }
            
            // if there exists an index of removal, remove item at index
            if let indexOfRemoval = indexOfRemoval {
                currentHunter.trackingIDs.removeAtIndex(indexOfRemoval)
            }
        }
        
        
        
        
        // if hunter trackedIDs has contents
        if hunter.trackedIDs.count > 0 {
            
            // Deckare new index of removal
            var newIndexOfRemoval: Int?
            
            // for each item in tracked IDs check for match, if match set new index of removal
            for index in 0..<hunter.trackedIDs.count {
                if hunter.trackedIDs[index] == currentHunterID {
                    newIndexOfRemoval = index
                }
            }
            
            // if index exists remove at index
            if let newIndexOfRemoval = newIndexOfRemoval {
                hunter.trackedIDs.removeAtIndex(newIndexOfRemoval)
            }
        }
        
        // Save both objects to firebase with newly altered arrays
        hunter.save()
        currentHunter.save()
    }
    
    // MARK: - Query for leaderboard
    
    // Retrieve hunters ordered by shed count
    
    // Retrieve hunters tracked by current hunter ordered by ShedCount
    
}