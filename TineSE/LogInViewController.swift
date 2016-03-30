//
//  logInViewController.swift
//  Tine
//
//  Created by Jake Hardy on 3/23/16.
//  Copyright © 2016 NSDesert. All rights reserved.
//

import UIKit

class logInViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Class Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
        
        self.view.backgroundColor = UIColor.desertFloorTan()
        
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
    
    // Signs a user up
    @IBAction func signUpTapped(sender: UIButton) {
        
        emailTextField.hidden = false
        passwordTextField.hidden = false
        usernameTextField.hidden = false
        
        // Guard for username, email and password or return
        guard let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        // If parameters are satisfied create a new hunter
        HunterController.createHunter(username, email: email, password: password) { (success) -> Void in
            
            // If successful perform segue to tineline
            if success {
                self.performSegueWithIdentifier("loggedIn", sender: self)
            }
        }
    }

    // Signs a user in
    @IBAction func signInTapped(sender: UIButton) {
        
        emailTextField.hidden = false
        passwordTextField.hidden = false
        
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
    
    func setupTextFields() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        usernameTextField.hidden = true
        emailTextField.hidden = true
        passwordTextField.hidden = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
