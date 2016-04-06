//
//  CameraViewController.swift
//  Tine
//
//  Created by Jake Hardy on 3/23/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import UIKit
import CoreLocation

class CameraViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties
    
    var image: UIImage?
    var locationManager: CLLocationManager!
    var postButtonTapped = false
    var firedOnce = false
    var shedColor = "Brown"
    var shedType = "Deer"
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var shedImageView: UIImageView!
    @IBOutlet weak var shedColorPickerView: UIPickerView!
    @IBOutlet weak var shedTypePickerView: UIPickerView!
    @IBOutlet weak var clearShedButton: UIButton!
    @IBOutlet weak var shedView: UIView!
    @IBOutlet weak var crosshairButton: UIButton!
    
    
    // MARK: - Class Functions
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if image == nil {
            self.clearShedButton.setTitle("Tap Reticle For Camera", forState: .Normal)
            self.shedImageView.image = UIImage(named: "Skull")
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Checks for a current Image ; if not displays camera
        if image == nil && firedOnce == false {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        shedView.layer.borderWidth = 2.0
        shedView.layer.borderColor = UIColor.hunterOrange().CGColor
        self.clearShedButton.layer.opacity = 1.0
        shedColorPickerView.delegate = self
        shedTypePickerView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction Functions
    
    @IBAction func tapGestureTapped(sender: UITapGestureRecognizer) {
        
    }
    
    // Posts a new shed
    @IBAction func postButtonTapped(sender: UIButton) {
        displayCamera()
    }
    
    @IBAction func clearShedTapped(sender: UIButton) {
        
        
        if !postButtonTapped {
            createAnimation()
            postButtonTapped = true
            // Guard for image and hunterID and create a new shed
            if let image = image, hunterID = HunterController.sharedInstance.currentHunter?.identifier {
                ShedController.createShed(image, hunterIdentifier: hunterID, shedMessage: "", shedColor: shedColor, shedType: shedType, completion: { (success, shed) -> Void in
                    
                    // If shed creation is successful remove image and (eventually kick to timeline)
                    if success {
                        if let shedID = shed?.identifier, let location = self.locationManager.location {
                            LocationController.setLocation(shedID, location: location, completion: { (success) -> Void in
                                if success {
                                    print("yay succes posting location")
                                    self.shedImageView.image = UIImage(named: "Skull")
                                } else {
                                    self.errorAlert([], addCancel: false, addMessage: "Problem Finding Location")
                                }
                            })
                        }
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("shedAdded", object: self)
                        self.image = nil
//                        self.clearShedButton.hidden = true
                        self.postButtonTapped = false
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tabBarController?.selectedIndex = 0
                        })
                        
                        return
                    } else {
                        self.errorAlert([], addCancel: false, addMessage: "Failed To Post Shed")
                        self.postButtonTapped = !self.postButtonTapped
                    }
                })
            } else {
                self.postButtonTapped = !self.postButtonTapped
            }
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
        } else {
            errorAlert([], addCancel: false, addMessage: "iPhone Won't Allow Camera Access")
            return
        }
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.shedImageView.image = UIImage(named: "Skull")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Once picture is take function is called
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // Check for valid picture
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            errorAlert([], addCancel: false, addMessage: "Something Went Wrong, Try Again")
            return }
        
        let squareImage = ImageUitilies.cropToSquare(image: image)
        // If valid display image and set image to new image
        self.image = squareImage
        self.shedImageView.image = squareImage
        
        self.clearShedButton.setTitle("Share", forState: .Normal)
        self.clearShedButton.layer.opacity = 1.0
        
        // Dismiss camera view controller
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - TextField Delegate Functions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location found in camera view")
    }
    
    // MARK: - PickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === shedColorPickerView {
            return 4
        } else {
            return 4
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === shedColorPickerView {
            switch row {
            case 0: self.shedColor = "Brown"
                self.shedTypePickerView.hidden = false
            case 1: self.shedColor = "White"
                self.shedTypePickerView.hidden = false
            case 2: self.shedColor = "Chalk"
                self.shedTypePickerView.hidden = false
            default:
                self.shedTypePickerView.hidden = true
                self.shedColor = "Non-Shed"
            }
        } else {
            switch row {
            case 0: self.shedType = "Deer"
            case 1: self.shedType = "Elk"
            case 2: self.shedType = "Moose"
            default: self.shedType = "Non-Shed"
            }
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === shedColorPickerView {
            switch row {
            case 0: return "Brown"
            case 1: return "White"
            case 2: return "Chalk"
            default: return "Non-Shed"
            }
        } else {
            switch row {
            case 0: return "Deer"
            case 1: return "Elk"
            case 2: return "Moose"
            default: return "Non-Shed"
            }
        }
    }
    
    func errorAlert(errorMessages: [String], addCancel: Bool, addMessage: String?) {
        let message = addMessage ?? "Something went Wrong"
        let alertController = UIAlertController(title: "Error!", message: message, preferredStyle: .Alert)
        for errorMessage in errorMessages {
            let alert = UIAlertAction(title: errorMessage, style: .Default, handler: nil)
            alertController.addAction(alert)
        }
        
        if addCancel {
            let cancelAlert = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
            alertController.addAction(cancelAlert)
        } else {
            let cancelAlert = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertController.addAction(cancelAlert)
        }
    }
    
    func createAnimation() {
        
        let bounds = CGRectMake(0, 0, 1, 1)
        
        let rotateAnimation = CAKeyframeAnimation()
        rotateAnimation.keyPath = "position"
        rotateAnimation.path = CGPathCreateWithEllipseInRect(bounds, nil)
        rotateAnimation.duration = 5.0
        rotateAnimation.additive = true
        rotateAnimation.repeatCount = Float.infinity
        rotateAnimation.rotationMode = kCAAnimationRotateAuto
        rotateAnimation.speed = 5.0
        
        self.crosshairButton.layer.addAnimation(rotateAnimation, forKey: "shake")
        
    }
    
    func createThread(function: ()) {
        let queue = dispatch_queue_create("queue", nil)
        
        dispatch_async(queue) {
            function
        }
    }
}
