//
//  addtask1ViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 10/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import FirebaseAuth
class addtask1ViewController: UIViewController,UITextViewDelegate{


    @IBOutlet var name: UITextField!
    @IBOutlet var goal: UITextView!
    var toolBar = UIToolbar()
    var startdateraw :Date?
    var enddateraw :Date?
    var datePicker = UIDatePicker()
    var currentuser = Auth.auth().currentUser
    var userid = ""
    var taskgoal = ""
    var projectItem : Project?
    var seguetype : String = ""
    @IBOutlet weak var add_update: UIButton!
    var projecttask : ProjectTask?
    @IBOutlet weak var enddate: UIButton!
    @IBOutlet var nextbtn: UIButton!
    var date : Date?
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden=true
        super.viewDidLoad()
        userid = currentuser!.uid
        goal.delegate = self
        let bottomline = CALayer()
        bottomline.frame = CGRect(x:0,y:name.frame.height - 2, width: name.frame.width,height: 0.5)
        bottomline.backgroundColor = UIColor.systemRed.cgColor
        let bottomline2 = CALayer()
        bottomline2.frame = CGRect(x:0,y:name.frame.height - 2, width: name.frame.width,height: 0.5)
        bottomline2.backgroundColor = UIColor.systemRed.cgColor
        let bottomline3 = CALayer()
        bottomline3.frame = CGRect(x:0,y:name.frame.height - 2, width: name.frame.width,height: 0.5)
        bottomline3.backgroundColor = UIColor.systemRed.cgColor
        name.borderStyle = .none
        name.layer.addSublayer(bottomline2)
        name.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemRed])
        goal.text = "Description"
        goal.textColor = UIColor.lightGray
        goal.layer.borderWidth = 0.5;
        goal.layer.cornerRadius = 7
        goal.layer.borderColor = UIColor.systemRed.cgColor
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if seguetype == "add" {
            add_update.setTitle("Add Memo", for: .normal)
            self.navigationController?.isNavigationBarHidden=true
        }
        if seguetype == "update" {
            add_update.setTitle("Update Memo", for: .normal)
            self.navigationController?.isNavigationBarHidden=true
            name.text = projecttask?.taskname
            goal.text = projecttask?.taskgoal
            date = projecttask?.enddate
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
               if projecttask?.enddate != nil{
                     enddate.setTitle(dateFormatter.string(from: date!), for: .normal)
                     enddateraw = date!
                     }else{
                         enddate.setTitle("", for: .normal)
                     }
                     
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if goal.textColor == UIColor.lightGray{
            goal.text = ""
            goal.textColor = UIColor.systemRed
        }
    }
    @IBAction func pressednextbtn(_ sender: Any) {
        var taskname = name.text
        taskgoal = goal.text
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = Date()
        let dateString = formatter.string(from: now)
        let datenow = formatter.date(from: dateString)
        if seguetype == "add" {
                    //ProjectTaskDataManager.insertOrReplace(projecttask: ProjectTask(taskid: 0, projectid: projectItem?.projectId!, userid: userid, taskname: taskname, taskgoal: taskgoal, startdate: datenow, enddate: enddateraw,status: 0, valid: 1))
        }
        if seguetype == "update" {
            //ProjectTaskDataManager.updatememo(taskid: (projecttask?.taskid)!, taskname: taskname!, taskgoal: taskgoal, enddate: enddateraw!)
            
        }
    }
    @IBAction func duedatepressed(_ sender: Any) {
        datePicker = UIDatePicker.init()
            datePicker.backgroundColor = UIColor.systemBackground
            //datePicker.setValue(UIColor.systemRed.cgColor, forKeyPath: "textColor")
        
            datePicker.autoresizingMask = .flexibleWidth
            datePicker.datePickerMode = .date

            datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
            datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self.view.addSubview(datePicker)

            toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
            toolBar.barStyle = .blackTranslucent
            toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
            toolBar.sizeToFit()
            self.view.addSubview(toolBar)
        }
// display date picker
        @objc func dateChanged(_ sender: UIDatePicker?) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none

            date = sender?.date
                enddate.setTitle(dateFormatter.string(from: datePicker.date), for: .normal)
                print(date)
                enddateraw = date!
            
        }

        @objc func onDoneButtonClick() {
            toolBar.removeFromSuperview()
            datePicker.removeFromSuperview()
        }
    override func prepare(for segue: UIStoryboardSegue,
        sender: Any?){
        if(segue.identifier == "seguetoassignmember")
         {
            var taskname = name.text
            taskgoal = goal.text
        let detailViewController = segue.destination as! addtask2ViewController
            detailViewController.projecttaskItem = ProjectTask(taskid: 0, projectid: projectItem?.projectId!, userid: userid, taskname: taskname!, taskgoal: taskgoal, startdate: startdateraw!, enddate: enddateraw!,status: 0, valid: 1)
            detailViewController.projectItem = self.projectItem!
        }
        if(segue.identifier == "seguetoprojectdetail")
         {
        let detailViewController = segue.destination as!
         projectdetail1ViewController
            detailViewController.projectItem = self.projectItem
        }
        if(segue.identifier == "seguetotaskdetail")
         {
            var taskname = name.text
              userid = "1nC1S8cngKXT2da4CmaiV2sb4Ia2"
              taskgoal = goal.text
              let formatter = DateFormatter()
              formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              let now = Date()
              let dateString = formatter.string(from: now)
              let datenow = formatter.date(from: dateString)
        let detailViewController = segue.destination as!
         projecttaskdetailViewController
            detailViewController.projectItem = self.projectItem
            if seguetype == "add" {
  
                            ProjectTaskDataManager.insertOrReplace(projecttask: ProjectTask(taskid: 0, projectid: projectItem?.projectId!, userid: userid, taskname: taskname, taskgoal: taskgoal, startdate: datenow, enddate: enddateraw,status: 0, valid: 1))
                var id = ProjectTaskDataManager.loadtaskbytask() 
   
                    detailViewController.projecttask = ProjectTaskDataManager.loadtaskbyid(taskid: id)[0]
            
            }
            if seguetype == "update" {
                 ProjectTaskDataManager.updatememo(taskid: (projecttask?.taskid)!, taskname: taskname!, taskgoal: taskgoal, enddate: enddateraw!)
                detailViewController.projecttask = ProjectTaskDataManager.loadtaskbyid(taskid: (projecttask?.taskid!)!)[0]
                
            }
        } //segue and action for add and update
    }
}

