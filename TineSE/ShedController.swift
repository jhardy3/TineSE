//
//  ShedController.swift
//  Tine
//
//  Created by Jake Hardy on 3/22/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import Foundation
import UIKit
// Class will implement functions to control shed posts in area

class ShedController {
    
    // MARK: - Post Creation and deletion ( modification )
    
    // Create new shed
    static func createShed(image: UIImage, hunterIdentifier: String, shedMessage: String?, completion: (success: Bool, shed: Shed?) -> Void) {
        
        // guard for current hunter or complete false and return
        guard var currentHunter = HunterController.sharedInstance.currentHunter else { completion(success: false, shed: nil) ; return }
        
        // Upload the image to S3 and receive a specific url back if successful
        PhotoController.sharedInstance.uploadImageToS3(image) { (url) -> () in
            
            // Check for url
            if let url = url {
                
                // If URL is present instantiate a Shed and save it.
                var shed = Shed(hunterID: hunterIdentifier, imageID: url, username: currentHunter.username,shedMessage: shedMessage)
                shed.save()
                
                // Check for obviously present identifier
                guard let shedID = shed.identifier else { completion(success: false, shed: nil) ; return }
                
                // Add Shed ID to currentHunters Shed IDs and save it
                currentHunter.shedIDs.append(shedID)
                currentHunter.save()
                
                // Complete true
                completion(success: true, shed: shed)
            } else {
                
                // If url is not present complete false
                completion(success: false, shed: nil)
            }
        }
    }
    
    // Delete post
    static func deleteShed(shed : Shed) {
        
        // Guard for current hunter and shed ID or return nil
        guard let currentHunter = HunterController.sharedInstance.currentHunter, shedID = shed.identifier else { return }
        
        // Create an index of removal to hold possible ID
        var indexOfRemoval: Int?
        
        
        // For all of the shedIDs in the current hunters shedIDs array, if one of the IDs matches the ID passed in save the index
        for index in 0..<currentHunter.shedIDs.count {
            if currentHunter.shedIDs[index] == shedID {
                indexOfRemoval = index
            }
        }
        
        // If an index is saved remove the shed ID at that index
        if let indexOfRemoval = indexOfRemoval {
            currentHunter.shedIDs.removeAtIndex(indexOfRemoval)
        }
        
        // Delete the shed from firebase
        shed.delete()
    }
    
    // Modify post
    
    // MARK: - Fetch posts
    
    // fetch posts in 50 mile radius (observe)
    
    // fetch post based on identifier
    static func fetchShed(identifier: String, completion:(shed: Shed?) -> Void) {
        
        // Hit firebase at the shed endpoint with the passed in identifier
        FirebaseController.dataAtEndPoint("/shed/\(identifier)") { (data) -> Void in
            
            // guard for data as json object or complete without shed
            guard let shedJson = data as? [String : AnyObject] else { completion(shed: nil) ; return }
            
            // if shed can be constructed from json complete with shed
            if let shed = Shed(json: shedJson, identifier: identifier) {
                completion(shed: shed)
                
            } else {
                
                // If shed cannot be constructed return nil
                completion(shed: nil)
            }
        }
    }
    
