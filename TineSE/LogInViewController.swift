//
//  logInViewController.swift
//  Tine
//
//  Created by Jake Hardy on 3/23/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import UIKit

enum LogInMode {
    case LogIn
    case SignUp
}

class logInViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var toggleModeButton: UIButton!
    @IBOutlet weak var loadImageView: UIImageView!
    @IBOutlet weak var logInImageView: UIImageView!
    @IBOutlet weak var logInView: UIView!
    
    var blurEffect: UIVisualEffectView?
    
    var logInMode = LogInMode.LogIn {
        didSet {
            displayBasedOnViewMode()
        }
    }
    
    // MARK: - Class Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadImageView.image = self.loadImageView.image?.imageWithColor(UIColor.hunterOrange())
        self.loadImageView.hidden = true
        displayBasedOnViewMode()
        setupTextFields()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if HunterController.sharedInstance.currentHunter != nil {
            self.performSegueWithIdentifier("loggedIn", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action Functions
    
    @IBAction func proceedButtonTapped(sender: UIButton) {
        switch logInMode {
        case .LogIn:
            signIn()
        case .SignUp:
            signUp()
        }
    }
    
    @IBAction func toggleModeButtonTapped(sender: UIButton) {
        switch logInMode {
        case .LogIn:
            logInMode = .SignUp
            
        case .SignUp:
            logInMode = .LogIn
        }
    }
    
    func blurImageBackground(item: AnyObject) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.4
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        item.addSubview(blurEffectView)
        self.blurEffect = blurEffectView
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
        
        self.loadImageView.layer.addAnimation(rotateAnimation, forKey: "shake")
        self.logInView.hidden = true
        textFieldShouldReturn(self.passwordTextField)
    }
    
    func endAnimation() {
        
        self.loadImageView.layer.removeAnimationForKey("shake")
        self.loadImageView.hidden = true
        self.logInView.hidden = false
        if let blurEffect = blurEffect {
            blurEffect.removeFromSuperview()
        }
    }
    
    
    func signIn() {
        // Guard for email and password or return
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        if checkForEmptiness(email) {
            errorAlert([], addCancel: false, addMessage: "Email is empty!")
            return
        }
        
        if checkForEmptiness(password) {
            errorAlert([], addCancel: false, addMessage: "Password is empty")
            return
        }
        
        // authenticate hunter with firebase
        self.loadImageView.hidden = false
        createAnimation()
        HunterController.authenticateHunter(email, password: password) { (success) -> Void in
            // If successful perform segue to tineline
            
            self.endAnimation()
            if success {
                self.performSegueWithIdentifier("loggedIn", sender: self)
            } else {
                self.errorAlert([], addCancel: false, addMessage: "Incorrect Email Or Password")
                return
            }
        }
    }
    
    func signUp() {
        // Guard for username, email and password or return
        guard let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text where username.isEmpty == false else { return }
        
        
        
        if checkForEmptiness(username) {
            errorAlert([], addCancel: false, addMessage: "A hunter with no name is already in use")
            return
        }
        
        if checkForEmptiness(email) {
            errorAlert([], addCancel: false, addMessage: "Email is empty!")
            return
        }
        
        if checkForEmptiness(password) {
            errorAlert([], addCancel: false, addMessage: "Password is empty")
            return
        }
        
        
        
        
        createAnimation()
        
        let group = dispatch_group_create()
        
        dispatch_group_enter(group)
        HunterController.fetchAllHunters { (hunters) in
            for hunterName in hunters {
                if username == hunterName.username {
                    self.errorAlert([], addCancel: false, addMessage: "A hunter with that username already exists")
                    self.endAnimation()
                    return
                }
            }
            dispatch_group_leave(group)
        }
        
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            // If parameters are satisfied create a new hunter
            HunterController.createHunter(username, email: email, password: password) { (success) -> Void in
                
                self.endAnimation()
                // If successful perform segue to tineline
                if success {
                    self.performSegueWithIdentifier("loggedIn", sender: self)
                } else {
                    self.errorAlert([], addCancel: false, addMessage: "Something went wrong")
                    return
                }
            }
            
        }
        
    }
    
    func checkForEmptiness(string: String) -> Bool {
        var test = ""
        for character in string.characters {
            if character != " " {
                test.append(character)
            }
        }
        return test.isEmpty
        
    }
    
    func displayBasedOnViewMode() {
        if self.logInMode == .LogIn {
            usernameTextField.hidden = true
            emailTextField.hidden = false
            passwordTextField.hidden = false
            proceedButton.setTitle("Log In", forState: .Normal)
            toggleModeButton.setTitle("Need an account?", forState: .Normal)
        } else {
            usernameTextField.hidden = false
            emailTextField.hidden = false
            passwordTextField.hidden = false
            proceedButton.setTitle("Sign Up", forState: .Normal)
            toggleModeButton.setTitle("Have an account already?", forState: .Normal)
        }
    }
    
    func setupTextFields() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
