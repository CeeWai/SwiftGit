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
    @IBOutlet var descriptionfield: UITextField!
    @IBOutlet var createBtn: UIButton!
    @IBOutlet var navBar: UINavigationItem!
    
    @IBOutlet var chooseimage: UIButton!
    var strimage = "";
    
    var newproject : Project = Project(projectId: 0, projectName: "", projectLeader: "",projectLeaderid: "", projectDescription: "", imageName: "")
    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        if self.title == "Create Project"{
            let bottomline = CALayer()
            bottomline.frame = CGRect(x:0,y:titlefield.frame.height - 2, width: titlefield.frame.width,height: 2)
            bottomline.backgroundColor =		 UIColor.systemRed.cgColor
            titlefield.borderStyle = .none
            titlefield.layer.addSublayer(bottomline)
            titlefield.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemRed])

            let bottomline2 = CALayer()
              bottomline2.frame = CGRect(x:0,y:descriptionfield.frame.height - 2, width: descriptionfield.frame.width,height: 2)
              bottomline2.backgroundColor =         UIColor.systemRed.cgColor
              descriptionfield.borderStyle = .none
              descriptionfield.layer.addSublayer(bottomline2)
              descriptionfield.attributedPlaceholder = NSAttributedString(string: "Description", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemRed])
            createBtn.layer.borderWidth = 1;
            createBtn.layer.borderColor = UIColor.systemRed.cgColor
            chooseimage.layer.borderWidth = 1;
            chooseimage.layer.borderColor = UIColor.systemRed.cgColor

        }
    
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        popover.removeFromSuperview()
        if popover.isDescendant(of: view){
            popover.removeFromSuperview()
        }
    }

    
    @IBOutlet var popover: UIView!
    @IBAction func pressedimage(_ sender: Any) {
        self.view.addSubview(popover)
                      let superView = self.view.superview
                      superView!.addSubview(popover)
                      popover.translatesAutoresizingMaskIntoConstraints = false

                      NSLayoutConstraint.activate([

                              // 5
                              NSLayoutConstraint(item: popover, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1.0, constant: 740),

                              // 6
                              NSLayoutConstraint(item: popover, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1.0, constant: 0),

                              // 7
                              popover.heightAnchor.constraint(equalToConstant:102),
                  
                              //8
                              popover.widthAnchor.constraint(equalToConstant: 414)
                          ])
    }
    @IBAction func Pressedcamera(_ sender: Any) {
        let picker = UIImagePickerController()
               picker.delegate = self
               picker.allowsEditing = true
               picker.sourceType = .camera
               self.present(picker,animated: true)
        
    }
    
    @IBAction func pressedgallery(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let chosenImage : UIImage =
        info[.editedImage] as! UIImage
        let image : UIImage = chosenImage
        let imagedata:NSData = image.pngData()! as NSData
        let strBase64 = imagedata.base64EncodedString(options: .lineLength64Characters)
        strimage = strBase64
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(
    _ picker: UIImagePickerController)
    {
    picker.dismiss(animated: true)
        popover.removeFromSuperview()
    }
    @IBAction func onclickcreate(_ sender: Any) {
        let image : UIImage = UIImage(systemName:"photo.fill")!
        let imagedata:NSData = image.pngData()! as NSData
        if strimage == ""{
                  strimage = imagedata.base64EncodedString(options: .lineLength64Characters)
        }
        //let currentuser = Auth.auth().currentUser
        newproject =  Project(projectId: 0, projectName: titlefield.text!, projectLeader: "bob", projectLeaderid: "1nC1S8cngKXT2da4CmaiV2sb4Ia2", projectDescription: descriptionfield.text!, imageName: strimage)
        var recentid = ProjectDataManager.loadrecentindex()
        ProjectgroupDataManager.insertOrReplace(projectgroup: Projectgroup(groupid: 0, projectid: recentid, userid: "1nC1S8cngKXT2da4CmaiV2sb4Ia2", username: "bob", role: "Founder", invited: 1, subscribe: 1))
        RoleDataManager.insertOrReplaceMovie(role: Role(roleid: 0, rolename: "Founder", projectid: recentid, manageowntask: 1, removealltask: 1, editalltask: 1, invitemember: 1, removemember: 1, manageproject: 1))
        RoleDataManager.insertOrReplaceMovie(role: Role(roleid: 0, rolename: "Default", projectid: recentid, manageowntask: 1, removealltask: 0, editalltask: 0, invitemember: 1, removemember: 0, manageproject: 0))
        ProjectDataManager.insertOrReplaceMovie(project: newproject)
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
