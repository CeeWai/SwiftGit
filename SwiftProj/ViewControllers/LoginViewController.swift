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

class LoginViewController: UIViewController {

//    var videoPlayer: AVPlayer?
//    var videoPlayerLayer: AVPlayerLayer?
//    @IBOutlet weak var videoView: UIImageView!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBttn: UIButton!
    @IBOutlet weak var registerBttn: UIButton!
    @IBOutlet weak var forgotPasswordBttn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var LoginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         LoginView.layer.shadowColor = UIColor.black.cgColor
        LoginView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
         LoginView.layer.shadowOpacity = 0.2
        LoginView.layer.shadowRadius = 4.0
        LoginView.layer.masksToBounds = false
        LoginView.layer.cornerRadius = 6
        //LoginView.layer.borderColor = UIColor.gray.cgColor
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        //TODO VALIDATE TEXT FIELD
        let error = validateFields()
        
        if error != nil {
            // There's something wrong i can feel it, show the error message
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
                    
                    let homeViewController = (self.storyboard?.instantiateViewController(identifier: "MainController"))
                    self.view.window?.rootViewController = homeViewController
                    self.present(homeViewController!, animated: true)
                    
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
