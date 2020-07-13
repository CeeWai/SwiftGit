//
//  createprojectViewController.swift
//  Taskr
//
//  Created by Sebastian on 27/6/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import UIKit
import FirebaseAuth
class createprojectViewController:
UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var titlefield: UITextField!
    @IBOutlet var descriptionfield: UITextView!
    @IBOutlet var createBtn: UIButton!
    @IBOutlet var navBar: UINavigationItem!
    

    
    var newproject : Project = Project(projectId: 0, projectName: "", projectLeader: "", projectDescription: "", imageName: "")
    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
        if self.title == "Create Project"{
            self.descriptionfield.layer.borderColor = UIColor.lightGray.cgColor
            self.descriptionfield.layer.borderWidth = 2.0
            let bottomline = CALayer()
            bottomline.frame = CGRect(x:0,y:titlefield.frame.height - 2, width: titlefield.frame.width,height: 2)
            bottomline.backgroundColor =		 UIColor.systemRed.cgColor
            titlefield.borderStyle = .none
            titlefield.layer.addSublayer(bottomline)
            descriptionfield.layer.borderWidth = 2;
            descriptionfield.layer.cornerRadius = 7
            descriptionfield.layer.borderColor = UIColor.systemRed.cgColor
            createBtn.layer.borderWidth = 2;
            createBtn.layer.cornerRadius = 7
            createBtn.layer.borderColor = UIColor.systemRed.cgColor

        }
    
    }

    @IBAction func onclickcreate(_ sender: Any) {
        let image : UIImage = UIImage(named: "enchroma-green")!
        let imagedata:NSData = image.pngData()! as NSData
        let strBase64 = imagedata.base64EncodedString(options: .lineLength64Characters)
        //let currentuser = Auth.auth().currentUser
        newproject =  Project(projectId: 0, projectName: titlefield.text!, projectLeader: "bob", projectDescription: descriptionfield.text!, imageName: strBase64)
    }
    
    override func prepare(for segue: UIStoryboardSegue,
    sender: Any?){
    if(segue.identifier == "passproject")
     {
    let detailViewController = segue.destination as! createproject2ViewController
     detailViewController.projectitem = newproject
    }
     
}
     
    
}
