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
    
    var logInMode = LogInMode.LogIn {
        didSet {
            displayBasedOnViewMode()
        }
    }
    
    // MARK: - Class Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func signIn() {
        // Guard for email and password or return
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        // authenticate hunter with firebase
        HunterController.authenticateHunter(email, password: password) { (success) -> Void in
            // If successful perform segue to tineline
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
