//
//  ProfileViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 18/6/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class ProfileViewController: UIViewController {

    @IBOutlet weak var loginBttn: UIBarButtonItem!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var username: UILabel!
    var userList : [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        var currentuser = Auth.auth().currentUser
        var currentusername = ""
        for i in userList{
            if i.uid == currentuser?.uid{
                currentusername = i.username
            }
        }
        username.text = currentusername
        imageview.layer.cornerRadius = 64
        imageview.layer.borderColor = UIColor.systemRed.cgColor
        imageview.layer.borderWidth = 1;
        //imageview.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        // Do any additional setup after loading the view.
    }
    @IBAction func buttonPressed(_ sender: Any) {
        signOut()
    }
    
    func signOut() { // sign the user out of the acc
        GIDSignIn.sharedInstance()?.signOut() // Sign out in case of Google Acc
        do { // Sign out for normal email acc
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
    func loaduser()
       {

       DataManager.loadUsers() {
           userListFromFirestore in
       // This is a closure. //
       // This block of codes is executed when the
       // async loading from Firestore is complete.
       // What it is to reassigned the new list loaded
       // from Firestore.
       
           self.userList = userListFromFirestore
       // Once done, call on the Table View to reload // all its contents
           }
    }
}
