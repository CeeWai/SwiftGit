//
//  RegisterViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 24/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var cfmPasswordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var registerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         registerView.layer.shadowColor = UIColor.black.cgColor
        registerView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
         registerView.layer.shadowOpacity = 0.2
        registerView.layer.shadowRadius = 4.0
        registerView.layer.masksToBounds = false
        registerView.layer.cornerRadius = 6
    }
    
    func validateFields() -> String? {
        if usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || cfmPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        //Check if the password is secure
        let cleanedPassword = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

    @IBAction func signUpTapped(_ sender: Any) {
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            // There's something wrong i can feel it, show the error message
            showError(error!)
        } else {
            
            // Create cleaned versions of the data
            let username = usernameField.text!
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    self.showError("Error creating user")
                } else {
                    // User was created successfully, now store the username
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["username": username, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            self.showError("Error. User data not saved. Try again later.")
                        }
                    }
                    //Transition to home screen
                    self.transitionToLogin()
                    
                }
            }

        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToLogin() {
        let homeViewController = (self.storyboard?.instantiateViewController(identifier: "loginController"))
        view.window?.rootViewController = homeViewController
        self.present(homeViewController!, animated: true)
        
    }
}
