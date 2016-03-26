//
//  Shed.swift
//  Tine
//
//  Created by Jake Hardy on 3/22/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import Foundation
import UIKit

class Shed: FirebaseType {
    
    // json dictionary keys
    private let imageKey = "imageIdentifier"
    private let hunterKey = "hunterKey"
    private let messageIdKey = "messagesKey"
    private let usernameKey = "usernameKey"
    private let shedMessageKey = "shedMessage"
    
    // Firebase type identifiers and variables
    var identifier: String?
    var imageIdentifier: String
    var hunterIdentifier: String
    var username: String
    var messageIdentifiers = [String]()
    var shedImage: UIImage?
    var shedMessage: String?
    
    let endpoint = "/shed/"
    
    var jsonValue : [String : AnyObject] {
        return [
            shedMessageKey : shedMessage ?? "",
            usernameKey : username,
            imageKey : imageIdentifier,
            hunterKey : hunterIdentifier,
            messageIdKey : messageIdentifiers.toDic()
        ]
    }
    
    // Firebase Type required initializer
    required init?(json: [String : AnyObject], identifier: String) {
        guard let imageIdentifier = json[imageKey] as? String, username = json[usernameKey] as? String, hunterIdentifier = json[hunterKey] as? String else {
            self.imageIdentifier = ""
            self.hunterIdentifier = ""
            self.messageIdentifiers = []
            self.shedImage = nil
            self.username = ""
            return nil
        }
        
        self.username = username
        self.imageIdentifier = imageIdentifier
        self.hunterIdentifier = hunterIdentifier
        if let messages = json[messageIdKey] as? [String : AnyObject] {
            self.messageIdentifiers = Array(messages.keys)
        }
        
        self.identifier = identifier
        PhotoController.fetchImageAtURL(imageIdentifier) { (image) -> Void in
            self.shedImage = image
        }
        
        if let message = json[shedMessageKey] as? String {
            self.shedMessage = message
        }
    }
    
    // Class Initializer
    init(hunterID: String, imageID: String?, username: String, shedMessage: String?) {
        self.hunterIdentifier = hunterID
        self.imageIdentifier = imageID ?? ""
        self.username = username
        
        if let shedMessage = shedMessage {
            self.shedMessage = shedMessage
        }
    }
}


