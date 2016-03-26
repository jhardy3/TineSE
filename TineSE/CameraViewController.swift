//
//  CameraViewController.swift
//  Tine
//
//  Created by Jake Hardy on 3/23/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import UIKit
import CoreLocation

class CameraViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    var image: UIImage?
    var locationManager: CLLocationManager!
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var shedMessageTextField: UITextField!
    @IBOutlet weak var shedImageView: UIImageView!
    
    // MARK: - Class Functions
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Checks for a current Image ; if not displays camera
        if image == nil {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestLocation()
            displayCamera()
        }
        shedMessageTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction Functions
    
    // Posts a new shed
    @IBAction func postButtonTapped(sender: UIButton) {
        
        // Guard for image and hunterID and create a new shed
        if let image = image, hunterID = HunterController.sharedInstance.currentHunter?.identifier {
            ShedController.createShed(image, hunterIdentifier: hunterID, shedMessage: self.shedMessageTextField.text, completion: { (success, shed) -> Void in
                
                // If shed creation is successful remove image and (eventually kick to timeline)
                if success {
                    if let shedID = shed?.identifier, let location = self.locationManager.location {
                        LocationController.setLocation(shedID, location: location, completion: { (success) -> Void in
                            if success {
                                print("yay succes posting location")
                            }
                        })
                    }
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("shedAdded", object: self)
                    self.image = nil
    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tabBarController?.selectedIndex = 0
                    })
                    
                    return
                }
            })
        }
    }
    
    // MARK: - Camera Functions
    
    // Creates and displays a camera
    func displayCamera() {
        
        // Create a new imagePicker and assign delegate to self
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // Check for camera functionality ; if present imagePick source set to camera and present camera view controller
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    // Once picture is take function is called
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // Check for valid picture
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        let squareImage = ImageUitilies.cropToSquare(image: image)
        // If valid display image and set image to new image
        self.image = squareImage
        self.shedImageView.image = squareImage
        
        // Dismiss camera view controller
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - TextField Delegate Functions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location found in camera view")
    }
    
    
    
}
