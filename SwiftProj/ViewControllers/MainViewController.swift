//
//  MainViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 27/6/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import FirebaseAuth

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if Auth.auth().currentUser == nil {
             DispatchQueue.main.async {
                 let welcViewController = (self.storyboard?.instantiateViewController(identifier: "WelcomeController"))
                 self.view.window?.rootViewController = welcViewController
                 self.present(welcViewController!, animated: true)
             }
         }
    }

}
