//
//  addroleViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 30/6/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class addroleViewController: UIViewController {

    @IBOutlet var rolenamefield: UITextField!
    @IBOutlet var manageowntaskyes: UIButton!
    @IBOutlet var manageowntaskno: UIButton!
    @IBOutlet var removealltaskyes: UIButton!
    @IBOutlet var removealltaskno: UIButton!
    @IBOutlet var editalltaskyes: UIButton!
    @IBOutlet var editalltaskno: UIButton!
    @IBOutlet var invitememberyes: UIButton!
    @IBOutlet var invitememberno: UIButton!
    @IBOutlet var removememberyes: UIButton!
    @IBOutlet var removememberno: UIButton!
    @IBOutlet var manageprojectyes: UIButton!
    @IBOutlet var manageprojectno: UIButton!
    @IBOutlet var createrole: UIButton!
    var projectItem : Project?
    var rolename=""
    var manageowntask=1
    var removealltask=1
    var editalltask=1
    var invitemember=1
    var removemember=1
    var manageproject=1
    override func viewDidAppear(_ animated: Bool) {
            self.navigationController?.isNavigationBarHidden=true
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden=true
        let bottomline = CALayer()
                   bottomline.frame = CGRect(x:0,y:rolenamefield.frame.height - 2, width: rolenamefield.frame.width,height: 2)
                   bottomline.backgroundColor =         UIColor.systemRed.cgColor
                   rolenamefield.borderStyle = .none
                   rolenamefield.layer.addSublayer(bottomline)
        rolenamefield.attributedPlaceholder = NSAttributedString(string: "Role Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemRed])
        manageowntaskyes.layer.borderColor = UIColor.systemRed.cgColor
        manageowntaskno.layer.borderColor = UIColor.systemRed.cgColor
        manageowntaskyes.layer.borderWidth = 2
        removealltaskyes.layer.borderColor = UIColor.systemRed.cgColor
        removealltaskno.layer.borderColor = UIColor.systemRed.cgColor
        removealltaskyes.layer.borderWidth = 2
        editalltaskyes.layer.borderColor = UIColor.systemRed.cgColor
        editalltaskno.layer.borderColor = UIColor.systemRed.cgColor
        editalltaskyes.layer.borderWidth = 2
        invitememberyes.layer.borderColor = UIColor.systemRed.cgColor
        invitememberno.layer.borderColor = UIColor.systemRed.cgColor
        invitememberyes.layer.borderWidth = 2
        removememberyes.layer.borderColor = UIColor.systemRed.cgColor
        removememberno.layer.borderColor = UIColor.systemRed.cgColor
        removememberyes.layer.borderWidth = 2
        manageprojectyes.layer.borderColor = UIColor.systemRed.cgColor
        manageprojectno.layer.borderColor = UIColor.systemRed.cgColor
        manageprojectyes.layer.borderWidth = 2
        createrole.layer.borderWidth = 2;
        createrole.layer.cornerRadius = 7
        createrole.layer.borderColor = UIColor.systemRed.cgColor
        manageowntaskyes.layer.cornerRadius=5
        manageowntaskno.layer.cornerRadius=5
        removealltaskyes.layer.cornerRadius=5
        removealltaskno.layer.cornerRadius=5
        editalltaskyes.layer.cornerRadius=5
        editalltaskno.layer.cornerRadius=5
        invitememberyes.layer.cornerRadius=5
        invitememberno.layer.cornerRadius=5
        removememberyes.layer.cornerRadius=5
        removememberno.layer.cornerRadius=5
        manageprojectyes.layer.cornerRadius=5
        manageprojectno.layer.cornerRadius=5
    }
    

    @IBAction func pressedmanageowntaskyes(_ sender: Any) {
        manageowntaskyes.layer.borderWidth = 2
        manageowntaskno.layer.borderWidth = 0
        manageowntask=1
    }
    
    @IBAction func pressedmanageowntaskno(_ sender: Any) {
        manageowntaskyes.layer.borderWidth = 0
        manageowntaskno.layer.borderWidth = 2
        manageowntask=0
    }
    
    @IBAction func pressedremovealltaskyes(_ sender: Any) {
        removealltaskyes.layer.borderWidth = 2
        removealltaskno.layer.borderWidth = 0
        removealltask=1
    }
    
    
    @IBAction func pressedremovealltaskno(_ sender: Any) {
        removealltaskyes.layer.borderWidth = 0
        removealltaskno.layer.borderWidth = 2
        removealltask=0
    }
    
    @IBAction func pressededitalltaskyes(_ sender: Any) {
        editalltaskyes.layer.borderWidth = 2
        editalltaskno.layer.borderWidth = 0
        editalltask=1
    }
    @IBAction func pressededitalltaskno(_ sender: Any) {
        editalltaskyes.layer.borderWidth = 0
        editalltaskno.layer.borderWidth = 2
        editalltask=0
    }
    
    @IBAction func pressedinvitememberyes(_ sender: Any) {
        invitememberyes.layer.borderWidth = 2
        invitememberno.layer.borderWidth = 0
        invitemember=1
    }
    
    @IBAction func pressedinvitememberno(_ sender: Any) {
        invitememberyes.layer.borderWidth = 0
        invitememberno.layer.borderWidth = 2
        invitemember=0
    }
    
    @IBAction func pressedremovememberyes(_ sender: Any) {
        removememberyes.layer.borderWidth = 2
        removememberno.layer.borderWidth = 0
        removemember=1
    }
    
    @IBAction func pressedremovememberno(_ sender: Any) {
        removememberyes.layer.borderWidth = 0
        removememberno.layer.borderWidth = 2
        removemember=0
    }
    
    @IBAction func pressedmanageprojectyes(_ sender: Any) {
        manageprojectyes.layer.borderWidth = 2
        manageprojectno.layer.borderWidth = 0
        manageproject=1
    }
    
    @IBAction func pressedmanageprojectno(_ sender: Any) {
        manageprojectyes.layer.borderWidth = 0
        manageprojectno.layer.borderWidth = 2
        manageproject=0
    }
    @IBAction func pressedcreaterole(_ sender: Any) {
        rolename = rolenamefield.text!
        
        var newrole : Role = Role(roleid: 0, rolename: rolename, projectid: projectItem!.projectId, manageowntask: manageowntask, removealltask: removealltask, editalltask: editalltask, invitemember: invitemember, removemember: removemember, manageproject: manageproject)
        RoleDataManager.insertOrReplaceMovie(role: newrole)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue,
        sender: Any?){
          if(segue.identifier == "seguetomemberview")
                  {
                 let detailViewController = segue.destination as!
                  MemberViewController
                     detailViewController.projectItem = self.projectItem
                 }
            if(segue.identifier == "seguetomemberview2")
                         {
                        let detailViewController = segue.destination as!
                         MemberViewController
                            detailViewController.projectItem = self.projectItem
                        }
    }

}
