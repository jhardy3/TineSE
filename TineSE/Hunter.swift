//
//  Hunter.swift
//  Tine
//
//  Created by Jake Hardy on 3/22/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import Foundation

class Hunter: FirebaseType {
    
    // Firebase JSON keys
    private let profileImageKey = "imageIdentifier"
    private let shedIDsKey = "shedIDsKey"
    private let trackingIDsKey = "trackingIDsKey"
    private let trackedIDsKey = "trackedIDsKey"
    private let usernameKey = "usernameKey"
    private let shedCountKey = "shedCountKey"
    private let brownCountKey = "brownCountKey"
    private let whiteCountKey = "whiteCountKey"
    private let chalkCountKey = "chalkCountKey"
    
    // class specific variables
    var username: String
    var shedCount: Int
    var brownCount: Int
    var whiteCount: Int
    var chalkCount: Int
    
    // Firebase type Identifiers
    var identifier: String?
    
    var shedIDs = [String]()
    var trackingIDs = [String]()
    var trackedIDs = [String]()
    
    var profileImageIdentifier: String
    
    let endpoint = "/hunter/"
    
    var jsonValue : [String : AnyObject] {
        return [
            profileImageKey : profileImageIdentifier,
            shedIDsKey : shedIDs.toDic(),
            trackingIDsKey : trackingIDs.toDic(),
            trackedIDsKey : trackedIDs.toDic(),
            usernameKey : username,
            shedCountKey : shedCount,
            brownCountKey : brownCount,
            whiteCountKey : whiteCount,
            chalkCountKey : chalkCount
        ]
        
    }
    
    // Firebasetype required init
    required init?(json: [String : AnyObject], identifier: String) {
        
        guard let username = json[usernameKey] as? String else {
            self.identifier = ""
            self.shedCount = 0
            self.whiteCount = 0
            self.brownCount = 0
            self.chalkCount = 0
            self.profileImageIdentifier = "fdsa"
            self.username = ""
            return nil
        }
        
        self.username = username
        self.identifier = identifier
        self.shedCount = json[shedCountKey] as? Int ?? 0
        self.brownCount = json[brownCountKey] as? Int ?? 0
        self.whiteCount = json[whiteCountKey] as? Int ?? 0
        self.chalkCount = json[chalkCountKey] as? Int ?? 0
        self.profileImageIdentifier = json[profileImageKey] as? String ?? "No Profile Image"
        
        if let sheds = json[shedIDsKey] as? [String : AnyObject] {
            self.shedIDs = Array(sheds.keys)
        }
        
        if let tracking = json[trackingIDsKey] as? [String : AnyObject] {
            self.trackingIDs = Array(tracking.keys)
        }
        
        if let tracked = json[trackedIDsKey] as? [String : AnyObject] {
            self.trackedIDs = Array(tracked.keys)
        }
    }
    
    // Class init
    init(username: String, identifier: String?) {
        self.username = username
        self.shedCount = 0
        self.brownCount = 0
        self.whiteCount = 0
        self.chalkCount = 0
        self.profileImageIdentifier = "No Image yet"
        self.identifier = identifier ?? nil
    }
}


// Exhaustive firebase dictionary saving extension (time saver oh yeaaaaah!)
extension Array {
    func toDic() -> [String : AnyObject] {
        var dicToReturn = [String : AnyObject]()
        for item in self {
            dicToReturn.updateValue(true, forKey: String(item))
        }
        return dicToReturn
    }
    
    
    mutating func deleteItem(item: Element) {
        for index in 0..<self.count {
            if String(self[index]) == String(item) {
                self.removeAtIndex(index)
            }
        }
    }
}