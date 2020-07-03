//
//  projectdetail1ViewController.swift
//  Taskr
//
//  Created by Sebastian on 28/6/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import UIKit

class projectdetail1ViewController: UIViewController {

    @IBOutlet var view1: UIView!
    
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var addrole: UIButton!
    
    @IBOutlet var navtitle: UINavigationItem!
    var popoverstatus = 0;
    var projectItem : Project?
    override func viewDidLoad() {
        super.viewDidLoad()
        navtitle.title=projectItem?.projectName
        addrole.layer.cornerRadius = 10
        view1.layer.borderWidth = 2;
        view1.layer.cornerRadius = 10
        view2.layer.borderWidth = 2;
        view2.layer.cornerRadius = 10
        view3.layer.borderWidth = 2;
        view3.layer.cornerRadius = 10
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet var popover: UIView!
    
    @IBAction func popovermenu(_ sender: Any) {
        //popover.frame.origin.x = CGFloat(10.0)
        //popover.frame.origin.x = CGFloat(44.0)
        if popoverstatus == 1{
            self.popover.removeFromSuperview()
            popoverstatus = 0
        }
        if popoverstatus == 0{
            self.view.addSubview(popover)
            let superView = self.view.superview
            superView!.addSubview(popover)
            popover.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([

                    // 5
                    NSLayoutConstraint(item: popover, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1.0, constant: 60),

                    // 6
                    NSLayoutConstraint(item: popover, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1.0, constant: 160),

                    // 7
                    popover.heightAnchor.constraint(equalToConstant:200),
        
                    //8
                    popover.widthAnchor.constraint(equalToConstant: 300)
                ])
            popoverstatus = 1
        }
        
        
    }
    
    @IBAction func closepopover(_ sender: Any) {
        self.popover.removeFromSuperview()
    }
    
}
