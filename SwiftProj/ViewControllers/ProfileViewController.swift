//
//  ProfileViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 18/6/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var loginBttn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonPressed(_ sender: Any) {
        signOut()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            //let navController = UINavigationController(rootViewController: startScreenViewController())
            let homeViewController = (self.storyboard?.instantiateViewController(identifier: "WelcomeController"))
            self.view.window?.rootViewController = homeViewController
            self.present(homeViewController!, animated: true, completion: nil)
            print("Logout Button Pressed")

        } catch let error {
            print("Failed to sign out with error...", error)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