    // fetch posts based on users tracking list (observe)
    static func fetchSheds(completion:(shedIDs: [String]) -> Void) {
        
        // Create postsIDs array to hold all shedIDs retrieved
        var postsIDs = [String]()
        
        // Create a group to keep async calls in order
        let group = dispatch_group_create()
        
        // Guard for current hunter or complete with empty array
        guard let currentHunter = HunterController.sharedInstance.currentHunter else { completion(shedIDs: []) ; return }
        
        // for each ID ping group and hit firebase at hunter endpoint
        for id in currentHunter.trackingIDs {
            dispatch_group_enter(group)
            
            // Grab data from firebase
            FirebaseController.dataAtEndPoint("/hunter/\(id)", completion: { (data) -> Void in
                
                // if data is present, grab posts dictionary and append key to post IDs array
                if let data = data, let postsDic = data["shedIDsKey"] as? [String : AnyObject] {
                    postsIDs.appendContentsOf(postsDic.keys)
                }
                
                // Leave the loop and notify group
                dispatch_group_leave(group)
            })
        }
        
        // Once all async calls have finished complete with postsIDs
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            completion(shedIDs: postsIDs)
        }
    }
    
    // Fetch Sheds for Timeline
    static func fetchShedsForTineline(completion:(sheds: [Shed]) -> Void) {
        
        // Create a sheds string array which will hold shed IDs and a shedsToDisplay array that will hold the actual sheds
        var sheds = [String]()
        var shedsToDisplay = [Shed]()
        
        // Create a group to keep async calls in order
        let groupOne = dispatch_group_create()
        
        
        // Fetch all sheds from the current hunters tracking list ( enter group to halt operation and  leave group once sheds are fetched
        dispatch_group_enter(groupOne)
        ShedController.fetchSheds { (shedIDs) -> Void in
            
            // sheds equal returned shedIDs
            sheds = shedIDs
            dispatch_group_leave(groupOne)
        }
        
        
        
        // Once sheds have been fetched notify dispatch and carry out Actual shed Fetching
        dispatch_group_notify(groupOne, dispatch_get_main_queue()) { () -> Void in
            
            // Guard for current Hunter and append contens of current hunters shed Ids to sheds array ( This is necessary because personal sheds are 
            // left out of previous fetch sheds call)
            guard let currentHunter = HunterController.sharedInstance.currentHunter else { return }
            sheds.appendContentsOf(currentHunter.shedIDs)
            
            // Create dispatch group to keep async calls in queue
            let groupTwo = dispatch_group_create()
            
            
            // For all shedIDs in sheds enter group and fetch shed from firebase
            for index in 0..<sheds.count {
                dispatch_group_enter(groupTwo)
                
                // Only grab 100 sheds
                if index <= 200 {
                    ShedController.fetchShed(sheds[index], completion: { (shed) -> Void in
                        
                        // If shed is returned append shed to shedsToDisplayArray
                        if let shed = shed {
                            shedsToDisplay.append(shed)
                        }
                        
                        // Notify dispatch that call has ended
                        dispatch_group_leave(groupTwo)
                    })
                    
                } else {
                    
                    // notify dispatch group even if shed returns nil
                    dispatch_group_leave(groupTwo)
                }
            }
            
            // once async calls finish return with shedsToDisplay array
            dispatch_group_notify(groupTwo, dispatch_get_main_queue(), { () -> Void in
                completion(sheds: shedsToDisplay)
            })
        }
    }

    // MARK: - Comment Functionality
    
    // add comment
    static func addComment(imageIdentifier: String, hunterIdentifier: String, bodyText: String, var shed: Shed, completion: (comment: Comment?) -> Void) {
        
        // Construct comment based on passed in parameters and save comment to Firebase
        var comment = Comment(bodyText: bodyText, imageIdentifier: imageIdentifier, hunterIdentifier: hunterIdentifier)
        comment.save()
        
        // Guard for comment identifier or complete nil
        guard let commentID = comment.identifier else { completion(comment: nil) ; return }
        
        // Append message IF to shed message Identifier array and save shed to firebase
        shed.messageIdentifiers.append(commentID)
        shed.save()
        
        // Complete with comment
        completion(comment: comment)
        
    }
    
    // delete comment
    static func deleteComment(comment: Comment, shedID: String) {
        
        // Guard for comment ID or return
        guard let commentID = comment.identifier else { return }
        
        // Fetch shed for ID removal
        fetchShed(shedID) { (shed) -> Void in
            
            // Check for shed or return
            guard let shed = shed else { return }
            
            // Construct index of removal for possible index
            var indexOfRemoval: Int?
            
            // check all message IDs in message identifiers array and if there is a match set index of removal
            for index in 0..<shed.messageIdentifiers.count {
                if shed.messageIdentifiers[index] == commentID {
                    indexOfRemoval = index
                }
            }
            
            // If index of removal exists, remove ID and delete comment from firebase
            if let indexOfRemoval = indexOfRemoval {
                shed.messageIdentifiers.removeAtIndex(indexOfRemoval)
                comment.delete()
            }
        }
    }
    
    // retrieve comments
    static func fetchComments(commentIDs: [String], completion: (comments : [Comment]) -> Void) {
        // Create an array to hold constructed comments
        var commentArray = [Comment]()
        
        // Create group to keep async calls in order
        let group = dispatch_group_create()
        
        // for each comment in passed in array, ping firebase and pull down comment
        for commentID in commentIDs {
            dispatch_group_enter(group)
            
            // Hit firebased at comment endpoint with comment ID and grab comment JSON
            FirebaseController.dataAtEndPoint("/comment/\(commentID)", completion: { (data) -> Void in
                
                // Guard for commentJSON from data or complete emtpy array
                guard let commentJSON = data as? [String : AnyObject] else { completion(comments: []) ; return }
                
                // If comment is instantiated add to commentArray
                if let comment = Comment(json: commentJSON, identifier: commentID) {
                    commentArray.append(comment)
                }
                
                // Notify dispatch end of call
                dispatch_group_leave(group)
            })
        }
        
        // Once all async calls complete, notify dispatch and complete with commentArray
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            completion(comments: commentArray)
        }
    }
    
    // MARK: - Post specific alterations
    
    // Order posts based on time
    
    // Order comments based on time
    
}