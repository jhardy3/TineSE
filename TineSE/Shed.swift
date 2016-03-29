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
    private let shedColorKey = "shedColorKey"
    private let shedTypeKey = "shedTypeKey"
    
    // Firebase type identifiers and variables
    var identifier: String?
    var imageIdentifier: String
    var hunterIdentifier: String
    var username: String
    var messageIdentifiers = [String]()
    var shedImage: UIImage?
    var shedMessage: String?
    var shedColor: String
    var shedType: String
    
    let endpoint = "/shed/"
    
    var jsonValue : [String : AnyObject] {
        return [
            shedTypeKey : shedType,
            shedColorKey : shedColor,
            shedMessageKey : shedMessage ?? "",
            usernameKey : username,
            imageKey : imageIdentifier,
            hunterKey : hunterIdentifier,
            messageIdKey : messageIdentifiers.toDic()
        ]
    }
    
    // Firebase Type required initializer
    required init?(json: [String : AnyObject], identifier: String) {
        guard let imageIdentifier = json[imageKey] as? String,
            username = json[usernameKey] as? String,
            hunterIdentifier = json[hunterKey] as? String,
            shedColor = json[shedColorKey] as? String,
            shedType = json[shedTypeKey] as? String
            else {
                self.imageIdentifier = ""
                self.hunterIdentifier = ""
                self.messageIdentifiers = []
                self.shedImage = nil
                self.username = ""
                self.shedType = ""
                self.shedColor = ""
                return nil
        }
        
        
        self.shedType = shedType
        self.shedColor = shedColor
        self.username = username
        self.imageIdentifier = imageIdentifier
        self.hunterIdentifier = hunterIdentifier
        if let messages = json[messageIdKey] as? [String : AnyObject] {
            self.messageIdentifiers = Array(messages.keys)
        }
        
        // When a single shed is initialized, a network call is made and an image is fetched
        self.identifier = identifier
        PhotoController.fetchImageAtURL(imageIdentifier) { (image) -> Void in
            self.shedImage = image
        }
        
        if let message = json[shedMessageKey] as? String {
            self.shedMessage = message
        }
    }
    
    // Class Initializer
    init(hunterID: String, imageID: String?, username: String, shedMessage: String?, shedType: String, shedColor: String) {
        self.hunterIdentifier = hunterID
        self.imageIdentifier = imageID ?? ""
        self.username = username
        self.shedColor = shedColor
        self.shedType = shedType
        
        if let shedMessage = shedMessage {
            self.shedMessage = shedMessage
        }
    }
}


