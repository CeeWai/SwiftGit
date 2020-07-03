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
    
    var rolename=""
    var manageowntask=1
    var removealltask=1
    var editalltask=1
    var invitemember=1
    var removemember=1
    var manageproject=1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manageowntaskyes.layer.borderColor = UIColor.blue.cgColor
        manageowntaskno.layer.borderColor = UIColor.blue.cgColor
        manageowntaskyes.layer.borderWidth = 2
        removealltaskyes.layer.borderColor = UIColor.blue.cgColor
        removealltaskno.layer.borderColor = UIColor.blue.cgColor
        removealltaskyes.layer.borderWidth = 2
        editalltaskyes.layer.borderColor = UIColor.blue.cgColor
        editalltaskno.layer.borderColor = UIColor.blue.cgColor
        editalltaskyes.layer.borderWidth = 2
        invitememberyes.layer.borderColor = UIColor.blue.cgColor
        invitememberno.layer.borderColor = UIColor.blue.cgColor
        invitememberyes.layer.borderWidth = 2
        removememberyes.layer.borderColor = UIColor.blue.cgColor
        removememberno.layer.borderColor = UIColor.blue.cgColor
        removememberyes.layer.borderWidth = 2
        manageprojectyes.layer.borderColor = UIColor.blue.cgColor
        manageprojectno.layer.borderColor = UIColor.blue.cgColor
        manageprojectyes.layer.borderWidth = 2
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
