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
//        blurImageBackground(view)
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
        
        // authenticate hunter with firebase
        self.loadImageView.hidden = false
        createAnimation()
        HunterController.authenticateHunter(email, password: password) { (success) -> Void in
            // If successful perform segue to tineline
            
            self.endAnimation()
            if success {
                self.performSegueWithIdentifier("loggedIn", sender: self)
            }
        }
    }
    
    func signUp() {
        // Guard for username, email and password or return
        guard let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text where username.isEmpty == false else { return }
        
        // If parameters are satisfied create a new hunter
        HunterController.createHunter(username, email: email, password: password) { (success) -> Void in
            
            // If successful perform segue to tineline
            if success {
                self.performSegueWithIdentifier("loggedIn", sender: self)
            }
        }
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
    
}
