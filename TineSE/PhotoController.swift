//
//  PhotoController.swift
//  Tine
//
//  Created by Jake Hardy on 3/22/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import Foundation
import AWSS3
import Firebase

// Handles all photo request
class PhotoController {
    
    static let sharedInstance = PhotoController()
    let AWSUrl = "http://s3.amazonaws.com"
    
    func uploadImageToS3(image:UIImage, completion:(String?)->()) {
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        let fileName = NSProcessInfo.processInfo().globallyUniqueString.stringByAppendingString(".jpg")
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(fileName)
        let uploadRequest1 : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
        
        let data = UIImageJPEGRepresentation(image, 0.20)
        data!.writeToURL(fileURL, atomically: true)
        uploadRequest1.bucket = "tine-bucket"
        uploadRequest1.contentType = "image/jpg";
        uploadRequest1.key = fileName
        uploadRequest1.body = fileURL
        
        let task = transferManager.upload(uploadRequest1)
        
        task.continueWithBlock { (task) -> AnyObject! in
            if task.error != nil {
                print("\(self.AWSUrl)/tine-bucket/\(fileName)")
                completion(nil)
                print("Error uploading picture to AWS: \(task.error)")
            } else {
//                print("\(self.AWSUrl)/tine-bucket/\(fileName)")
                completion("\(self.AWSUrl)/tine-bucket/\(fileName)")
//                print("Upload successful")
            }
            return nil
        }
        
    }
    
    static func fetchImageAtURL(imageURLString: String, completion: (image: UIImage?) -> Void) {
        
        if let url = NSURL(string: imageURLString) {
            
            NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                
                if let error = error {
                    print(error.localizedDescription)
                    completion(image: nil)
                }
                
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image: image)
                }
            })
                .resume()
        } else {
            completion(image: nil)
        }
    }
    
}