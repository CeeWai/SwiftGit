////
////  projectdetail1ViewController.swift
////  Taskr
////
////  Created by Sebastian on 28/6/20.
////  Copyright © 2020 Sebastian. All rights reserved.
////
//
//import UIKit
//
//class projectdetail1ViewController: UIViewController {
//
//
//    @IBOutlet var label1: UILabel!
//    @IBOutlet var label2: UILabel!
//    @IBOutlet var label3: UILabel!
//    @IBOutlet var scrollview1: UIScrollView!
//    @IBOutlet var scrollview2: UIScrollView!
//    @IBOutlet var scrollview3: UIScrollView!
//    @IBOutlet var view1: UIView!
//    @IBOutlet var view2: UIView!
//    @IBOutlet var view3: UIView!
//    @IBOutlet var addtask: UIButton!
//    @IBOutlet var board: UIButton!
//    @IBOutlet var ganttchart: UIButton!
//
//    @IBOutlet var navtitle: UINavigationItem!
//    var popoverstatus = 0;
//    var projectItem : Project?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navtitle.title=projectItem?.projectName
//        addtask.layer.cornerRadius = 10
//        addtask.layer.borderColor = UIColor.systemRed.cgColor
//        addtask.layer.borderWidth = 2;
//        addtask.layer.backgroundColor = UIColor.black.cgColor
//        /*view1.layer.borderWidth = 2;
//        view1.layer.cornerRadius = 10
//        view2.layer.borderWidth = 2;
//        view2.layer.cornerRadius = 10
//        view3.layer.borderWidth = 2;
//        view3.layer.cornerRadius = 10*/
//        board.layer.borderWidth = 2;
//        board.layer.cornerRadius = 7
//        board.layer.borderColor = UIColor.systemRed.cgColor
//        ganttchart.layer.borderWidth = 2;
//        ganttchart.layer.cornerRadius = 7
//        ganttchart.layer.borderColor = UIColor.systemRed.cgColor
//        label1.layer.borderWidth = 2;
//        label1.layer.cornerRadius = 7
//        label1.layer.borderColor = UIColor.systemRed.cgColor
//        label1.clipsToBounds = true
//        label2.layer.borderWidth = 2;
//        label2.layer.cornerRadius = 7
//        label2.layer.borderColor = UIColor.systemRed.cgColor
//        label2.clipsToBounds = true
//        label3.layer.borderWidth = 2;
//        label3.layer.cornerRadius = 7
//        label3.layer.borderColor = UIColor.systemRed.cgColor
//        label3.clipsToBounds = true
//        view1.layer.borderWidth = 2;
//        view1.layer.cornerRadius = 7
//        view1.layer.borderColor = UIColor.systemRed.cgColor
//        view2.layer.borderWidth = 2;
//        view2.layer.cornerRadius = 7
//        view2.layer.borderColor = UIColor.systemRed.cgColor
//        view3.layer.borderWidth = 2;
//        view3.layer.cornerRadius = 7
//        view3.layer.borderColor = UIColor.systemRed.cgColor
//
//
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    @IBOutlet var popover: UIView!
//
//    @IBAction func popovermenu(_ sender: Any) {
//        //popover.frame.origin.x = CGFloat(10.0)
//        //popover.frame.origin.x = CGFloat(44.0)
//        if popoverstatus == 1{
//            self.popover.removeFromSuperview()
//            popoverstatus = 0
//        }
//        if popoverstatus == 0{
//            self.view.addSubview(popover)
//            let superView = self.view.superview
//            superView!.addSubview(popover)
//            popover.translatesAutoresizingMaskIntoConstraints = false
//
//            NSLayoutConstraint.activate([
//
//                    // 5
//                    NSLayoutConstraint(item: popover, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1.0, constant: 60),
//
//                    // 6
//                    NSLayoutConstraint(item: popover, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1.0, constant: 160),
//
//                    // 7
//                    popover.heightAnchor.constraint(equalToConstant:200),
//
//                    //8
//                    popover.widthAnchor.constraint(equalToConstant: 300)
//                ])
//            popoverstatus = 1
//        }
//
//
//    }
//
//    @IBAction func closepopover(_ sender: Any) {
//        self.popover.removeFromSuperview()
//    }
//    override func prepare(for segue: UIStoryboardSegue,
//        sender: Any?){
//        if(segue.identifier == "seguetomember")
//         {
//        let detailViewController = segue.destination as!
//         MemberViewController
//            detailViewController.projectItem = self.projectItem
//        }
//         if(segue.identifier == "seguetonoti")
//          {
//         let detailViewController = segue.destination as! projectnotificationViewController
//        detailViewController.projectItem = self.projectItem
//         }
//    }
//}

import UIKit

class projectdetail1ViewController: UIViewController {

 
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    @IBOutlet var scrollview1: UIScrollView!
    @IBOutlet var scrollview2: UIScrollView!
    @IBOutlet var scrollview3: UIScrollView!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var addtask: UIButton!
    @IBOutlet var board: UIButton!
    @IBOutlet var ganttchart: UIButton!
    
    @IBOutlet var navtitle: UINavigationItem!
    var popoverstatus = 0;
    var projectItem : Project?
    override func viewDidLoad() {
        super.viewDidLoad()
        navtitle.title=projectItem?.projectName
        addtask.layer.cornerRadius = 10
        addtask.layer.borderColor = UIColor.systemRed.cgColor
        addtask.layer.borderWidth = 2;
        addtask.layer.backgroundColor = UIColor.black.cgColor
        /*view1.layer.borderWidth = 2;
        view1.layer.cornerRadius = 10
        view2.layer.borderWidth = 2;
        view2.layer.cornerRadius = 10
        view3.layer.borderWidth = 2;
        view3.layer.cornerRadius = 10*/
        board.layer.borderWidth = 2;
        board.layer.cornerRadius = 7
        board.layer.borderColor = UIColor.systemRed.cgColor
        ganttchart.layer.borderWidth = 2;
        ganttchart.layer.cornerRadius = 7
        ganttchart.layer.borderColor = UIColor.systemRed.cgColor
        label1.layer.borderWidth = 2;
        label1.layer.cornerRadius = 7
        label1.layer.borderColor = UIColor.systemRed.cgColor
        label1.clipsToBounds = true
        label2.layer.borderWidth = 2;
        label2.layer.cornerRadius = 7
        label2.layer.borderColor = UIColor.systemRed.cgColor
        label2.clipsToBounds = true
        label3.layer.borderWidth = 2;
        label3.layer.cornerRadius = 7
        label3.layer.borderColor = UIColor.systemRed.cgColor
        label3.clipsToBounds = true
        view1.layer.borderWidth = 2;
        view1.layer.cornerRadius = 7
        view1.layer.borderColor = UIColor.systemRed.cgColor
        view2.layer.borderWidth = 2;
        view2.layer.cornerRadius = 7
        view2.layer.borderColor = UIColor.systemRed.cgColor
        view3.layer.borderWidth = 2;
        view3.layer.cornerRadius = 7
        view3.layer.borderColor = UIColor.systemRed.cgColor
        
        
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
    override func prepare(for segue: UIStoryboardSegue,
        sender: Any?){
        if(segue.identifier == "seguetomember")
         {
        let detailViewController = segue.destination as!
         MemberViewController
            detailViewController.projectItem = self.projectItem
        }
        if(segue.identifier == "seguetoaddtask")
         {
        let detailViewController = segue.destination as!
         addtask1ViewController
            detailViewController.projectItem = self.projectItem
        }
    }
}
