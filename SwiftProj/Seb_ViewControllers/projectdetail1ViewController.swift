//
//  projectdetail1ViewController.swift
//  Taskr
//
//  Created by Sebastian on 28/6/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import UIKit

class projectdetail1ViewController: UIViewController,
UITableViewDelegate, UITableViewDataSource{
    var taskList : [ProjectTask] = []
    @IBOutlet var tableview1: UITableView!
    @IBOutlet var addtask: UIButton!

    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn3: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var navtitle: UINavigationItem!
    var popoverstatus = 0;
    var projectItem : Project?
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
         navtitle.title = "Board"
               addtask.layer.cornerRadius = 40
               addtask.layer.borderColor = UIColor.systemRed.cgColor
               addtask.layer.borderWidth = 2;
               addtask.layer.backgroundColor = UIColor.black.cgColor
               addtask.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
       
          
               btn1.layer.cornerRadius = 10
               btn1.layer.borderColor = UIColor.systemRed.cgColor
               btn1.layer.borderWidth = 2;
       
               btn2.layer.cornerRadius = 10
               btn2.layer.borderColor = UIColor.systemRed.cgColor
               btn2.layer.borderWidth = 0;
             
               btn3.layer.cornerRadius = 10
               btn3.layer.borderColor = UIColor.systemRed.cgColor
               btn3.layer.borderWidth = 0;
     
               print(projectItem?.projectId!)
               taskList = ProjectTaskDataManager.loadtaskbystatusandprojectid(projectid: (projectItem?.projectId!)!, status: 0)
               if (self.restorationIdentifier == "detailtodo"){
                   btn1.layer.cornerRadius = 10
                   btn1.layer.borderColor = UIColor.systemRed.cgColor
                   btn1.layer.borderWidth = 2;
              
                   taskList = ProjectTaskDataManager.loadtaskbystatusandprojectid(projectid: (projectItem?.projectId!)!, status: 0)
               }
               if (self.restorationIdentifier == "detailongoing"){
                   btn2.layer.cornerRadius = 10
                   btn2.layer.borderColor = UIColor.systemRed.cgColor
                   btn2.layer.borderWidth = 2;
                 
                   taskList = ProjectTaskDataManager.loadtaskbystatusandprojectid(projectid: (projectItem?.projectId!)!, status: 1)
               }
               if (self.restorationIdentifier == "detailcomplete"){
                   btn3.layer.cornerRadius = 10
                   btn3.layer.borderColor = UIColor.systemRed.cgColor
                   btn3.layer.borderWidth = 2;

                   taskList = ProjectTaskDataManager.loadtaskbystatusandprojectid(projectid: (projectItem?.projectId!)!, status: 2)
               }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden=true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismisspopover")
        view.addGestureRecognizer(tap)
        navtitle.title = "Board"
               addtask.layer.cornerRadius = 40
               addtask.layer.borderColor = UIColor.systemRed.cgColor
               addtask.layer.borderWidth = 2;
               addtask.layer.backgroundColor = UIColor.black.cgColor
               addtask.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
               btn1.layer.cornerRadius = 10
               btn1.layer.borderColor = UIColor.systemRed.cgColor
               btn1.layer.borderWidth = 2;
       
               btn2.layer.cornerRadius = 10
               btn2.layer.borderColor = UIColor.systemRed.cgColor
               btn2.layer.borderWidth = 0;
           
               btn3.layer.cornerRadius = 10
               btn3.layer.borderColor = UIColor.systemRed.cgColor
               btn3.layer.borderWidth = 0;
           
               print(projectItem?.projectId!)
               taskList = ProjectTaskDataManager.loadtaskbystatusandprojectid(projectid: (projectItem?.projectId!)!, status: 0)
               if (self.restorationIdentifier == "detailtodo"){
                   btn1.layer.cornerRadius = 10
                   btn1.layer.borderColor = UIColor.systemRed.cgColor
                   btn1.layer.borderWidth = 2;
        
                   taskList = ProjectTaskDataManager.loadtaskbystatusandprojectid(projectid: (projectItem?.projectId!)!, status: 0)
               }
               if (self.restorationIdentifier == "detailongoing"){
                   btn2.layer.cornerRadius = 10
                   btn2.layer.borderColor = UIColor.systemRed.cgColor
                   btn2.layer.borderWidth = 2;
             
                   taskList = ProjectTaskDataManager.loadtaskbystatusandprojectid(projectid: (projectItem?.projectId!)!, status: 1)
               }
               if (self.restorationIdentifier == "detailcomplete"){
                   btn3.layer.cornerRadius = 10
                   btn3.layer.borderColor = UIColor.systemRed.cgColor
                   btn3.layer.borderWidth = 2;
        	
                   taskList = ProjectTaskDataManager.loadtaskbystatusandprojectid(projectid: (projectItem?.projectId!)!, status: 2)
               }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var listcount : Int = 0
        if tableView == tableview1{
            listcount = taskList.count
        }
        return listcount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : taskTableViewCell = tableView
        .dequeueReusableCell (withIdentifier: "TaskCell", for: indexPath)
        as!     taskTableViewCell
        if tableView == tableview1{
                          let p = taskList[indexPath.row]
                          cell.tasknem.text = p.taskname!
        }
        return cell
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
    @IBOutlet var popover2: UIView!
    @IBOutlet var popover3: UIView!
    @objc func dismisspopover() {
        popover.removeFromSuperview()
        if popover.isDescendant(of: view){
            popover.removeFromSuperview()
        }
    }
    @IBAction func popovermenu(_ sender: Any) {
        //popover.frame.origin.x = CGFloat(10.0)
        //popover.frame.origin.x = CGFloat(44.0)
        if (self.restorationIdentifier == "detailtodo"){
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
                        popover.heightAnchor.constraint(equalToConstant:70),
            
                        //8
                        popover.widthAnchor.constraint(equalToConstant: 300)
                    ])
                popoverstatus = 1
            }
        }
    }
    
    @IBAction func btn1pressed(_ sender: Any) {
        btn1.layer.borderWidth = 2;
        btn2.layer.borderWidth = 0;
        btn3.layer.borderWidth = 0;
        
        taskList = ProjectTaskDataManager.loadtaskbystatusandprojectid(projectid: (projectItem?.projectId!)!, status: 0)
        tableview1.reloadData()
    }
    
    @IBAction func btn2pressed(_ sender: Any) {
        btn1.layer.borderWidth = 0;
        btn2.layer.borderWidth = 2;
        btn3.layer.borderWidth = 0;
 
        taskList = ProjectTaskDataManager.loadtaskbystatusandprojectid(projectid: (projectItem?.projectId!)!, status: 1)
        tableview1.reloadData()
        
    }
    @IBAction func btn3pressed(_ sender: Any) {
        btn1.layer.borderWidth = 0;
        btn2.layer.borderWidth = 0;
        btn3.layer.borderWidth = 2;

        taskList = ProjectTaskDataManager.loadtaskbystatusandprojectid(projectid: (projectItem?.projectId!)!, status: 2)
        tableview1.reloadData()
        
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
        if(segue.identifier == "seguetoaddmemo")
         {
        let detailViewController = segue.destination as!
         addtask1ViewController
            detailViewController.projectItem = self.projectItem
            detailViewController.seguetype = "add"
        }
        if(segue.identifier == "seguetoongoing")
         {
        let detailViewController = segue.destination as!
         projectdetail1ViewController
            detailViewController.projectItem = self.projectItem
        }
        if(segue.identifier == "seguetotodo")
         {
        let detailViewController = segue.destination as!
         projectdetail1ViewController
            detailViewController.projectItem = self.projectItem
        }
        if(segue.identifier == "seguetocompete")
         {
        let detailViewController = segue.destination as!
         projectdetail1ViewController
            detailViewController.projectItem = self.projectItem
        }
        if(segue.identifier == "seguetocalender")
         {
        let detailViewController = segue.destination as!
         DefaultViewController1
            detailViewController.projectItem = self.projectItem
        }
        if(segue.identifier == "seguetotask")
        {
        
            let detailViewController =
                segue.destination as!
            projecttaskdetailViewController
            var myIndexPath : IndexPath?
            var projecttask : ProjectTask?
            myIndexPath = self.tableview1.indexPathForSelectedRow
            projecttask = taskList[myIndexPath!.row]
            if(myIndexPath != nil)
            {
                // Set the movieItem field with the movie
                // object selected by the user.
                //
                detailViewController.projectItem = projectItem
                detailViewController.projecttask = projecttask!
            
            }
        }
    }
}
