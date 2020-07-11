//
//  LoginViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 24/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import FirebaseAuth
import AVKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBttn: UIButton!
    @IBOutlet weak var forgotPasswordBttn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var LoginView: UIView!
    var passedFromRegister: Bool?
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        LoginView.layer.shadowColor = UIColor.black.cgColor
        LoginView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        LoginView.layer.shadowOpacity = 0.2
        LoginView.layer.shadowRadius = 4.0
        LoginView.layer.masksToBounds = false
        LoginView.layer.cornerRadius = 6

        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn() //Automatically signs in the user in
    }
    
    // Func for google Sign in
    //
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        

    }
    
    @IBAction func loginPressed(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            // There's something wrong I can feel it, show the error message
            showError(error!)
        } else {
            // Validate Text Fields
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            // Signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    // could not sign in
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                } else {
                    //UserDefaults.standard.set(true, forKey: "ISUSERLOGGEDIN")
                    let user = result?.user

                    if user!.isEmailVerified { // Email validation
                        print("User Is Email Verified")
                        let homeViewController = (self.storyboard?.instantiateViewController(identifier: "MainController"))
                        self.view.window?.rootViewController = homeViewController
                        self.present(homeViewController!, animated: true)
                    } else {
                        print("User is not email verified")
                        self.errorLabel.text = "User email not verified. Please verify your email."
                        self.errorLabel.alpha = 1
                        do {
                            try Auth.auth().signOut()
                            //print("Logged out sucessfully")
                        } catch let error {
                            print("Failed to logout")
                        }
                    }
                }
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //setUpVideo()

    }
    
    func validateFields() -> String? {
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        //Check if the password is secure
        // cleanedPassword = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return nil
    }
    

    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
