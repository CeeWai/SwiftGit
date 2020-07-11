//
//  forgotPasswordViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 5/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import FirebaseAuth

class forgotPasswordViewController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func resetPassword(_ sender: Any) {
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" { // Check if input empty
            errorLabel.text = "The email field is empty!"
            errorLabel.alpha = 1
            return
        } else if self.isValidEmail(emailField.text!) == false {
            print("Not a valid email")
            errorLabel.text = "Please enter a valid email."
            errorLabel.alpha = 1
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: emailField.text!) { (err) in // Firebase auth send reset pw
            if err == nil {
                self.errorLabel.text = "Success! We have sent you a password reset email. Please check your inbox for further instructions!"
                self.errorLabel.alpha = 1
            } else {
                self.errorLabel.text = err!.localizedDescription
                self.errorLabel.alpha = 1
                print(err!.localizedDescription)
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool { // Validation for correct email func
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

}
